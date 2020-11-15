module VGA_Controller (
	input logic clk,
	input logic selected,
	output logic h_sync,
	output logic v_sync,
	output logic [7:0] rgb,
	output logic clk_25mhz,
	output logic sync_n,
	output logic blank_n
	);
	
	// VGA Control ariables
	logic enable_v_counter;
	logic [15:0] h_count_value;
	logic [15:0] v_count_value;
	
	// Images variables
	logic [7:0] current_pixel_encrypted;
	logic [7:0] current_pixel_decrypted;
	logic [20:0] address;
	
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
	
	// Decrypted image file
	Sram #(20, 8, D_SIZE, "D:/Drive de Eduardo/Dropbox/Documentos/TEC/SEMESTRE 11 - I 2020/Arquitectura de Computadores I (CE4301)/Proyectos/Proyectos grupales/Proyecto grupal 1/Git/ProyectoGrupalI/VGA/decrypted.mem")
	decrypted(clk, address, 0, 16'b0, current_pixel_decrypted);
	
	// Encrypted image file
	Sram #(20, 8, E_SIZE, "D:/Drive de Eduardo/Dropbox/Documentos/TEC/SEMESTRE 11 - I 2020/Arquitectura de Computadores I (CE4301)/Proyectos/Proyectos grupales/Proyecto grupal 1/Git/ProyectoGrupalI/VGA/encrypted.mem")
	encrypted(clk, address, 0, 16'b0, current_pixel_encrypted);
	
	always @*
	begin		
		// If the selected image is decrypted
		if(selected == 1'b0)
		begin
			// If the horizontal and vertical counters are in the display area and image area
			if(h_count_value >= 144 && h_count_value < 144 + D_WIDTH && v_count_value >= 35 && v_count_value < 35 + D_HEIGHT)
			begin
				address = h_count_value - 144 + (v_count_value - 35)*D_HEIGHT;
				rgb = current_pixel_decrypted;
			end
			else
			begin
				address = 0;
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
				address = (h_count_value - 144)*E_HEIGHT + v_count_value - 35;
				rgb = current_pixel_encrypted;
			end
			else
			begin
				address = 0;
				rgb = 8'b0;
			end
		end
		// Any other case
		else
		begin
			address = 0;
			rgb = 8'b0;
		end
	end

	// Based on VGA standards
	assign sync_n = 1'b0;
	assign blank_n = 1'b1;
	
endmodule
