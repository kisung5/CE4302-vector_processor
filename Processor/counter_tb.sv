module counter_tb ();


	logic wen_v, clk, rst, stall;
	logic [1:0] count;
	counter counter (.wen_v(wen_v), .clk(clk), .rst(rst), .stall(stall), .count(count));
	
	always #10 clk <= ~clk;
	
initial begin
	clk = 0;
	rst = 0;
	stall = 0;
	wen_v = 0;
	#10 wen_v = 1;
	#10 wen_v = 0;
	#40 wen_v = 1;
	#10 wen_v = 0;
	
end



endmodule
