// Permite adelantar los datos hasta la etapa de execute, idependientemente del operando, ya que se hizo
// general.
// Inputs: Reg_E -> ID del registro operando en execute
// Rd_M -> ID del registro destino en mem
// Rd_WB -> ID del registro destino en wb
// Output: S_Hazard: Selección del operando para los multiplexores.
module Data_Hazard_Forward #(parameter N = 4)
(input logic memtoreg_M, regw_m, regw_w,
input logic [N-1:0] RegA_E, RegB_E, Rd_M, Rd_WB,
output logic [1:0] S_Hazard_A, S_Hazard_B);

	logic [1:0] resultA, resultB;

	always_comb begin
	case ({regw_m, regw_w, Rd_M == RegA_E, Rd_WB == RegA_E, memtoreg_M})
		5'b10010: resultA <= 2'b00;
		5'b10011: resultA <= 2'b00;
		5'b10100: resultA <= 2'b01;
		5'b10101: resultA <= 2'b10;
		5'b10110: resultA <= 2'b01;
		5'b10111: resultA <= 2'b10;
		5'b01010: resultA <= 2'b11;
		5'b01011: resultA <= 2'b11;
		5'b01100: resultA <= 2'b00;
		5'b01101: resultA <= 2'b00;
		5'b01110: resultA <= 2'b11;
		5'b01111: resultA <= 2'b11;
		5'b11010: resultA <= 2'b11;
		5'b11011: resultA <= 2'b11;
		5'b11100: resultA <= 2'b01;
		5'b11101: resultA <= 2'b10;
		5'b11110: resultA <= 2'b11;
		5'b11111: resultA <= 2'b11;
		default: resultA <= 2'b00;
	endcase
	end
	
	always_comb begin
	case ({regw_m, regw_w, Rd_M == RegB_E, Rd_WB == RegB_E, memtoreg_M})
		5'b10010: resultB <= 2'b00;
		5'b10011: resultB <= 2'b00;
		5'b10100: resultB <= 2'b01;
		5'b10101: resultB <= 2'b10;
		5'b10110: resultB <= 2'b01;
		5'b10111: resultB <= 2'b10;
		5'b01010: resultB <= 2'b11;
		5'b01011: resultB <= 2'b11;
		5'b01100: resultB <= 2'b00;
		5'b01101: resultB <= 2'b00;
		5'b01110: resultB <= 2'b11;
		5'b01111: resultB <= 2'b11;
		5'b11010: resultB <= 2'b11;
		5'b11011: resultB <= 2'b11;
		5'b11100: resultB <= 2'b01;
		5'b11101: resultB <= 2'b10;
		5'b11110: resultB <= 2'b11;
		5'b11111: resultB <= 2'b11;
		default: resultB <= 2'b00;
	endcase
	end
		
	assign S_Hazard_A = resultA;
	assign S_Hazard_B = resultB;
endmodule
	