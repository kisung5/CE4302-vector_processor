module overflow (input logic A31, B31, R31,
					  input logic [2:0] opcode,
					  output logic overflow_flag);
							 							 
assign overflow_flag = ( ((A31 ^ R31)||(B31 ^ R31)) && ~opcode[2] && ~opcode[0]);
									 
endmodule
