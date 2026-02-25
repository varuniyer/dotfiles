from pathlib import Path

import git

from yf import process_files


def main() -> int:
    repo = git.Repo(".")
    files = [p for path, _ in repo.index.entries.keys() if Path(p := str(path)).is_file()]
    if not files:
        print("No tracked files found")
        return 0
    return process_files(files)


if __name__ == "__main__":
    raise SystemExit(main())
