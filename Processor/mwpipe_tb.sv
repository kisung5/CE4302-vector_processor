module mwpipe_tb;

logic clk, rst, regw_in, regmem_in;
logic regw_out, regmem_out;
logic [3:0] regScr_in, regScr_out;
logic [31:0] ALUrslt_in, ALUrslt_out;
logic [127:0] regVrslt_in, regVrslt_out;

// address, clock, data, wren, q

mwpipe DUT (.clk(clk), .rst(rst),
// Input
	.regw_M(regw_in), .regmem_M(regmem_in), 
	.regScr_M(regScr_in), .ALUrslt_M(ALUrslt_in),
	.regVrslt_M(regVrslt_in),
// Output
	.regw_W(regw_out), .regmem_W(regmem_out), 
	.regScr_W(regScr_out), .ALUrslt_W(ALUrslt_out),
	.regVrslt_W(regVrslt_out));

always #10 clk <= ~clk;

initial begin
	clk = 0;
	regw_in = 0; 
	regmem_in = 0;
	regScr_in = 4'b0;
	ALUrslt_in = 32'b0;
	regVrslt_in = 128'b0;
	#55;
	#20;
	regw_in = 1; 
	regmem_in = 0; 
	regScr_in = 4'b0011;
	ALUrslt_in = 32'h0000FFFF; 
	#20;
	regw_in = 1;
	regmem_in = 0; 
	regScr_in = 4'b0100;
	ALUrslt_in = 32'h0000FFFF; 
	#100;
end

endmodule 