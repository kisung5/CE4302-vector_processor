module counter (input logic wen_v, clk, rst, 
					 output logic stall, output logic [1:0] count);

		always @(clk)
		begin
			if (rst) begin
				count = 2'b00;
				stall <= 1'b0;
			end
			else if (wen_v) begin
				count = 2'b00;
				stall <= 1'b1;
			end
			else if (count == 3)
				stall <= 1'b0;
			else if (stall) begin
				count = count + 1;
				stall <= 1'b1; 
			end
		end

endmodule
