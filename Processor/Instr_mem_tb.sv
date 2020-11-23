module Instr_mem_tb();

logic [31:0] a;
logic [31:0] rd;

Instr_mem DUT(a, rd);

initial begin
	a = 32'b0;
	#10 a = 32'h4;
	#10 a = 32'h8;
	#10 a = 32'hC;
	#10 a = 32'h2DC;
end

endmodule 