`include "/home/user/eecs151/3stage_riscv/hardware/src/riscv_core/defines.v"

module Riscv151 #(
    parameter CPU_CLOCK_FREQ = 50_000_000
)(
    input clk,
    input rst,

    // Ports for UART that go off-chip to UART level shifter
    input FPGA_SERIAL_RX,
    output FPGA_SERIAL_TX
);

    // Instantiate your memories here
    // You should tie the ena, enb inputs of your memories to 1'b1
    // They are just like power switches for your block RAMs

    wire [`XLEN-1:0] PC;
    wire [`XLEN-1:0] mem_adr;
    wire [`XLEN-1:0] bios_instr;
    wire [`XLEN-1:0] bios_data;
    wire [`XLEN-1:0] mem_wdata;
    wire [3:0] wea, iwea, dwea;
    wire [`XLEN-1:0] imem_instr;
    wire [`XLEN-1:0] instr;
    wire [`XLEN-1:0] din;
    wire [`XLEN-1:0] dmem_data;
    wire iload_sel;
    wire dload_sel;
    wire mem_or_IO;
    wire IOstore_en;



    bios_sim m_bios_sim(.adra(PC[13:2]),.adrb(mem_adr[13:2]),.clk(clk),.douta(bios_instr),.doutb(bios_data));
    imem_sim m_imem_sim(.adra(mem_adr[15:2]),.dina(mem_wdata),.iwea(iwea),.clk(clk),.doutb(imem_instr));
    dmem_sim m_dmem_sim(.adra(mem_adr[15:2]),.adrb(PC[15:2]),.dina(mem_wdata),.dwea(dwea),.clk(clk),.douta(dmem_data));
    // Construct your datapath, add as many modules as you want
    data_path m_data_path(.instr(instr),.din(din),.clk(clk),.reset(rst),.PC(PC),.mem_adr(mem_adr),.mem_wdata(mem_wdata),.wea(wea));

    mem_control m_mem_control(.wea(wea),.PC_Upper4(PC[31:28]),.data_adr_Upper4(mem_adr[31:28]),.iwea(iwea),.dwea(dwea),.iload_sel(iload_sel),.dload_sel(dload_sel),.mem_or_IO(mem_or_IO),.IOstore_en(IOstore_en));  

    assign instr=(iload_sel)?bios_instr:imem_instr;
    assign din=(dload_sel)?bios_data:dmem_data;



    // On-chip UART
    // uart #(
    //     .CLOCK_FREQ(CPU_CLOCK_FREQ)
    // ) on_chip_uart (
    //     .clk(clk),
    //     .reset(rst),
    //     .data_in(),
    //     .data_in_valid(),
    //     .data_out_ready(),
    //     .serial_in(FPGA_SERIAL_RX),

    //     .data_in_ready(),
    //     .data_out(),
    //     .data_out_valid(),
    //     .serial_out(FPGA_SERIAL_TX)
    // );
endmodule
