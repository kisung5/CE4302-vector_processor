module alu_tb #(parameter N = 32);

logic [N-1:0] operandA, operandB, result;
logic [2:0] opcode;
logic C_Flag, O_Flag, N_Flag, Z_Flag;


//Comparator #(32) comparador (operandA,operandB, result);
alu #(N) alu_module (opcode, operandA, operandB, result, C_Flag, O_Flag, N_Flag, Z_Flag);


initial begin
// ALU Tests
// Flags
// Zero flag
operandA = 32; operandB = 32; opcode = 3'b001; #10;
// Negative flag		
operandA = 32; operandB = 64; opcode = 3'b001;	#10;
// Overflow flag
operandA = 32'hFFFFFFFF; operandB = 10; opcode = 3'b000; #10;
// Carry flag
operandA = 32'hFFFFFFFF; operandB = 1; opcode = 3'b000; #10;	
// Multiply flag
operandA = 32'd100; operandB = 32'd2; opcode = 3'b010; #10;	
// Integer division flag
operandA = 32'd50; operandB = 32'd3; opcode = 3'b101; #10;
end

endmodule
