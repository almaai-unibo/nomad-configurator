#!/usr/bin/python3
import sys
from pathlib import Path


file = Path(sys.argv[1])
assert file.exists(), f"File {file} does not exist"
assert file.is_file(), f"Path {file} is not a file"
assert file.suffix == '.template', f"File {file} is not a template file"

replacements = dict()
delete_file = False

for i in range(2, len(sys.argv)):
    arg = sys.argv[i]
    if '=' in arg:
        key, value = arg.split('=', 1)
        replacements[key] = value
    elif arg == '--delete' or arg == '-d':
        delete_file = True
    else:
        raise ValueError(f"Invalid argument {arg}")

with file.open() as f:
    for line in f.readlines():
        for key, value in replacements.items():
            key = f'__{key}__'
            line = line.replace(key, value)
        print(line, end='')

if delete_file:
    file.unlink()
