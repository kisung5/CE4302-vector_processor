// Basic register with configurable bitsize. 
module register #(parameter N = 8)
(input wen, rst, clk,
input [N-1:0] in,
output reg [N-1:0] out);

always_ff @(posedge clk) 
	begin 
		if (rst)
			out = 0; 
		else if (wen)
			out = in;
		else
			out = out;
	end
endmodule 