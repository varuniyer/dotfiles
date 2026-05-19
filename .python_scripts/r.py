import subprocess
import sys
from pathlib import Path


def main():
    home = Path.home().as_posix()
    opts = {
        "b": f"backup {home} --exclude-file {home}/.restic-excludes.txt",
        "s": "snapshots",
        "p": "prune",
        "f": "forget",
    }
    cmd = f"/opt/homebrew/bin/restic --verbose {opts[sys.argv[2]]}"
    if len(sys.argv) > 3:
        cmd += " " + sys.argv[3]
    subprocess.run(cmd.split())


if __name__ == "__main__":
    main()
