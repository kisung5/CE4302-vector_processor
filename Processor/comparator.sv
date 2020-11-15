module comparator #(parameter N=32) (input logic [N-1:0] operandA, operandB,
											 output logic eq, neq, lt, lte, gt, gte);
											 
		assign eq = (operandA == operandB);
		assign neq = (operandA != operandB);
		assign lt = (operandA < operandB);
		assign lte = (operandA <= operandB);
		assign gt = (operandA > operandB);
		assign gte = (operandA >= operandB);
		
endmodule
