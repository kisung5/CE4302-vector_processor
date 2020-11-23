`timescale 1 ps / 1 ps
module rsa_asip_system_tb ();

//(input logic clk, rst, 
//selected, // Selected algorithm
//start, // Start conversion
//input logic [3:0] sector_select,
//output logic reg15,
//output logic [7:0] gpio
//);

logic clk, rst, selected, start, reg15;
logic [3:0] sector_select;
logic [7:0] gpio;

rsa_asip_system DUT
(.clk(clk), .rst(rst), .selected(selected), .start(start),
.sector_select(sector_select), .reg15(reg15), .gpio(gpio));


always #10 clk <= ~clk;

initial begin
	clk = 0;
	rst = 1;
	selected = 0;
	start = 0;
	sector_select = 4'b0;
	#20 rst = 0;
	selected = 1;
	#20 selected = 0;
	sector_select = 4'b1010;
	#20 start = 1;
	#20 start = 0;
	@(posedge reg15);
	$finish;
end

//vsim -gui -l msim_transcript work.rsa_asip_system_tb -L altera_mf_ver -L altera_mf

endmodule 