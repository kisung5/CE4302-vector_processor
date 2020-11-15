// Fetch-Decode pipeline register
// Important control set:
// 	stall_D, stall the pipeline register
// 	flush_F, flush the fecthed instruction
// Input a instruction and ouput the same instruction
module fdpipe #(parameter N = 32)
(input logic stall_D, flush_F, clk,
input [N-1:0] inst_F,
output [N-1:0] inst_D);

// Instruction fetched
register #(.N(N)) reg1 (.wen(~stall_D), .rst(flush_F), .clk(clk), 
	.in(inst_F), .out(inst_D));
	
endmodule 