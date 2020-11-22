module outputGPIO(
	input logic clk, rst, enable, selected,
	input logic [7:0] current_pixel,
	output logic [7:0] outputPin,
	output logic [17:0] address
);
				
	integer counter = 400 * 400; // Address counter
	// integer counter = 0; // Address counter

				
	always @ (posedge clk)
	
	begin
		if(rst) begin
			counter = 400 * 400;
			outputPin = 8'b0;
			address = 18'b0;
			// counter = 0;
		end
		else if(enable) begin
			if (!selected) begin
				if (address>18'h30D3F) begin
					address = 18'h30D40;
					// counter = counter + 1;
					outputPin = 8'b0;
				end
				else begin
					address = counter[17:0];
					counter = counter + 1;
					outputPin = current_pixel;
				end	
			end 
			else begin
				if (address>18'h3CBE3) begin
					address = 18'h3CBE4;
					// counter = counter + 1;
					outputPin = 8'b0;
				end
				else begin
					address = counter[17:0];
					counter = counter + 1;
					outputPin = current_pixel;
				end	
			end
		end
		else begin
			address = 18'b0;
			outputPin = 8'b0;
		end
	end
	
endmodule 