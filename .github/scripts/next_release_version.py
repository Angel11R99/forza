import re
import sys


def next_version(tag: str, release_type: str) -> str:
    match = re.fullmatch(r"v(\d+)\.(\d+)\.(\d+)", tag)
    if not match:
        raise ValueError(f"Latest release tag is not a supported version: {tag}")

    major, minor, patch = map(int, match.groups())
    if release_type == "major":
        major, minor, patch = major + 1, 0, 0
    elif release_type == "minor":
        if minor < 9:
            minor, patch = minor + 1, 0
        else:
            major, minor, patch = major + 1, 0, 0
    elif release_type == "patch":
        if patch < 99:
            patch += 1
        elif minor < 9:
            minor, patch = minor + 1, 0
        else:
            major, minor, patch = major + 1, 0, 0
    else:
        raise ValueError(f"Unsupported release type: {release_type}")

    return f"v{major}.{minor}.{patch}"


if __name__ == "__main__":
    try:
        print(next_version(sys.argv[1], sys.argv[2]))
    except (IndexError, ValueError) as error:
        raise SystemExit(str(error)) from error
