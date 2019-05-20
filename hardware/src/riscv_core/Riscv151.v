`include "defines.v"

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

    wire [`XLEN-1:0] pc_plus4F, pc_plus4M;
    wire [`XLEN-1:0] mem_adr;
    wire [`XLEN-1:0] bios_instr;
    wire [`XLEN-1:0] bios_data;
    wire [`XLEN-1:0] mem_wdata;
    wire [3:0] wea, iwea, dwea;
    wire iowea;
    wire [`XLEN-1:0] imem_instr;
    wire [`XLEN-1:0] dmem_data;
    wire [`XLEN-1:0] io_data;
    wire instr_stop;
    wire stallF;
    wire [1:0] iload_sel;
    wire [1:0] dload_sel;
    wire dmem_ena;

    reg [`XLEN-1:0] din;


    always @(*) begin
        case(dload_sel)
            2'b00: begin
                din=dmem_data;
            end
            2'b01: begin
                din=bios_data;
            end
            2'b10:begin
                din=io_data;
            end
            default: begin
                din=32'd0;
            end
        endcase
    end


    //mem architecture sim
    // bios_sim m_bios_sim(.adra(pc_plus4F[13:2]),.adrb(mem_adr[13:2]), .en(!stallF),.clk(clk),.reset(rst),.douta(bios_instr),.doutb(bios_data));
    // imem_sim m_imem_sim(.adra(mem_adr[15:2]),.adrb(pc_plus4F[15:2]), .en(!stallF),.dina(mem_wdata),.wea(iwea),.clk(clk), .reset(rst),.doutb(imem_instr));
    // dmem_sim m_dmem_sim(.adra(mem_adr[15:2]),.dina(mem_wdata),.wea(dwea),.clk(clk),.reset(rst),.douta(dmem_data));

    bios_mem     m_bios_sim(.clka(clk), .ena(!stallF), .addra(pc_plus4F[13:2]), .douta(bios_instr),.clkb(clk), .enb(dmem_ena), .addrb(mem_adr[13:2]),.doutb(bios_data));
    imem_blk_ram m_imem_sim(.clka(clk), .ena(!stallF), .wea(iwea), .addra(mem_adr[15:2]), .dina(mem_wdata), .clkb(clk), .addrb(pc_plus4F[15:2]),.doutb(imem_instr));
    dmem_blk_ram m_dmem_sim(.clka(clk), .ena(dmem_ena), .wea(dwea), .addra(mem_adr[15:2]), .dina(mem_wdata), .douta(dmem_data));

    // Construct your datapath, add as many modules as you want
    riscv_core m_riscv_core(.imem_instr(imem_instr),.bios_instr(bios_instr), .iload_sel(iload_sel), .din(din),.clk(clk),.rst(rst),.pc_plus4F(pc_plus4F), .pc_plus4M(pc_plus4M),.mem_adrM(mem_adr),.mem_wdataM(mem_wdata),.wea(wea), .instr_stop(instr_stop),.stallF(stallF));
    io_control m_io_control(.clk(clk), .iowea(iowea),.wea(wea), .cpu_rst(rst), .adr(mem_adr[6:2]), .instr_stop(instr_stop), .din_io(mem_wdata), .uart_serial_in(FPGA_SERIAL_RX), .dout_io(io_data), .uart_serial_out(FPGA_SERIAL_TX));
    mem_control m_mem_control(.clk(clk),.wea(wea),.pc_plus4_upper4F(pc_plus4F[31:28]), .pc_plus4_upper4M(pc_plus4M[31:28]),.data_adr_Upper4M(mem_adr[31:28]),.iwea(iwea),.dwea(dwea),.iload_sel(iload_sel),.dload_sel(dload_sel), .iowea(iowea));  

    assign dmem_ena=!(mem_adr[31:28]==4'b1000);

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
