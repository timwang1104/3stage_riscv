module hazard_unit
#(
	parameter ALUM=2'b10,
	parameter RESULTW=2'b01,
	parameter WBMEM=2'b01
	)
(
	input  [4:0] adr1D,
	input  [4:0] adr2D,
	input        branchD,
	input        jumpD,
	input  [4:0] adr1E,
	input  [4:0] adr2E,
	input  [1:0] WB_SelE,
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
	
	reg       StallF_reg;
	reg       StallD_reg;
	reg [1:0] Forward1D_reg;
	reg [1:0] Forward2D_reg;
	reg [1:0] Forward1E_reg;
	reg [1:0] Forward2E_reg;
	reg       FlushE_reg;

	always @(*) begin
	//Forwarding
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

	//Stall
		if(((adr1D==rdE) || (adr2D==rdE)) && (rdE!=5'd0)) begin
			if((WB_SelE==WBMEM)||((branchD==1)&&(RegWriteE==1))||((jumpD==1)&&(RegWriteE==1))) begin
				StallF_reg=1'b1;
				StallD_reg=1'b1;
				FlushE_reg=1'b1;
			end
			else begin
				StallF_reg=1'b0;
				StallD_reg=1'b0;
				FlushE_reg=1'b0;
			end
		end
		else if ((jumpD==1)&&(RegWriteE==1)) begin
			StallF_reg=1'b1;
			StallD_reg=1'b1;
			FlushE_reg=1'b1;			
		end
		else begin
			StallF_reg=1'b0;
			StallD_reg=1'b0;
			FlushE_reg=1'b0;
		end

	//Control Hazard
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
	end

	assign StallF=StallF_reg;
	assign StallD=StallD_reg;
	assign Forward1D=Forward1D_reg;
	assign Forward2D=Forward2D_reg;
	assign Forward1E=Forward1E_reg;
	assign Forward2E=Forward2E_reg;
	assign FlushE=FlushE_reg;
endmodule