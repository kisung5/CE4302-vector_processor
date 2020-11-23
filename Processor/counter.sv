module counter (
	input logic wen_v, clk, rst,
	output logic [1:0] count
);

		always_ff @(posedge clk)
		begin
			if (rst) begin
				count = 0;
//				stall = 0;
			end
			else if (wen_v) begin
				if (count == 3) begin
//					stall = 0;
					count = 2'b0;
				end
				else begin
					count = count + 2'b01;
//					stall = 1;
				end
			end else begin
				count = 2'b0;
//				stall = 0;
			end
		end
endmodule
