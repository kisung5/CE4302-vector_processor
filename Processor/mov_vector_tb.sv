module mov_vector_tb #(parameter V = 128, N = 32);

	logic [127:0] dst, vector_input;
	logic [31:0] src;
	
	logic [1:0] imm;
	
	mov_vector #(128, 32) op_mov (.src(src), .vector_input(vector_input), .imm(imm), .dst(dst));
	
	initial begin
		vector_input = 128'hFFFF; #10
		src = 128'hAAAA; imm = 2'b00; #10;
		src = 458; 		  imm = 2'b01; #10;
		src = 458;       imm = 2'b10; #10;
		src = 458;       imm = 2'b11; #10;
	end


endmodule