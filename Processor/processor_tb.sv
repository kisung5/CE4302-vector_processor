module processor_tb ();

logic clk, rst, mem_e;
logic [31:0] inst, data_read, pc, address, data_write;

processor DUT 
(.clk(clk), .rst(rst),
.inst(inst), // instruction input from inst memory
.input_data(data_read), // data input from data memory
.memw_m(mem_e), // memory write enable output control
.pcf(pc), // pc address output to inst memory
.m_address(address), // memory address output to data memory
.m_data(data_write));

always #10 clk <= ~clk;

initial begin
	clk = 0;
	inst = 32'b0;
	data_read = 32'b0;
	rst = 1;
	#25 rst = 0;
	inst = 32'b10000000100000000000000110010000;
	#20 inst = 32'b10000001000000000000000100101100;
	#20 inst = 32'b10000010000000000000000100101100;
	#20 inst = 32'b10000010100000000000000100101100;
	#20 inst = 32'b10000011000000000000000100101100;
	#20 inst = 32'b00001001100010010000000000000000;
	#20 inst = 32'b00011001100010010000000000000000;
	#20 inst = 32'b00001010000010010000000000000000;
	#20 inst = 32'b00111010100010010000000000000000;
	#20 inst = 32'b0;
end

endmodule 