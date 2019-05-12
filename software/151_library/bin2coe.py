#!/bin/env python

# import sys

# def main():
#     if(len(sys.argv) != 2):
#         print("Usage: %s <binfile>" % (sys.argv[0]))
#         return
#     infile = open(sys.argv[1], "rb", 0)
#     outfile = open(sys.argv[1].replace(".bin", ".coe"), "w", 1)

#     outfile.write("memory_initialization_radix=16;\nmemory_initialization_vector=\n");

#     infile.seek(0, 2)
#     inlen = infile.tell()
#     infile.seek(0, 0)

#     for i in range(inlen):
#         outfile.write("%2x" % (infile.read(1)[0]))
#         if(i == (inlen - 1)):
#             outfile.write(";\n")
#         else:
#             outfile.write(",\n")
    
#     infile.close()
#     outfile.close()

# main()

#!/usr/bin/env python
# based on Lequn Chen's Code
import os
import sys
import binascii

INPUT = sys.argv[1]
OUTPUT = sys.argv[2]

s = open(INPUT, 'rb').read()
s = binascii.b2a_hex(s)
with open(OUTPUT, 'wb') as f:
    f.write("memory_initialization_radix=16;\nmemory_initialization_vector=\n".encode("utf-8"));
    for i in range(0, len(s), 8):
        f.write(s[i+6:i+8])
        f.write(s[i+4:i+6])
        f.write(s[i+2:i+4])
        f.write(s[i:i+2])
        f.write(b'\n')