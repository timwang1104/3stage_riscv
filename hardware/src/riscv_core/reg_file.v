
`include "/home/user/eecs151/3stage_riscv/hardware/src/riscv_core/util.vh"
`include "/home/user/eecs151/3stage_riscv/hardware/src/riscv_core/defines.v"

module reg_file
(
    input clk,
    input we,
    input [`REG_FILE_ADDR_WIDTH-1:0] rs1, rs2, rd,
    input [`XLEN-1:0] wd,
    output [`XLEN-1:0] data1, data2
);
    reg[31:0] reg_array [`pow2(`REG_FILE_ADDR_WIDTH)-1:0];

    // initial begin
    // 	reg_array[0]=0;
    // end

    always @(posedge clk) begin
		if (we && rd!=0) begin
    		reg_array[rd]<=wd;
    	end
    end

    assign data1 =rs1==0?0:reg_array[rs1];
    assign data2 =rs2==0?0:reg_array[rs2];

endmodule
