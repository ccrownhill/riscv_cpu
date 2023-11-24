#!/usr/bin/env python3

import sys

if len(sys.argv) != 2:
    print("Usage: dist_count file.mem")
    sys.exit(1)

out = [0 for _ in range(256)]

with open(sys.argv[1], "r") as f:
    for line in f:
        line = line.replace("  ", " ")
        byte_data = line.strip().split(" ")
        for byte in byte_data:
            out[int(byte, 16)] += 1
            if out[int(byte,16)] >= 255:
                print([hex(o) for o in out])
                sys.exit(0)

