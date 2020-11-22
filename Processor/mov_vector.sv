module mov_vector #(parameter V = 128, N = 32) 
				(input logic [N-1:0] src, input logic [V-1:0] vector_input,
				input logic [1:0] imm,  output logic [V-1:0] dst);
				
	
	always_comb
	begin
		case(imm)
			0: dst = {vector_input[127:32], src};
			1: dst = {vector_input[127:64], src, vector_input[31:0]};
			2: dst = {vector_input[127:96], src, vector_input[63:0]};
			3: dst = {src, vector_input[95:0]};
			default: dst = 'b0;
		endcase
	end
	
endmodule
