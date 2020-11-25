`timescale 1 ps / 1 ps
module rsa_asip_system_tb_output ();

//module rsa_asip_system
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

int file1, file2, i;

always #1 clk = ~clk;
//always #8400000 selected = ~selected;

//Clock and reset release
initial begin
	clk=0; rst=1; //Clock low at time zero
	selected = 0;
	start = 0;
	sector_select = 4'b0;
	@(posedge clk);
	selected = 1;
	sector_select = 4'b1000;
	@(posedge clk);
	rst=0;
end

initial begin
	file1 = $fopen("image_input.img","w");
	file2 = $fopen("image_output.img","w");

	@(negedge rst); //Wait for reset to be released
	
	for (i = 0; i<160000; i=i+1)
	begin
		@(posedge clk);
		$fwrite(file1, "%b\n", gpio);
	end
	
	$fclose(file1);
	
	@(posedge clk);   //Wait for fisrt clock out of reset
	start = 1;
	@(posedge clk);
	
//	@(posedge clk);
	
//	@(posedge clk);
	@(posedge reg15);
	@(posedge clk);
	
	if (!selected) begin
		for (i = 0; i<40000; i=i+1)
		begin
			@(posedge clk);
			$fwrite(file2, "%b\n", gpio);
		end
	end
	else begin
		for (i = 0; i<88804; i=i+1)
		begin	
			@(posedge clk);
			$fwrite(file2, "%b\n", gpio);
		end
	end
	
	$fclose(file2);  

	$finish;
end

//vsim -gui -l msim_transcript work.rsa_asip_system_tb -L altera_mf_ver -L altera_mf

endmodule 