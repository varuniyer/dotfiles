import subprocess
import sys
from pathlib import Path


def concat_files(files: list[Path]) -> tuple[int, bytes]:
    contents: list[str] = []
    for path in files:
        try:
            contents.append(
                f"=== File: {path.resolve().as_posix()} ===\n{path.read_text()}"
            )
        except UnicodeDecodeError:
            pass
    return len(contents), "\n\n".join(contents).encode()


def process_files(args: list[str]) -> int:
    dir, files = args[1], args[2:]

    dir_path = Path(dir)
    num_files, data = concat_files([dir_path / f for f in files])
    rc = subprocess.run(["fish", "-ic", "yi"], input=data).returncode
    print(f"Done! Yanked {num_files}/{len(files)} files.")
    return rc


if __name__ == "__main__":
    raise SystemExit(process_files(sys.argv))
