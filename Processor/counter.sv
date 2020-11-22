module counter (input logic wen_v, clk, rst, 
					 output logic stall, output logic [2:0] count);

		always_ff @(posedge clk)
		begin
			if (rst) begin
				count = 0;
				stall = 0;
			end
			else if (wen_v) begin
				if (count == 4) begin
					stall = 0;
					count = 3'b0;
				end
				else begin
					count = count + 3'b01;
					stall = 1;
				end
			end else begin
				count = 3'b0;
				stall = 0;
			end
		end
endmodule
