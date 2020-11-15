module alu #(parameter N = 32)
(input logic [2:0] opcode,
input logic [N-1:0] operandA, operandB,
output logic [N-1:0] result,
output logic C_Flag, O_Flag, N_Flag, Z_Flag);
		
logic [N-1:0] alu_result;
logic overflow_flag_result, carryout_result;

operations_alu #(N) op_alu (opcode, operandA, operandB, alu_result, carryout_result);
overflow overflow_module (operandA[N-1],operandB[N-1], alu_result[N-1],opcode,overflow_flag_result);

// Flags

assign C_Flag = carryout_result;
assign O_Flag = overflow_flag_result;
assign N_Flag = alu_result[N-1];
assign Z_Flag = alu_result == 0;
assign result = alu_result;
										  
endmodule
