module outputGPIO(
				input logic clk, rst,
				input logic [7:0] current_pixel,
				input logic enable,
				output logic [7:0] outputPin,
				output logic [17:0] address
);
				
	//integer counter = 400 * 400; // Address counter
	integer counter = 0; // Address counter

				
	always @ (posedge clk)
	
	begin
		if(rst)
//			counter = 400 * 400;
			counter = 0;

		else if(enable)
		begin
			address = counter;
			counter = counter + 1;
			outputPin = current_pixel;
		end
		
		else
		begin
			address = 1'b0;
			outputPin = 8'b0;
		end
	end
	
endmodule 