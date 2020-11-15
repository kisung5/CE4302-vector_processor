module VGA_Controller_Testbench;

	logic clk = 0;
	logic h_sync;
	logic v_sync;
	logic [7:0] rgb;
	logic sync_n;
	logic blank_n;
	logic clk_25;

	VGA_Controller VGA (clk, 1'b1, h_sync, v_sync, rgb, clk_25, sync_n, blank_n);
	
	always #5 clk = ~clk;
	
endmodule 