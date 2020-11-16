module control_hazard_unit #(parameter N = 32)
(input logic branchE,
input logic [4:0] opCode,
input logic [N-1:0] opeA, opeB,
output logic select_pc, flush, stall);

logic eq, gt;
logic [2:0] logic_array;

comparator #(.N(N)) operand_comparator (.operandA(opeA), .operandB(opeB),
.eq(eq), .neq(), .lt(gt), .lte(), .gt(), .gte());

always_comb begin
	if (branchE & ((eq & opCode == 5'b01000) | (gt & opCode == 5'b01001)))
		logic_array <= 3'b111;
	else begin
		logic_array <= 3'b000;
	end
end

assign {select_pc, flush, stall} = logic_array;

endmodule 