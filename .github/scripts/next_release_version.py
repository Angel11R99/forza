import re
import sys


_TAG_PATTERN = re.compile(
    r"v(?P<major>\d+)\.(?P<minor>\d+)\.(?P<patch>\d+)"
    r"(?:-(?P<channel>alpha|beta|rc)\.(?P<serial>\d+))?"
)
_CHANNELS = {"alpha", "beta", "rc"}


def _parse_tag(tag: str) -> tuple[int, int, int, str | None, int | None]:
    match = _TAG_PATTERN.fullmatch(tag)
    if not match:
        raise ValueError(f"Latest release tag is not a supported version: {tag}")
    return (
        int(match["major"]),
        int(match["minor"]),
        int(match["patch"]),
        match["channel"],
        int(match["serial"]) if match["serial"] else None,
    )


def _increment_patch(major: int, minor: int, patch: int) -> tuple[int, int, int]:
    if patch < 99:
        return major, minor, patch + 1
    if minor < 9:
        return major, minor + 1, 0
    return major + 1, 0, 0


def next_version(tag: str, release_type: str, existing_tags: set[str] | None = None) -> str:
    major, minor, patch, current_channel, _ = _parse_tag(tag)
    if release_type in _CHANNELS:
        if current_channel is None:
            major, minor, patch = _increment_patch(major, minor, patch)
        base = f"v{major}.{minor}.{patch}"
        tags = existing_tags or {tag}
        serials = []
        for existing_tag in tags:
            try:
                tag_major, tag_minor, tag_patch, channel, serial = _parse_tag(existing_tag)
            except ValueError:
                continue
            if (tag_major, tag_minor, tag_patch, channel) == (
                major,
                minor,
                patch,
                release_type,
            ) and serial is not None:
                serials.append(serial)
        return f"{base}-{release_type}.{max(serials, default=0) + 1}"

    if release_type == "major":
        major, minor, patch = major + 1, 0, 0
    elif release_type == "minor":
        if minor < 9:
            minor, patch = minor + 1, 0
        else:
            major, minor, patch = major + 1, 0, 0
    elif release_type == "patch":
        # Selecting patch after a prerelease publishes the stable version of that build.
        if current_channel is None:
            major, minor, patch = _increment_patch(major, minor, patch)
    else:
        raise ValueError(f"Unsupported release type: {release_type}")

    return f"v{major}.{minor}.{patch}"


if __name__ == "__main__":
    try:
        if len(sys.argv) < 3:
            raise ValueError("Usage: next_release_version.py LATEST_TAG RELEASE_TYPE [TAGS_FILE]")
        tags = set()
        if len(sys.argv) > 3:
            with open(sys.argv[3], encoding="utf-8") as tag_file:
                tags = {line.strip() for line in tag_file if line.strip()}
        print(next_version(sys.argv[1], sys.argv[2], tags))
    except (IndexError, ValueError) as error:
        raise SystemExit(str(error)) from error
