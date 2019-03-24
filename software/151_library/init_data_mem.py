#!/usr/bin/env python
# based on Lequn Chen's Code
import os
import sys
import binascii
import math
import random

OUTPUT=sys.argv[1]

with open(OUTPUT,'w') as f:
	for i in range(0,100):
		f.write(str(hex(random.randint(0,15))[2:]))
		f.write(str(hex(random.randint(0,15))[2:]))
		f.write(str(hex(random.randint(0,15))[2:]))
		f.write(str(hex(random.randint(0,15))[2:]))
		f.write(str(hex(random.randint(0,15))[2:]))
		f.write(str(hex(random.randint(0,15))[2:]))
		f.write(str(hex(random.randint(0,15))[2:]))
		f.write(str(hex(random.randint(0,15))[2:]))
		f.write('\n')