// Execution-Memory pipeline register
// Inputs and outputs ALU results, registers, address, and control
module empipe #(parameter V = 128, N = 32, M = 4)
(input logic clk, rst,
input logic regw_E, memw_E, regmem_E,
input [M-1:0] regScr_E,
input [N-1:0] ALUrslt_E, address_E,
input [V-1:0] regrsltV_E, v_address_E,
output logic regw_M, memw_M, regmem_M,
output [M-1:0] regScr_M,
output [N-1:0] ALUrslt_M, address_M,
output [V-1:0] regrsltV_M, v_address_M);

// Instrucion control flags/bit	
register #(.N(1)) regw (.wen(1'b1), .rst(rst), .clk(clk), 
	.in(regw_E), .out(regw_M));
	
register #(.N(1)) memw (.wen(1'b1), .rst(rst), .clk(clk), 
	.in(memw_E), .out(memw_M));
	
register #(.N(1)) regmem (.wen(1'b1), .rst(rst), .clk(clk), 
	.in(regmem_E), .out(regmem_M));
	
// ALU result, register and address data
register #(.N(M)) regScr (.wen(1'b1), .rst(rst), .clk(clk), 
	.in(regScr_E), .out(regScr_M));	

register #(.N(N)) ALUrslt (.wen(1'b1), .rst(rst), .clk(clk), 
	.in(ALUrslt_E), .out(ALUrslt_M));

register #(.N(N)) address (.wen(1'b1), .rst(rst), .clk(clk), 
	.in(address_E), .out(address_M));
	
// Vectorial register
register #(.N(V)) regrsltV (.wen(1'b1), .rst(rst), .clk(clk), 
	.in(regrsltV_E), .out(regrsltV_M));

register #(.N(V)) v_address (.wen(1'b1), .rst(rst), .clk(clk), 
	.in(v_address_E), .out(v_address_M));
	
endmodule 