// Counter based
module Vertical_Counter (
	input clk_25MHz,
	input enable_v_counter,
	output logic [15:0] v_count_value = 0
	);
	
	always @ (posedge clk_25MHz)
	begin
		if (enable_v_counter == 1'b1)
		begin
			if (v_count_value < 524)
				v_count_value = v_count_value + 1;
			else
				v_count_value = 0; // Reset counter
		end
	end

endmodule