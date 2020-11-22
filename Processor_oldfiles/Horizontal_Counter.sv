// Counter based
module Horizontal_Counter (
	input clk_25MHz,
	output logic enable_v_counter = 0,
	output logic [15:0] h_count_value = 0
	);
	
	always @ (posedge clk_25MHz)
	begin
		if (h_count_value < 16'd799)
		begin
			h_count_value = h_count_value + 16'h0001;
			enable_v_counter = 1'b0; // Disable verticar counter
		end
		else
		begin
			h_count_value = 16'b0; // Reset counter
			enable_v_counter = 1'b1; // Trigger vertical counter
		end
	end

endmodule 