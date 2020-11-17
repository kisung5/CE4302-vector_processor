// Decode-Execution pipeline register
// Important control set:
// flush_E, flush the decoded instrucion
// Inputs and outputs decoded and control results from instruction
module depipe #(parameter V = 128, N = 32, M = 4)
(input logic flush_E, clk, stall_E,
input logic regw_D, memw_D, regmem_D, ALUope_D, branch_D, vect_D,
input [4:0] op_code_D,
input [M-1:0] regScr_D, regAD, regBD, ALUctrl_D,
input [N-1:0] inm_D,
input [V-1:0] regA_D, regB_D, /*regVA_D, regVB_D,*/
output logic regw_E, memw_E, regmem_E, ALUope_E, branch_E, vect_E,
output [4:0] op_code_E,
output [M-1:0] regScr_E, regAE, regBE, ALUctrl_E, 
output [N-1:0] inm_E,
output [V-1:0] regA_E, regB_E /*regVA_E, regVB_E*/);

// Instrucion control flags/bit
register #(.N(1)) regw (.wen(1'b1 && ~stall_E), .rst(flush_E), .clk(clk), 
	.in(regw_D), .out(regw_E));
	
register #(.N(1)) memw (.wen(1'b1 && ~stall_E), .rst(flush_E), .clk(clk), 
	.in(memw_D), .out(memw_E));
	
register #(.N(1)) regmem (.wen(1'b1 && ~stall_E), .rst(flush_E), .clk(clk), 
	.in(regmem_D), .out(regmem_E));
	
register #(.N(1)) ALUope (.wen(1'b1 && ~stall_E), .rst(flush_E), .clk(clk), 
	.in(ALUope_D), .out(ALUope_E));

register #(.N(1)) branch (.wen(1'b1 && ~stall_E), .rst(flush_E), .clk(clk), 
	.in(branch_D), .out(branch_E));

register #(.N(1)) vect (.wen(1'b1 && ~stall_E), .rst(flush_E), .clk(clk), 
	.in(vect_D), .out(vect_E));
	
register #(.N(5)) opCode (.wen(1'b1 && ~stall_E), .rst(flush_E), .clk(clk), 
	.in(op_code_D), .out(op_code_E));

	
// ALU control and register data
register #(.N(M)) ALUctrl (.wen(1'b1 && ~stall_E), .rst(flush_E), .clk(clk), 
	.in(ALUctrl_D), .out(ALUctrl_E));

register #(.N(M)) regScr (.wen(1'b1 && ~stall_E), .rst(flush_E), .clk(clk), 
	.in(regScr_D), .out(regScr_E));
	
register #(.N(M)) regA_o (.wen(1'b1 && ~stall_E), .rst(flush_E), .clk(clk), 
	.in(regAD), .out(regAE));
	
register #(.N(M)) regB_o (.wen(1'b1 && ~stall_E), .rst(flush_E), .clk(clk), 
	.in(regBD), .out(regBE));

register #(.N(N)) inm (.wen(1'b1 && ~stall_E), .rst(flush_E), .clk(clk), 
	.in(inm_D), .out(inm_E));
	
// This became vectorial
register #(.N(V)) regA (.wen(1'b1 && ~stall_E), .rst(flush_E), .clk(clk), 
	.in(regA_D), .out(regA_E));

register #(.N(V)) regB (.wen(1'b1 && ~stall_E), .rst(flush_E), .clk(clk), 
	.in(regB_D), .out(regB_E));

// Vectorial registers
//register #(.N(V)) regVA (.wen(1'b1), .rst(flush_E), .clk(clk), 
//	.in(regVA_D), .out(regVA_E));
//	
//register #(.N(V)) regVB (.wen(1'b1), .rst(flush_E), .clk(clk), 
//	.in(regVB_D), .out(regVB_E));

endmodule 