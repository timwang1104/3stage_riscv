.section    .start
.global     _start

_start:

# Follow a convention
# x1 = result register 1
# x2 = result register 2
# x10 = argument 1 register
# x11 = argument 2 register
# x20 = flag register

# Test LBU
li x9 , 0x10000000
lbu x10, 0(x9)	# Load memory data
lbu x11, 1(x9)	# Load memory data
lbu x12, 2(x9)	# Load memory data
lbu x13, 3(x9)	# Load memory data
lbu x14, 4(x9)	# Load memory data
lbu x15, 5(x9)	# Load memory data
lbu x16, 6(x9)	# Load memory data
lbu x17, 7(x9)	# Load memory data
li x20, 1		# Set the flag register to stop execution and inspect the result register

# Test LB
# li x9 , 0x10000000
lb x10, 0(x9)	# Load memory data
lb x11, 1(x9)	# Load memory data
lb x12, 2(x9)	# Load memory data
lb x13, 3(x9)	# Load memory data
lb x14, 4(x9)	# Load memory data
lb x15, 5(x9)	# Load memory data
lb x16, 6(x9)	# Load memory data
lb x17, 7(x9)	# Load memory data
li x20, 2		# Set the flag register to stop execution and inspect the result register

#Test LHU
# li x9 , 0x10000000
lhu x10, 0(x9)	# Load memory data
lhu x11, 1(x9)	# Load memory data
lhu x12, 2(x9)	# Load memory data
lhu x13, 3(x9)	# Load memory data
lhu x14, 4(x9)	# Load memory data
lhu x15, 5(x9)	# Load memory data
lhu x16, 6(x9)	# Load memory data
lhu x17, 7(x9)	# Load memory data
li x20, 3

#Test LH
lh x10, 0(x9)	# Load memory data
lh x11, 1(x9)	# Load memory data
lh x12, 2(x9)	# Load memory data
lh x13, 3(x9)	# Load memory data
lh x14, 4(x9)	# Load memory data
lh x15, 5(x9)	# Load memory data
lh x16, 6(x9)	# Load memory data
lh x17, 7(x9)	# Load memory data
li x20, 4

#Test SW
li x10, 0x11223344
sw x10, 0(x9)
lw x11, 0(x9)
li x20, 5 

#Test SH
lw x12, 4(x9)
sh x10, 4(x9)

lw x13, 8(x9)
sh x10, 9(x9)

lw x14, 12(x9)
sh x10, 14(x9)

lw x15, 16(x9)
sh x10, 19(x9)
li x20, 6

#Test SB
li x10, 0xaabbccdd

lw x12, 24(x9)
sb x10, 24(x9)

lw x13, 28(x9)
sb x10, 29(x9)

lw x14, 32(x9)
sb x10, 34(x9)

lw x15, 36(x9)
sb x10, 39(x9)
li x20, 7

#Test AUIPC
auipc x10, 0x10000
li x20, 8

# Test ADD
# li x10, 100		# Load argument 1 (rs1)
# li x11, 200		# Load argument 2 (rs2)
# add x1, x10, x11	# Execute the instruction being tested
# li x20, 1		# Set the flag register to stop execution and inspect the result register
# 			# Now we check that x1 contains 300
#### Done


# # Test BEQ
# li x2, 100		# Set an initial value of x2
# beq x0, x0, branch1	# This branch should succeed and jump to branch1
# li x2, 123		# This shouldn't execute, but if it does x2 becomes an undesirable value
# branch1: li x1, 500	# x1 now contains 500
# li x20, 2		# Set the flag register
# 			# Now we check that x1 contains 500 and x2 contains 100

Done: j Done

