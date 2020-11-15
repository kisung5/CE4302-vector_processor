module adder #(parameter N = 32) (input logic [N-1:0] operandA, operandB,
									 output logic [N-1:0] result,
									 output logic cout);
									 
		assign {cout,result} = operandA + operandB;
		
									 
endmodule
