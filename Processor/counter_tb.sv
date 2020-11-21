module counter_tb ();


	logic wen_v, clk, stall;
	counter counter (.wen_v(wen_v), .clk(clk), .stall(stall));
	
	always #10 clk <= ~clk;
	
initial begin
	clk = 0;
	stall = 0;
	wen_v = 0;
	#10 wen_v = 1;
	#10 wen_v = 0;
	#40 wen_v = 1;
	#10 wen_v = 0;
	
end



endmodule
