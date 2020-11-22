module VGA_Controller_Testbench_Output;

	logic clk = 0;
	logic selected = 0;
	logic h_sync;
	logic v_sync;
	logic [7:0] rgb;
	logic clk_25mhz;
	logic sync_n;
	logic blank_n;
	
	logic reset;
	integer file;
	integer i;
	
	VGA_Controller VGA (clk, selected, h_sync, v_sync, rgb, clk_25mhz, sync_n, blank_n);
	
	always #5 clk = ~clk;
	always #8400000 selected = ~selected;

	//Clock and reset release
	initial begin
		clk=0; reset=1; //Clock low at time zero
		@(posedge clk);
		@(posedge clk);
		reset=0;
	end
	
	initial begin
		file = $fopen("vga_testbench.txt","w");

		@(negedge reset); //Wait for reset to be released
		@(posedge clk);   //Wait for fisrt clock out of reset

		for (i = 0; i<840100; i=i+1)
		begin
			@(posedge clk_25mhz);
			$fwrite(file, "%b %b %b\n", h_sync, v_sync, rgb);
		end

		$fclose(file);  

		$finish;
	end
	
endmodule 