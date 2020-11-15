module VGA_Controller_Testbench;

	logic clk = 0;
	logic h_sync;
	logic v_sync;
	logic [7:0] rgb;
	logic sync_n;
	logic blank_n;

	VGA_Controller VGA (clk, 1'b1, h_sync, v_sync, rgb, clk_25mhz, sync_n, blank_n);
	
	always #5 clk = ~clk;
	
endmodule