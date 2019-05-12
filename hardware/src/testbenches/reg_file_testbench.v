/*
Your register file should have two asynchronous-read ports and one synchronous-write port (positive edge).
To test your register file, you should verify the following:
1. Register 0 is not writable, i.e. reading from register 0 always returns 0
2. Other registers are updated on the same cycle that a write occurs (i.e. the value read on the
cycle following the positive edge of the write should be the new value).
3. The write enable signal to the register file controls whether a write occurs (we is active high,
meaning you only write when we is high)
4. Reads should be asynchronous (the value at the output one simulation timestep (#1) after
feeding in an input address should be the value stored in that register)
*/

`timescale 1ns/100ps

`define CLK_PERIOD                 10
`define XLEN                       32
`define REG_FILE_ADDR_WIDTH        5

module reg_file_testbench();
    // Generate 100 Mhz clock
    reg clk = 0;
    always #(`CLK_PERIOD/2) clk = ~clk;

    reg [`REG_FILE_ADDR_WIDTH-1:0] rs1, rs2, rd;
    reg [`XLEN-1:0] wd;
    reg we;
    wire [`XLEN-1:0] data1, data2;

    reg_file DUT (
        .clk(clk),
        .we(we),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .wd(wd),
        .data1(data1),
        .data2(data2)
    );

    initial begin
    	clk=0;
    	reg_file_clear;
    	// reg0_write_check;
    	repeat(4) @(posedge clk);
    	reg_read_write_check;
        $display("Test Done! If any failures were printed, fix them! Otherwise this testbench passed.");
        $finish();
    end

    task reg_file_clear;
    	begin
        	// Set initial state, wait for 1 clock cycle
        	we = 1'b0;
        	rs1=5'd0;
        	rs2=5'd0;
        	rd=5'd0;
        	wd=32'hff;
        	
        	@(posedge clk);
        	fork
        		begin
        			//pulse we for 32 cycles
        			we=1'b1;
        			wd=32'hff;
        			repeat(32) @(posedge clk);
        		end
        		begin
        			repeat(32) begin
        				rd=rd+1;
        				@(posedge clk);
        			end
        		end
        	join
        	//reset we
        	we=1'b0;

    	end
    endtask

    task reg0_write_check;
    	begin
    		we=1'b1;
    		rs1=5'd0;
    		rd=5'd0;
    		wd=32'd1;
    		repeat(2) @(posedge clk);
    		if(data1!=0) $display("reg0 write check fail");
    	end
    endtask

    task reg_read_write_check;
    	begin
        	wd=32'd1;
 			rs1=5'd0;
 			rs2=5'd1;
        	rd=5'd1;
 			we=1'b1;
        	//write n to reg_array
        	repeat(32) begin
        		if(data1!=rs1) $display("read rs1 reg %d fail!",rs1);
        		if(data2!=32'hff) $display("read rs2 reg %d fail!",rs2);
        		rs1=rs1+1;
        		rs2=rs2+1;
        		rd=rd+1;
        		wd=wd+1;
        		@(posedge clk);
        	end
        	//reset we
        	we=1'b0;
    	end
    endtask

endmodule
