#!/usr/bin/env python3

import sys

if len(sys.argv) != 3:
    print("Usage: mem_to_csv in_filename out_filename")
    sys.exit(1)

out = ""
with open(sys.argv[1], "r") as f:
    for line in f:
        out += line.replace("  ", " ").replace(" ", "\n")

with open(sys.argv[2], "w") as f:
    f.write(out)
