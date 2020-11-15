module alu_tb #(parameter N = 32);

logic [N-1:0] operandA, operandB, result;
logic [3:0] opcode;
logic C_Flag, O_Flag, N_Flag, Z_Flag;


//Comparator #(32) comparador (operandA,operandB, result);
alu #(N) alu_module (opcode, operandA, operandB, result, C_Flag, O_Flag, N_Flag, Z_Flag);


initial begin
// ALU Tests
// Flags
// Zero flag
operandA = 32; operandB = 32; opcode = 4'b0001; #10;
// Negative flag		
operandA = 32; operandB = 64; opcode = 4'b0001;	#10;
// Overflow flag
operandA = 32'hFFFFFFFF; operandB = 10; opcode = 4'b0000; #10;
// Carry flag
operandA = 32'hFFFFFFFF; operandB = 1; opcode = 4'b0000; #10;	
end

endmodule
