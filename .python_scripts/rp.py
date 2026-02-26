import re
import sys
from pathlib import Path

from utils import get_tracked_files


def replace_in_files(files: list[Path], pattern: str, repl: str) -> int:
    regex = re.compile(pattern)

    for path in files:
        lines = path.read_text().splitlines()

        changed = False
        for i, line in enumerate(lines):
            if regex.search(line):
                print(f"{path.as_posix()}:{i + 1}:{line}")
                if "y" == input("Replace this line? (y/n) "):
                    lines[i] = regex.sub(repl, line)
                    changed = True

        if changed:
            path.write_text("\n".join(lines) + ("\n" if lines else ""))

    return 0


def main() -> int:
    dir, pat, repl = sys.argv[1:]
    files = get_tracked_files(dir)
    return replace_in_files(files, pat, repl)


if __name__ == "__main__":
    raise SystemExit(main())
