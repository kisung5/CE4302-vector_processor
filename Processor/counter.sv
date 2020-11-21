module counter (input logic wen_v, clk, rst, 
					 output logic stall, output logic [1:0] count);

		always_ff @(posedge clk)
		begin
			if (rst) begin
				count = 0;
				stall = 0;
			end
			else if (wen_v) begin
				count = 0;
				stall = 1;
			end
			else if (count == 3)
				stall = 0;
			else if (stall) begin
				count = count + 1;
				stall = 1;
			end
		end

endmodule
