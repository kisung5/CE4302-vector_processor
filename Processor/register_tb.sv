module register_tb;

logic clk, wen, rst;
logic [7:0] in, out;

register DUT(.wen(wen), .clk(clk), .rst(rst), .in(in), .out(out));

always #10 clk <= ~clk;

initial begin
	clk = 0;
	rst = 0;
	wen = 0;
	in = 8'b00000000;
	#15 rst = 1;
	#20 rst = 0;
	#20 wen = 1;
	in = 8'b01011100;
	#20 wen = 0;
	in = 8'b00001010;
	#20 wen = 1;
	in = 8'b00001010;
	#20 rst = 1;
end

endmodule
