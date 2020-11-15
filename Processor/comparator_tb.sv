module comparator_tb #(parameter N = 32);


	logic [N-1:0] operandA, operandB;
	logic eq, neq, lt, lte, gt, gte;
	
	comparator #(32) comparator_module (operandA, operandB, eq, neq, lt, lte, gt, gte);
	
	initial begin
		operandA = 32; operandB = 32; #10;
		operandA = 32; operandB = 64; #10;
		operandA = 64; operandB = 32; #10;
	end

endmodule 