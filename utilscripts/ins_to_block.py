#!/usr/bin/env python3

import sys

if len(sys.argv) != 4:
    print(f"Usage: {sys.argv[0]} <block size> <input file> <output file>")
    sys.exit(1)

block_size = int(sys.argv[1])
block_size_words = int(block_size/4)

with open(sys.argv[2], "r") as f:
    contents = f.read()

contents = contents.replace("\n", " ")
contents = contents.replace("  ", " 0")
contents = contents.split(" ")

out = list()
for i in range(int(len(contents)/block_size_words)):
    tmp = list()
    for j in range(block_size_words):
        tmp.append(contents[i * block_size_words + j])
    out.append(''.join(reversed(tmp)))

with open(sys.argv[3], "w") as f:
    f.write("\n".join(out))
