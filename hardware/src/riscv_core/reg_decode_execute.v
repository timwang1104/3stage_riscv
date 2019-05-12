`include "/home/user/eecs151/3stage_riscv/hardware/src/riscv_core/defines.v"

module reg_decode_execute
(
	input              clk,
	input              flushE,
	input [`XLEN-1:0]  pc_plus4D,
	input [`XLEN-1:0]  jump_result_plus4D,
	input [`XLEN-1:0]  forward_rs1D,
	input [`XLEN-1:0]  forward_rs2D,
 
	input [6:0]        opcodeD,
	input [`XLEN-1:0]  immD,
	input [2:0]        funct3D,
	input [6:0]        funct7D,
	input [4:0]        adr1D,
	input [4:0]        adr2D,
	input [4:0]        rdD,
 
	//control signals 
	input [1:0]        pc_selD,
	input [4:0]        alu_ctlD,
	input              reg_writeD,
	input              inst_or_rs2D,
	input [1:0]        op_a_selD,
	input              op_b_selD,
	input              mem_accessD,
	input [1:0]        wb_selD,

	output [`XLEN-1:0] pc_plus4E,
	output [`XLEN-1:0] jump_result_plus4E,
	output [`XLEN-1:0] forward_rs1E,
	output [`XLEN-1:0] forward_rs2E,

	output [6:0]       opcodeE,
	output [`XLEN-1:0] immE,
	output [2:0]       funct3E,
	output [6:0]       funct7E,
	output [4:0]       adr1E,
	output [4:0]       adr2E,
	output [4:0]       rdE,

	output [4:0]       alu_ctlE,
	output             reg_writeE,
	output [1:0]       op_a_selE,
	output             op_b_selE,
	output [1:0]       wb_selE,
	output             mem_accessE
);

	reg [`XLEN-1:0] pc_plus4E_reg;
	reg [`XLEN-1:0] jump_result_plus4E_reg;
	reg [`XLEN-1:0] forward_rs1E_reg;
	reg [`XLEN-1:0] forward_rs2E_reg;

	reg [6:0]       opcodeE_reg;
	reg [`XLEN-1:0] immE_reg;
	reg [2:0]       funct3E_reg;
	reg [6:0]       funct7E_reg;
	reg [4:0]       adr1E_reg;
	reg [4:0]       adr2E_reg;
	reg [4:0]       rdE_reg;

	reg [4:0]       alu_ctlE_reg;
	reg             reg_writeE_reg;
	reg [1:0]       op_a_selE_reg;
	reg             op_b_selE_reg;
	reg             mem_accessE_reg;
	reg [1:0]       wb_selE_reg;


	always @(posedge clk) begin
		if (flushE) begin
			
			pc_plus4E_reg               <=0;
			jump_result_plus4E_reg      <=0;
			forward_rs1E_reg            <=0;
			forward_rs2E_reg            <=0;
         
			opcodeE_reg                 <=0;
			immE_reg                    <=0;
			funct3E_reg                 <=0;
			funct7E_reg                 <=0;
			adr1E_reg                   <=0;
			adr2E_reg                   <=0;
			rdE_reg                     <=0;
         
			alu_ctlE_reg                <=0;
			reg_writeE_reg              <=0;
			op_a_selE_reg               <=0;
			op_b_selE_reg               <=0;
			mem_accessE_reg             <=0;
			wb_selE_reg                 <=0;			
		end
		else begin
			pc_plus4E_reg               <= pc_plus4D;
			jump_result_plus4E_reg      <= jump_result_plus4D;
			forward_rs1E_reg            <= forward_rs1D;
			forward_rs2E_reg            <= forward_rs2D;
			opcodeE_reg                 <= opcodeD;
			immE_reg                    <= immD;
			funct3E_reg                 <= funct3D;
			funct7E_reg                 <= funct7D;
			adr1E_reg                   <= adr1D;
			adr2E_reg                   <= adr2D;
			rdE_reg                     <= rdD;
			alu_ctlE_reg                <= alu_ctlD;
			reg_writeE_reg              <= reg_writeD;
			op_a_selE_reg               <= op_a_selD;
			op_b_selE_reg               <= op_b_selD;
			mem_accessE_reg             <= mem_accessD;
			wb_selE_reg                 <= wb_selD;
		end
	end

	assign pc_plus4E                  =pc_plus4E_reg;
	assign jump_result_plus4E   = jump_result_plus4E_reg;
	assign forward_rs1E         = forward_rs1E_reg;
	assign forward_rs2E         = forward_rs2E_reg;
	assign opcodeE              = opcodeE_reg;
	assign immE                 = immE_reg;
	assign funct3E              = funct3E_reg;
	assign funct7E              = funct7E_reg;
	assign adr1E                = adr1E_reg;
	assign adr2E                = adr2E_reg;
	assign rdE                  = rdE_reg;
	assign alu_ctlE             = alu_ctlE_reg;
	assign reg_writeE           = reg_writeE_reg;
	assign op_a_selE            = op_a_selE_reg;
	assign op_b_selE            = op_b_selE_reg;
	assign wb_selE              = wb_selE_reg;
	assign mem_accessE          = mem_accessE_reg;

endmodule