module mwpipe_tb;

logic clk, rst, regw_in, regmem_in, stall;
logic regw_out, regmem_out;
logic [3:0] regScr_in, regScr_out;
//logic [31:0] ALUrslt_in, ALUrslt_out;
logic [127:0] ALUrslt_in, ALUrslt_out, readdata_in, readdata_out;

// address, clock, data, wren, q

mwpipe DUT (.clk(clk), .rst(rst), .stall_W(stall),
// Input
	.regw_M(regw_in), .regmem_M(regmem_in), 
	.regScr_M(regScr_in), .ALUrslt_M(ALUrslt_in),
	.readdata_M(readdata_in),
//	.regVrslt_M(regVrslt_in),
// Output
	.regw_W(regw_out), .regmem_W(regmem_out), 
	.regScr_W(regScr_out), .ALUrslt_W(ALUrslt_out),
	.readdata_W(readdata_out)
	/*.regVrslt_W(regVrslt_out)*/);

always #10 clk <= ~clk;

initial begin
	clk = 0;
	rst = 1;
	stall = 0;
	regw_in = 0; 
	regmem_in = 0;
	regScr_in = 4'b0;
	ALUrslt_in = 128'b0;
	readdata_in = 128'b0;
	#55 rst = 0;
	#20;
	regw_in = 1; 
	regmem_in = 0; 
	regScr_in = 4'b0011;
	ALUrslt_in = 128'h0000FFFF; 
	#20;
	regw_in = 1;
	regmem_in = 0; 
	regScr_in = 4'b0100;
	ALUrslt_in = 128'h0000FFFF; 
	#100;
end

endmodule 