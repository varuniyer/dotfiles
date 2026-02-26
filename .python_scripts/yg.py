import sys

from utils import get_tracked_files
from yf import process_files


def main() -> int:
    dir = sys.argv[1]
    return process_files(get_tracked_files(dir))


if __name__ == "__main__":
    raise SystemExit(main())
