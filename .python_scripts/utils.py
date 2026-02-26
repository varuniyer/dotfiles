from pathlib import Path

import git


def get_tracked_files(dir: str) -> list[Path]:
    dir_path = Path(dir)
    repo = git.Repo(dir)
    files = [
        p for path, _ in repo.index.entries.keys() if (p := dir_path / path).is_file()
    ]
    if not files:
        print("No tracked files found")
    return files
