import json
import os
import re
import subprocess
from difflib import SequenceMatcher


def gh_one(path):
    """Fetch one GitHub API resource as a dictionary."""
    result = subprocess.run(
        ["gh", "api", path], check=True, text=True, capture_output=True
    )
    data = json.loads(result.stdout)
    if not isinstance(data, dict):
        raise TypeError(f"Expected an object from GitHub API: {path}")
    return data


def gh_many(path):
    """Fetch a paginated GitHub API collection as a flat list."""
    result = subprocess.run(
        ["gh", "api", "--paginate", "--slurp", path],
        check=True, text=True, capture_output=True
    )
    pages = json.loads(result.stdout)
    if not isinstance(pages, list) or any(not isinstance(page, list) for page in pages):
        raise TypeError(f"Expected paginated lists from GitHub API: {path}")
    return [item for page in pages for item in page]


repo = os.environ["GH_REPO"]
number = int(os.environ["ISSUE_NUMBER"])
current = gh_one(f"repos/{repo}/issues/{number}")
all_issues = gh_many(f"repos/{repo}/issues?state=all&per_page=100&sort=created&direction=desc")
def words(value):
    return set(re.findall(r"[a-z0-9áéíóúüñ]+", value.lower()))


current_text = f"{current['title']} {current.get('body') or ''}"
current_words = words(current_text)
candidates = []
for other in all_issues:
    if other["number"] == number or "pull_request" in other:
        continue
    other_text = f"{other['title']} {other.get('body') or ''}"
    title_score = SequenceMatcher(None, current["title"].lower(), other["title"].lower()).ratio()
    left, right = current_words, words(other_text)
    overlap = len(left & right) / max(1, len(left | right))
    shared_labels = {label["name"] for label in current["labels"]} & {label["name"] for label in other["labels"]}
    category_bonus = 0.08 if shared_labels & {"type:bug", "type:feature", "type:enhancement"} else 0
    score = 0.55 * title_score + 0.45 * overlap + category_bonus
    if score >= 0.30:
        candidates.append((score, other["number"], other["title"], other["state"]))
candidates.sort(reverse=True)
if candidates:
    lines = [f"- #{n} ({state}): {title}" for _, n, title, state in candidates[:5]]
    message = "Possible related issues for **human review** (nothing was closed automatically):\n\n" + "\n".join(lines)
    subprocess.run(["gh", "issue", "comment", str(number), "--repo", repo, "--body", message], check=True)
