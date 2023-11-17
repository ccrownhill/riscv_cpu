#!/usr/bin/env python3

import sys

if len(sys.argv) != 2:
    print("usage: format_assem_out.py file")
    sys.exit(1)

out = ""
with open(sys.argv[1], "r") as f:
    for line in f:
        line = line.strip()
        split = " ".join([line[i:i+2] for i in range(0, len(line), 2)])
        out += split + "\n"
        print(out)
with open(sys.argv[1], "w") as f:
        f.write(out)
