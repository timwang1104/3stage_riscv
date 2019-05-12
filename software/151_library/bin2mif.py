import os
import sys
import binascii

INPUT = sys.argv[1]
OUTPUT = sys.argv[2]

s = open(INPUT, 'rb').read()
s = binascii.b2a_hex(s)
with open(OUTPUT, 'w') as f:
    for i in range(0, len(s), 8):
        s1=s[i+6:i+8]
        s2=s[i+4:i+6]
        s3=s[i+2:i+4]
        s4=s[i:i+2]

        f.write('{:08b}'.format(int(s1,16)).replace('0b',''))
        f.write('{:08b}'.format(int(s2,16)).replace('0b',''))
        f.write('{:08b}'.format(int(s3,16)).replace('0b',''))
        f.write('{:08b}'.format(int(s4,16)).replace('0b',''))

        f.write('\n')