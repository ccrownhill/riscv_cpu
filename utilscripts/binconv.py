#!/usr/bin/env python3

import sys

if len(sys.argv) != 2:
    print("usage: binconv.py file")
    sys.exit(1)

with open(sys.argv[1], "r") as f:
    for line in f:
        line = line.strip()
        line = "".join(line.split(" "))
        if line == '':
            continue
        num = int(line, 16)
        binstr = bin(num)[2:]
        padding_len = 32 - len(binstr)
        binstr = padding_len * "0" + binstr
        if binstr[-7:-5] == "00":
            print("I-type")
        elif binstr[-7:] == "0110011":
            print("R-type")
        elif binstr[-7:] == "1100011":
            print("B-type")
        rs1 = int(binstr[-20:-15], 2)
        rs2 = int(binstr[-25:-20], 2)
        rd = int(binstr[-12:-7], 2)
        print(f"rs1: {rs1}; rs2: {rs2}; rd: {rd}")
        print(line, binstr)
