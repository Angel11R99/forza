import json
import os
import re
import subprocess
import sys


def gh(path):
    result = subprocess.run(["gh", "api", path], check=True, text=True, capture_output=True)
    return json.loads(result.stdout)


def gh_paginated(path):
    result = subprocess.run(["gh", "api", "--paginate", "--slurp", path], check=True, text=True, capture_output=True)
    return [item for page in json.loads(result.stdout) for item in page]


repo = os.environ["GH_REPO"]
pr_number = int(os.environ["PR_NUMBER"])
branch = os.environ["HEAD_REF"]
body = os.environ.get("PR_BODY") or ""
pr = gh(f"repos/{repo}/pulls/{pr_number}")
references = re.findall(r"(?im)^\s*(?:close[sd]?|fix(?:es|ed)?|resolve[sd]?)\s+#(\d+)\b", body)
if len(set(references)) != 1:
    sys.exit("PR must reference exactly one issue using 'Closes #N'.")
issue_number = int(references[0])
issue = gh(f"repos/{repo}/issues/{issue_number}")
if "pull_request" in issue:
    sys.exit("The referenced item is a pull request, not an issue.")
labels = {item["name"] for item in issue["labels"]}
if "status:approved" not in labels:
    sys.exit(f"Issue #{issue_number} is not approved (missing status:approved).")
if {"status:rejected", "status:duplicate"} & labels:
    sys.exit("Rejected or duplicate issues cannot be used for a contribution.")
if not re.fullmatch(rf"issue/{issue_number}-[a-z0-9]+(?:-[a-z0-9]+)*", branch):
    sys.exit(f"Branch must match issue/{issue_number}-short-description (lowercase ASCII).")
if pr["base"]["ref"] != "main":
    sys.exit("Contribution PRs must target main.")
open_prs = gh_paginated(f"repos/{repo}/pulls?state=open&per_page=100")
for other in open_prs:
    if other["number"] == pr_number:
        continue
    other_body = other.get("body") or ""
    if str(issue_number) in re.findall(r"(?im)^\s*(?:close[sd]?|fix(?:es|ed)?|resolve[sd]?)\s+#(\d+)\b", other_body):
        sys.exit(f"Another open PR #{other['number']} already targets issue #{issue_number}.")
print(f"PR #{pr_number} satisfies the contribution policy for issue #{issue_number}.")
