`timescale 1 ps / 1 ps
module rsa_asip_system_tb_output ();

logic clk, rst, selected, reg15,
h_sync, v_sync, clk_25mhz, sync_n, blank_n;
//logic [31:0] pc;
logic [7:0] rgb;
integer file;
integer i;

rsa_asip_system DUT
(.clk(clk), .rst(rst), .selected(selected), .reg15(reg15),
//);
.h_sync(h_sync), .v_sync(v_sync), .clk_25mhz(clk_25mhz), .sync_n(sync_n), .blank_n(blank_n),
.R(rgb), .G(), .B());


always #1 clk = ~clk;
//always #8400000 selected = ~selected;

//Clock and reset release
initial begin
	clk=0; rst=1; //Clock low at time zero
	selected = 0;
	@(posedge clk);
	@(posedge clk);
	rst=0;
end

initial begin
	file = $fopen("monitor_inputs.txt","w");

	@(negedge rst); //Wait for reset to be released
	@(posedge clk);   //Wait for fisrt clock out of reset

	for (i = 0; i<420050; i=i+1)
	begin
		@(posedge clk_25mhz);
		$fwrite(file, "%b %b %b\n", h_sync, v_sync, rgb);
	end
	
	@(posedge clk);
	selected = 1;
	@(posedge clk);
	@(posedge reg15);
	@(posedge clk);
	
	for (i = 0; i<840100; i=i+1)
	begin
	if(i>420050) begin
		@(posedge clk_25mhz);
		$fwrite(file, "%b %b %b\n", h_sync, v_sync, rgb);
	end
	end
	
	$fclose(file);  

	$finish;
end

//vsim -gui -l msim_transcript work.rsa_asip_system_tb -L altera_mf_ver -L altera_mf

endmodule 