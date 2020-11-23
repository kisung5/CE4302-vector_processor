// ALU for arithmetic and logic operations

module operations_alu #(parameter N=32)
(input [2:0] opcode,
input logic [N-1:0] operandA, operandB,
output logic [N-1:0] result,
output logic carryout);
								 

logic carry_out;

								  
always_comb
begin
	case (opcode)
		// Arithmetic operations
		3'b000 : 
			begin // Operation add
				{carryout, result} <= operandA + operandB;
//				result <= adder_result; 
//				carryout <= carry_out;
			end
		3'b001 : 
			begin // Operation sub
				result <= operandA - operandB;
//				result <= subtract_result;
				carryout <= 1'b0;
			end
		3'b010 : 
			begin // Operation mul
				result <= operandA * operandB;
//				result <= multiply_result;
				carryout <= 1'b0;
			end
		3'b011 : 
			begin // Operation mod
				if (operandB == 32'b0) begin
					result <= 32'b0;
					carryout <= 1'b0;
				end else begin
					result <= operandA % operandB;
					carryout <= 1'b0;
				end
			end

		// Logic operations
		3'b100 : 
			begin // Operation and
				result <= operandA & operandB;
				carryout <= 1'b0;
			end
		3'b101 : 
			begin // Operation integer division
				result <= operandA / operandB;
				carryout <= 1'b0;
			end
		
		3'b110 : 
			begin // Operation srl
				result <= operandA >> operandB;
				carryout <= 1'b0;
			end

		3'b111 : 
			begin // Operation sll
				result <= operandA << operandB;
				carryout <= 1'b0;
			end
		
		// Comparations for branches, included in the ALU bur couldn't put a result.
		
		default :
			begin
				result <= 32'b0; 
				carryout <= 1'b0;
			end
	endcase
end
endmodule 