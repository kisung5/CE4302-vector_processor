module Instr_mem_tb();

logic [31:0] a;
logic [31:0] rd;

Instr_mem DUT(a, rd);

initial begin
	#5 a = 32'b0;
	#10 a = 32'h4;
	#10 a = 32'h8;
	#10 a = 32'hC;
end

endmodule 