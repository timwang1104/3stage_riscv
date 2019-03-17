`include "/home/user/eecs151/3stage_riscv/hardware/src/riscv_core/util.vh"
`include "/home/user/eecs151/3stage_riscv/hardware/src/riscv_core/defines.v"

module reg_file
(
    input clk,
    input we,
    input [`REG_FILE_ADDR_WIDTH-1:0] adr1, adr2, rd,
    input [`XLEN-1:0] wd,
    input rst,
    output [`XLEN-1:0] rs1, rs2
);
    reg[31:0] reg_array [`pow2(`REG_FILE_ADDR_WIDTH)-1:0];

    always @(posedge clk) begin
        if(rst) begin
            reg_array[0]<=0;
        end
        else begin
            if (we && rd!=0) begin
                reg_array[rd]<=wd;
            end           
        end
    end

    assign rs1 =adr1==0?0:reg_array[adr1];
    assign rs2 =adr2==0?0:reg_array[adr2];

endmodule
