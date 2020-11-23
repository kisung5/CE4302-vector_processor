module Instr_mem(input logic [31:0] a,
					output logic [31:0] rd);

logic [31:0] ROM [183:0];
logic [31:0] data;

assign rd = data;

initial
	$readmemb("rsa.b",ROM);

always @(a)
begin : MEM_READ
	data <= ROM[a[31:2]];
end

endmodule 