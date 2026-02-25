import re
import sys
from pathlib import Path

import git


def replace_in_files(files: list[str], pattern: str, repl: str) -> int:
    regex = re.compile(pattern)

    for f in files:
        path = Path(f)
        if not path.is_file():
            continue
        lines = path.read_text().splitlines()

        changed = False
        for i, line in enumerate(lines):
            if regex.search(line):
                print(f"{f}:{i + 1}:{line}")
                if "y" == input("Replace this line? (y/n) "):
                    lines[i] = regex.sub(repl, line)
                    changed = True

        if changed:
            path.write_text("\n".join(lines) + ("\n" if lines else ""))

    return 0


def main(argv: list[str] | None = None) -> int:
    args = sys.argv if argv is None else argv
    if len(args) != 3:
        print("Usage: rp <from> <to>", file=sys.stderr)
        return 1

    _, pat, repl = args
    files = [str(path) for path, _ in git.Repo(".").index.entries.keys()]
    return replace_in_files(files, pat, repl)


if __name__ == "__main__":
    raise SystemExit(main(sys.argv))
