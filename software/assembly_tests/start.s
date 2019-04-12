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


#Test ADDI
#We did not include special instruction set support for overow checks on integer arithmetic
#operations in the base instruction set
li x10, 0x00000001
addi x11,x10,2
li x20, 9

#Test  SLTIU
li x10, 0x00000001
sltiu x11, x10,-0x1
li x20,10

#Test  SLTI
li x10, 0x00000001
slti x11, x10,-0x1
li x20,11

#Test XORI
li x10, 0xaabbccdd
xori x11, x10, 0x7FF
li x20, 12

#Test XORI
xori x11, x10, -1
li x20, 13

#Test ORI
ori x11, x10, -1
li x20, 14

#Test ORI
ori x11, x10, 0
li x20, 15

#Test ANDI
andi x11,x10,0
li x20, 16

#Test SLLI
slli x11,x10,4
li x20,17

#Test SRLI
srli x11,x10,4
li x20,18

#Test SRAI
srai x11,x10,4
li x20,19

#Test SRAI
li x10, 0x12345678
srai x11,x10,4
li x20,20

#Test ADD
li x10, 0x00000001
li x12, 2
add x11,x10,x12
li x20, 21

#Test  SLTU
li x10, 0x00000001
li x12, -0x1
sltu x11, x10,x12
li x20,22

#Test  SLT
li x10, 0x00000001
li x12, -0x1
slt x11, x10,x12
li x20,23

#Test XOR
li x10, 0xaabbccdd
li x12, 0x7FF
xor x11, x10, x12
li x20, 24

#Test XOR
li x12, -1
xor x11, x10, x12
li x20, 25

#Test OR
or x11, x10, x12
li x20, 26

#Test ORx12
or x11, x10, x0
li x20, 27

#Test ANDI
and x11,x10,x0
li x20, 28

#Test SLLI
li x12, 0x10000004
sll x11,x10,x12
li x20,29

#Test SRLI
srl x11,x10,x12
li x20,30

#Test SRAI
sra x11,x10,x12
li x20,31

#Test SRAI
li x10, 0x12345678
sra x11,x10,x12
li x20,32

#Test SUB
sub x11, x10, x12
li x20, 33

# Test BEQ
li x2, 0x100		# Set an initial value of x2
beq x0, x0, branch1	# This branch should succeed and jump to branch1
li x2, 0x123		# This shouldn't execute, but if it does x2 becomes an undesirable value
branch1: li x1, 0x500	# x1 now contains 500
li x20, 34		# Set the flag register
				# Now we check that x1 contains 500 and x2 contains 100

# Test BNE
li x2, 0x100		# Set an initial value of x2
bne x0, x0, branch2	# This branch should not succeed
li x2, 0x123		#x2 nowcontains 123
branch2: li x3, 0x500
li x20, 35		# Set the flag register
				# Now we check that x1 contains 500 and x2 contains 100

# Test BLT
li x1, 0x100
li x2, -0x1
li x4, 0x100
blt x2, x1, branch3 # This branch should succeed and jump to branch3
li x4, 0x036
branch3: li x3,0x036 #x3 nowcontains 36
li x20, 36

# Test BGE
bge x1, x2, branch4 # This branch should succeed and jump to branch4
li x4, 0x037
branch4: li x3,0x037 #x3 nowcontains 037
li x20, 37

# Test BLTU
bltu x2, x1, branch5 #This branch should not succeed
li x4, 0x038         #x3 now contains 038
branch5: li x3,0x038
li x20, 38

# Test BGEU
bgeu x2, x1, branch6 #This branch should succeed
li x4, 0x039
branch6: li x3,0x039 #x3 now contains 0x39
li x20, 39

#Test JAL
# jal x1, 0x8
j jump1
li x4, 0x40
li x3, 0x40
jump1: li x20, 40

Done: j Done

