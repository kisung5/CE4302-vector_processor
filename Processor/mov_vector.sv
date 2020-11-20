module mov_vector #(parameter V = 128, N = 32) 
				(input logic [N-1:0] src, 
				input logic [1:0] imm,  output logic [V-1:0] dst);
					
	
	always @(imm)
	begin
		case(imm)
			0: dst[31:0] = src;
			1: dst[63:32] = src;
			2: dst[95:64] = src;
			3: dst[127:96] = src;
			default: dst = 'b0;
		endcase
	end
	
endmodule
