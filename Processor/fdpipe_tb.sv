module fdpipe_tb;

logic clk, stall, flush;
logic [31:0] in, out;

fdpipe DUT(.stall_D(stall), .clk(clk), .flush_F(flush), .inst_F(in), .inst_D(out));

always #10 clk <= ~clk;

initial begin
	clk = 0;
	stall = 0;
	flush = 0;
	in = 32'h0;
	out = 32'h0;
	#100;
	#5 in = 32'h0F0AB220;
	#100;
	#5 stall = 1;
	#5 in = 32'h2F0F00FF;
	#100;
	#5 stall = 0;
	#200;
	#5 flush = 1;
	#100;
end

endmodule 