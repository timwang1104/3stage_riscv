import os
import sys
import binascii

INPUT = sys.argv[1]
OUTPUT = sys.argv[2]

s = open(INPUT, 'rb').read()
s = binascii.b2a_hex(s)
value=['']*4
with open(OUTPUT, 'w') as f:
    for i in range(0, len(s), 8):
        for offset in range(4):
            value[offset]=s[i+6-offset*2:i+8-offset*2]
            try:
                f.write('{:08b}'.format(int(value[offset],16)).replace('0b',''))
            except ValueError:
                f.write('{:08b}'.format(0).replace('0b',''))
        f.write('\n')