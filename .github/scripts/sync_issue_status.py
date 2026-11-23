import json
import os
import subprocess
import sys


def gh(*args):
    return subprocess.run(["gh", *args], check=True, text=True, capture_output=True)


repo = os.environ["GH_REPO"]
number = os.environ["ISSUE_NUMBER"]
event = json.load(open(os.environ["GITHUB_EVENT_PATH"], encoding="utf-8"))
action = event.get("action")
association = event.get("issue", {}).get("author_association", "")
if action == "labeled":
    selected = event["label"]["name"]
    protected = selected.startswith("status:") or selected == "contrib:exception-approved"
    if not protected:
        sys.exit(0)
    actor = event.get("sender", {}).get("login", "")
    permission = subprocess.run(["gh", "api", f"repos/{repo}/collaborators/{actor}/permission", "--jq", ".permission"], text=True, capture_output=True)
    bot_status_transition = actor.lower() == "github-actions[bot]" and selected in {"status:in-review", "status:completed"}
    if not bot_status_transition and actor.lower() != os.environ["REPO_OWNER"].lower() and (permission.returncode != 0 or permission.stdout.strip() not in {"admin", "maintain"}):
        print(f"Removing unauthorized status label {selected} from issue #{number}.")
        subprocess.run(["gh", "issue", "edit", number, "--repo", repo, "--remove-label", selected], check=False)
        sys.exit(0)
    statuses = ["status:pending-review", "status:approved", "status:rejected", "status:duplicate", "status:in-progress", "status:in-review", "status:completed"]
    if selected in statuses:
        for status in statuses:
            if status != selected:
                subprocess.run(["gh", "issue", "edit", number, "--repo", repo, "--remove-label", status], check=False)
elif action == "assigned":
    issue = event["issue"]
    labels = {label["name"] for label in issue["labels"]}
    if "status:approved" in labels:
        for status in ["status:pending-review", "status:in-progress", "status:in-review", "status:completed"]:
            if status != "status:in-progress":
                subprocess.run(["gh", "issue", "edit", number, "--repo", repo, "--remove-label", status], check=False)
        gh("issue", "edit", number, "--repo", repo, "--add-label", "status:in-progress")
elif action == "closed":
    issue = event["issue"]
    labels = {label["name"] for label in issue["labels"]}
    if "status:completed" in labels:
        print("Authorized completion label already applied.")
