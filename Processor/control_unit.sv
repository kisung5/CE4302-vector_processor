module control_unit 
(input logic [4:0] opcode,
output logic [3:0] ALUControl,
output logic RegW, ALUSrc, BranchE, MemW, MemtoReg, regB, vectorMem);
							
logic [6:0] control;
				
				
always_comb
case(opcode)
	5'b00001: control = 7'b0100000; // ADD
	5'b00010: control = 7'b0100000; // AND
	5'b00011: control = 7'b0100000; // SUB
	5'b00100: control = 7'b0100000; // MUL
	// 5'b00101: control = 6'b100000; // CNB
	5'b00101: control = 7'b0100000; // DIV
	5'b00111: control = 7'b0100000; // MOD
	5'b01000: control = 7'b0001001; // BEQ
	5'b01001: control = 7'b0001001; // BGT
	5'b10000: control = 7'b0110000; // ADDI
	5'b10001: control = 7'b0110000; // SRL
	5'b10010: control = 7'b0110000; // SLL
	5'b10011: control = 7'b0010101; // SB
	5'b10100: control = 7'b0110011; // LB
	// "addv": "11000",    # Changed
    // "mulv": "11001",    # Changed
    // "divv": "11010",    # Changed
	// "rep": "11011"	  #Changed
    // "movv": "11100",    # Changed
    // "svi": "11101",     # Changed
    // "lvi": "11110",     # Changed
	5'b11000: control = 7'b0100000; // ADDV
	5'b11001: control = 7'b0100000; // MULV
	5'b11010: control = 7'b0100000; // DIVV
	5'b11011: control = 7'b0100000; // REP
	5'b11100: control = 7'b0100001; // MOVV
	5'b11101: control = 7'b1010101; // SVI
	5'b11110: control = 7'b1110011; // LVI
	default: control = 7'b0000000;
endcase


assign {vectorMem, RegW, ALUSrc, BranchE, MemW, MemtoReg, regB} = control;

// ALU Decoder

always_comb
case(opcode)
	5'b00111: ALUControl = 4'b0011; // MOD
	5'b00001: ALUControl = 4'b0000; // ADD
	5'b00010: ALUControl = 4'b0100; // AND
	5'b00011: ALUControl = 4'b0001; // SUB
	5'b00100: ALUControl = 4'b0010; // MUL
	// 5'b00101: ALUControl = 3'b101; // CNB
	5'b00101: ALUControl = 4'b0101; // DIV
	5'b10000: ALUControl = 4'b0000; // ADDI
	5'b10001: ALUControl = 4'b0110; // SRL
	5'b10010: ALUControl = 4'b0111; // SLL
	5'b10011: ALUControl = 4'b0000; // SB
	5'b10100: ALUControl = 4'b0000; // LB
	// 5'b10101: ALUControl = 3'b000; // LW
	5'b01000: ALUControl = 4'b0000; //BEQ
	5'b01001: ALUControl = 4'b0000; //BGT

	5'b11000: ALUControl = 4'b0000; // ADDV
	5'b11001: ALUControl = 4'b0010; // MULV
	5'b11010: ALUControl = 4'b0101; // DIV
	5'b11011: ALUControl = 4'b1000; // REP
	5'b11100: ALUControl = 4'b1001; // MOVV
	5'b11101: ALUControl = 4'b0000; // SVI
	5'b11110: ALUControl = 4'b0000; // LVI
	default: ALUControl = 4'b0000;
endcase
			
endmodule 