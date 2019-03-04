//choose a conventional size of 32 integer registers for the base ISA, the address is 5-bit wide
`define XLEN                       32
`define REG_FILE_ADDR_WIDTH        5
`define BIOS_MEM_ADDR_WIDTH        12
//ALU Opcodes
`define ALU_ADD                   5'b00000
`define ALU_SLTU                  5'b00001
`define ALU_AND                   5'b00010
`define ALU_OR                    5'b00011
`define ALU_XOR                   5'b00100
`define ALU_SLL                   5'b00101
`define ALU_SRL_SRA               5'b00110
`define ALU_ADD_SFT               5'b01000
`define ALU_SUB                   5'b11000
`define ALU_SLT                   5'b11001