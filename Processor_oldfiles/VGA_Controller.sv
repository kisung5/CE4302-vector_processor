module VGA_Controller (
	input logic clk,
	input logic selected,
	input logic [7:0] current_pixel,
	output logic h_sync,
	output logic v_sync,
	output logic [7:0] rgb,
	output logic clk_25mhz,
	output logic sync_n,
	output logic blank_n,
	output logic [18:0] address
	);
	
	// VGA Control ariables
	logic enable_v_counter;
	logic [15:0] h_count_value;
	logic [15:0] v_count_value;
	
	// Images variables
//	logic [7:0] current_pixel_encrypted, current_pixel_decrypted;
	
	// Clock divider
	Clock_Divider vga_clock_gen (clk, clk_25mhz);
	
	// Counters
	Horizontal_Counter vga_horizontal (clk_25mhz, enable_v_counter, h_count_value);
	Vertical_Counter vga_vertical (clk_25mhz, enable_v_counter, v_count_value);
	
	// Based on VGA standards
	assign h_sync = (h_count_value < 96) ? 1'b1:1'b0;
	assign v_sync = (v_count_value < 2) ? 1'b1:1'b0;
	
	// Decrypted image dimensions (with rotation)
	parameter D_WIDTH = 320;
	parameter D_HEIGHT = 320;
	parameter D_SIZE = D_WIDTH*D_HEIGHT;

	// Encrypted image dimensions (with rotation)
	parameter E_WIDTH = 640;
	parameter E_HEIGHT = 320;
	parameter E_SIZE = E_WIDTH*E_HEIGHT;

//	// Decrypted image file
//	Sram #(19, 8, D_SIZE, "D:/Work Files/Arquitectura de Computadores I/ProyectoGrupalI/Processor/decrypted.mem")
//	decrypted(clk, address, 1'b0, 8'b0, current_pixel_decrypted);
//	
//	// Encrypted image file
//	Sram #(19, 8, E_SIZE, "D:/Work Files/Arquitectura de Computadores I/ProyectoGrupalI/Processor/encrypted.mem")
//	encrypted(clk, address, 1'b0, 8'b0, current_pixel_encrypted);
	
	always @*
	begin		
		// If the selected image is decrypted
		if(selected == 1'b0)
		begin
			// If the horizontal and vertical counters are in the display area and image area
			if(h_count_value >= 144 && h_count_value < 144 + D_WIDTH && v_count_value >= 35 && v_count_value < 35 + D_HEIGHT)
			begin
				address = h_count_value - 144 + (v_count_value - 35)*D_HEIGHT + 19'd204800;
//				rgb = current_pixel_decrypted;
				rgb = current_pixel;
			end
			else
			begin
				address = 19'b0;
				rgb = 8'b0;
			end
		end
		// If the selected image is encrypted
		else if (selected == 1'b1)
		begin
			// If the horizontal and vertical counters are in the display area and image area
			if(h_count_value >= 144 && h_count_value < 144 + E_WIDTH && v_count_value >= 35 && v_count_value < 35 + E_HEIGHT)
			begin
				// Rotate and invert image
				address = (h_count_value - 16'd144)*E_HEIGHT + v_count_value - 16'd35;
//				rgb = current_pixel_encrypted;
				rgb = current_pixel;
			end
			else
			begin
				address = 19'b0;
				rgb = 8'b0;
			end
		end
		// Any other case
		else
		begin
			address = 19'b0;
			rgb = 8'b0;
		end
	end

	// Based on VGA standards
	assign sync_n = 1'b0;
	assign blank_n = 1'b1;
	
endmodule
