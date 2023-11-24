#!/usr/bin/env python3

import sys


if len(sys.argv) < 2:
    print("Usage: python TabRemove.py <file_path>,<file_path> ...")
    sys.exit(1)
for i in range(1,len(sys.argv),1):
	file_path = sys.argv[i]  

	try:
		out = ""
		with open(file_path, 'r') as file:
			content = file.readlines()
		for line in content:
			line = line.replace('\t', '    ')
			line = line.rstrip()
			stripped = line.lstrip()
			count = (len(line)-len(stripped))//4
			print(count)
			modified_content = "  " * count + stripped 
			out += modified_content + "\n"
		


		with open(file_path, 'w') as file:
			file.write(out)

		print("Tabs/4 spaces replaced with two spaces in the file:", file_path)

	except FileNotFoundError:
		print("File not found:", file_path)
		