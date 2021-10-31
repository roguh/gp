#!/usr/bin/env python3
"""Print given files, but replace <GP_HELP_STRING> with `gp -h`."""
import os.path
import subprocess
import sys

STR_TO_REPLACE = "<GP_HELP_STRING>"
GP_HELP_STRING_CMD = "gp -h"


def main():
    if len(sys.argv) != 2:
        print(f"USAGE: {sys.argv[0]} [README_FILE]")
        sys.exit(1)

    fname = sys.argv[1]
    path = os.path.dirname(fname)

    cmd = os.path.join(path, GP_HELP_STRING_CMD).split()
    completed_process = subprocess.run(cmd, check=True, capture_output=True)
    gp_help_string = completed_process.stdout.decode("utf-8")

    with open(fname, "r", encoding="utf-8") as file:
        for line in file:
            print(line.replace(STR_TO_REPLACE, gp_help_string), end="")


if __name__ == "__main__":
    main()
