import subprocess
import sys
from pathlib import Path


def concat_files(files: list[Path]) -> bytes:
    return "\n\n".join(
        f"=== File: {path.resolve().as_posix()} ===\n{path.read_text()}"
        for path in files
    ).encode()


def process_files(args: list[str]) -> int:
    dir, files = args[1], args[2:]

    dir_path = Path(dir)
    data = concat_files([dir_path / f for f in files])
    rc = subprocess.run(["fish", "-ic", "yi"], input=data).returncode
    print(f"Done! Processed {len(files)} files.")
    return rc


if __name__ == "__main__":
    raise SystemExit(process_files(sys.argv))
