module multiplexer #(parameter N = 32) (input logic [N-1:0] d1, d2, d3,
									 input logic [1:0] selector,
									 output logic [N-1:0] out);
									 
		always_comb
		begin
		case (selector)
			2'b00 	: out = d1;
			2'b01		: out = d2;
			2'b10		: out = d3;
			default 	: out = 0; 
		
		endcase
		end
									 
endmodule 
