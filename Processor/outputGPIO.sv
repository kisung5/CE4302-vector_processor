module outputGPIO(
	input logic clk, rst, enable, selected, io_select,
//	input logic [7:0] current_pixel,
//	output logic [7:0] outputPin,
	output logic [17:0] address
);
				
	integer input_counter = 0;
	integer output_counter = 160000; // Address counter
	// integer counter = 0; // Address counter

				
	always @ (posedge clk)
	
	begin
		if(rst) begin
			input_counter = 0;
			output_counter = 160000;
//			outputPin = 8'b0;
			address = 18'b0;
			// counter = 0;
		end
		else if(enable) begin
			if (io_select) begin
				if (!selected) begin
					if (address>18'h30D3F) begin
						address = 18'h30D40;
						// counter = counter + 1;
//						outputPin = 8'b0;
					end
					else begin
						address = output_counter[17:0];
						output_counter = output_counter + 1;
					end	
				end 
				else begin
					if (address>18'h3CBE3) begin
						address = 18'h3CBE4;
						// counter = counter + 1;
//						outputPin = 8'b0;
					end
					else begin
						address = output_counter[17:0];
						output_counter = output_counter + 1;
//						outputPin = current_pixel;
					end	
				end
			end
			else begin
				if (address>18'h270FF) begin
					address = 18'h27100;
					// counter = counter + 1;
//					outputPin = 8'b0;
				end
				else begin
					address = input_counter[17:0];
					input_counter = input_counter + 1;
//					outputPin = current_pixel;
				end	
			end
		end
		else begin
			address = 18'b0;
//			outputPin = 8'b0;
			input_counter = 0;
			output_counter = 160000;
		end
	end
	
//assign outputPin = current_pixel;	

endmodule 