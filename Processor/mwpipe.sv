// Memory-Writeback pipeline register
// Inputs and outputs ALU results, registers, and control
module mwpipe #(parameter V = 128, N = 32, M = 4)
(input logic clk, rst,
input logic regw_M, regmem_M,
input [M-1:0] regScr_M, 
input [N-1:0] ALUrslt_M, readdata_M,
input [V-1:0] regVrslt_M,
output logic regw_W, regmem_W,
output [M-1:0] regScr_W, 
output [N-1:0] ALUrslt_W, readdata_W,
output [V-1:0] regVrslt_W);

// Instrucion control flags/bit
register #(.N(1)) regw (.wen(1'b1), .rst(rst), .clk(clk), 
	.in(regw_M), .out(regw_W));
	
register #(.N(1)) regmem (.wen(1'b1), .rst(rst), .clk(clk), 
	.in(regmem_M), .out(regmem_W));
	
// ALU result and register data
register #(.N(M)) regScr (.wen(1'b1), .rst(rst), .clk(clk), 
	.in(regScr_M), .out(regScr_W));	

register #(.N(N)) ALUrslt (.wen(1'b1), .rst(rst), .clk(clk), 
	.in(ALUrslt_M), .out(ALUrslt_W));
	
register #(.N(N)) readData (.wen(1'b1), .rst(rst), .clk(clk), 
	.in(readdata_M), .out(readdata_W));
	
// Vector register
register #(.N(V)) regVrslt (.wen(1'b1), .rst(rst), .clk(clk), 
	.in(regVrslt_M), .out(regVrslt_W));

endmodule 