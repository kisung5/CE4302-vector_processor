module control_unit 
(input logic [4:0] opcode,
output logic [2:0] ALUControl,
output logic RegW, ALUSrc, BranchE, MemW, MemtoReg, regB);
							
logic [5:0] control;
				
				
always_comb
case(opcode)
	5'b00001: control = 6'b100000; // ADD
	5'b00010: control = 6'b100000; // AND
	5'b00011: control = 6'b100000; // SUB
	5'b00100: control = 6'b100000; // MUL
	5'b00101: control = 6'b100000; // CNB
	5'b00111: control = 6'b100000; // MOD
	5'b01000: control = 6'b001001; // BEQ
	5'b01001: control = 6'b001001; // BGT
	5'b10000: control = 6'b110000; // ADDI
	5'b10001: control = 6'b110000; // SRL
	5'b10010: control = 6'b110000; // SLL
	5'b10011: control = 6'b010101; // SB
	5'b10100: control = 6'b110011; // LB
	5'b10101: control = 6'b110011; // LW
	default: control = 6'b000000;
endcase


assign {RegW, ALUSrc, BranchE, MemW, MemtoReg, regB} = control;

// ALU Decoder

always_comb
case(opcode)
	5'b00111: ALUControl = 3'b011; // MOD
	5'b00001: ALUControl = 3'b000; // ADD
	5'b00010: ALUControl = 3'b100; // AND
	5'b00011: ALUControl = 3'b001; // SUB
	5'b00100: ALUControl = 3'b010; // MUL
	5'b00101: ALUControl = 3'b101; // CNB
	5'b10000: ALUControl = 3'b000; // ADDI
	5'b10001: ALUControl = 3'b110; // SRL
	5'b10010: ALUControl = 3'b111; // SLL
	5'b10011: ALUControl = 3'b000; // SB
	5'b10100: ALUControl = 3'b000; // LB
	5'b10101: ALUControl = 3'b000; // LW
	5'b01000: ALUControl = 3'b000; //BEQ
	5'b01001: ALUControl = 3'b000; //BGT
	default: ALUControl = 3'b000;
endcase
			
endmodule 