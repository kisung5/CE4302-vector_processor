module demultiplexer #(parameter N = 32) 
(input logic [N-1:0] in,
input logic selector,
output logic [N-1:0] out1, out2);
									 
	always_comb
	begin
	case (selector)
		1'b0 	: begin out1 = in; out2 = 'b0; end
		1'b1	: begin out1 = 'b0; out2 = in; end
		default : begin out1 = 'b0; out2 = 'b0; end
	endcase
	end
									 
endmodule 
