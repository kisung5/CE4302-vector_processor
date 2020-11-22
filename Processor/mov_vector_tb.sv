module mov_vector_tb;

	logic [127:0] dst, vector_input;
	logic [31:0] src;
	
	logic [1:0] imm;
	
	mov_vector op_mov (.src(src), .vector_input(vector_input), .imm(imm), .dst(dst));
	
	initial begin
		vector_input = 128'h000FF000010203040000AAAA; #10
		src = 458; 
		imm = 2'b00; #10;
		src = 458; 		  
		imm = 2'b01; #10;
		src = 458;       
		imm = 2'b10; #10;
		src = 458;       
		imm = 2'b11; #10;
	end


endmodule
