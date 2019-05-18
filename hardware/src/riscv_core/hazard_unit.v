module hazard_unit
#(
	parameter ALUM=2'b10,
	parameter RESULTW=2'b01,
	parameter WBMEM=2'b01,
	parameter ALUE=2'b11
	)
(
	input        rst,
	input  [4:0] adr1D,
	input  [4:0] adr2D,
	input        branchD,
	input        jumpD,
	input  [4:0] adr1E,
	input  [4:0] adr2E,
	input  [1:0] WB_SelE,
	input  [1:0] WB_SelM,
	input        RegWriteE,
	input  [4:0] rdE,
	input  [4:0] rdM,
	input  [4:0] rdW,
	input        RegWriteM,
	input        RegWriteW,
	output       StallF,
	output       StallD,
	output [1:0] Forward1D,
	output [1:0] Forward2D,
	output [1:0] Forward1E,
	output [1:0] Forward2E,
	output       FlushE
);
	
	reg          lw_stall;
	reg          branch_stall;
	reg          jump_stall;
	reg [1:0]    Forward1D_reg;
	reg [1:0]    Forward2D_reg;
	reg [1:0]    Forward1E_reg;
	reg [1:0]    Forward2E_reg;

	always @(*) begin
		if(rst) begin
			lw_stall=0;
			branch_stall=0;
			jump_stall=0;
		end
		else begin
			if((adr1E!=0) && (adr1E==rdM) && (RegWriteM==1)) begin
				Forward1E_reg=ALUM;
			end
			else if((adr1E!=0) && (adr1E==rdW) && (RegWriteW==1)) begin
					Forward1E_reg=RESULTW;
			end
			else begin
				Forward1E_reg=2'b00;
			end
	
			if((adr2E!=0) && (adr2E==rdM) && (RegWriteM==1)) begin
				Forward2E_reg=ALUM;
			end
			else if((adr2E!=0) && (adr2E==rdW) && (RegWriteW==1)) begin
					Forward2E_reg=RESULTW;
			end
			else begin
				Forward2E_reg=2'b00;
			end

			//branch Forward
			if((adr1D!=0) && (adr1D==rdM) && (RegWriteM==1)) begin
				Forward1D_reg=ALUM;
			end
			else if((adr1D!=0) && (adr1D==rdW) && (RegWriteW==1)) begin
				Forward1D_reg=RESULTW;
			end	
			else begin
				Forward1D_reg=2'b00;
			end
	
			if((adr2D!=0) && (adr2D==rdM) && (RegWriteM==1)) begin
				Forward2D_reg=ALUM;
			end
			else if((adr2D!=0) && (adr2D==rdW) && (RegWriteW==1))begin
				Forward2D_reg=RESULTW;			
			end	
			else begin
				Forward2D_reg=2'b00;
			end

			//lw stall
			if(((adr1D==rdE) || (adr2D==rdE)) && (rdE!=5'd0)) begin
				if((WB_SelE==WBMEM)||((jumpD==1)&&(RegWriteE==1))) begin
					lw_stall=1'b1;
				end
				else begin
					lw_stall=1'b0;
				end
			end
			else begin
				lw_stall=1'b0;
			end

			//branch Stall
			if(branchD) begin
				if(((adr1D==rdE)||(adr2D==rdE)&&(RegWriteE==1))
					||
					((adr1D==rdM)||(adr2D==rdM))&&(WB_SelM==WBMEM)) begin
					branch_stall=1'b1;
				end
				else begin
					branch_stall=1'b0;
				end
			end
			else begin
				branch_stall=1'b0;
			end

			//jump Stall
			if(branchD) begin
				if(((adr1D==rdE)||(adr2D==rdE)&&(RegWriteE==1))) begin
					jump_stall=1'b1;
				end
				else begin
					jump_stall=1'b0;
				end
			end
			else begin
				jump_stall=1'b0;
			end

		end
	end

	assign StallF=lw_stall||branch_stall||jump_stall;
	assign StallD=lw_stall||branch_stall||jump_stall;
	assign FlushE=lw_stall||branch_stall||jump_stall;
	assign Forward1D=Forward1D_reg;
	assign Forward2D=Forward2D_reg;
	assign Forward1E=Forward1E_reg;
	assign Forward2E=Forward2E_reg;
endmodule