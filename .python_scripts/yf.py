import subprocess
import sys
from pathlib import Path


def concat_files(files: list[Path]) -> bytes:
    return "\n\n".join(
        f"=== File: {path.as_posix()} ===\n{path.read_text()}" for path in files
    ).encode()


def process_files(files: list[str], max_size: int = 1_000_000) -> int:
    if not files:
        print("Usage: yf <files...>")
        return 1

    data = concat_files([Path(f) for f in files])
    size = len(data)
    if size > max_size:
        print(f"Warning: Content size ({size} bytes) may be too large for OSC52")
        return 1

    rc = subprocess.run(["fish", "-ic", "yi"], input=data).returncode
    print(f"Done! Processed {len(files)} files.")
    return rc


def main(argv: list[str] | None = None) -> int:
    args = sys.argv if argv is None else argv
    files = args[1:]
    return process_files(files)


if __name__ == "__main__":
    raise SystemExit(main(sys.argv))
