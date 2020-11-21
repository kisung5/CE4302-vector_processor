module vector_ld_st_tb ();

logic clk, rst, mem_wen, mem_wen_v;
logic [127:0] input_vector_B;
logic stall_cpu;
logic [31:0] m_address;


vector_ld_st #(128,32) DUT (.clk(clk), .rst(rst), .mem_wen(mem_wen), 
								.mem_wen_v(mem_wen_v), .input_vector_B(input_vector_B), 
								.stall_cpu(stall_cpu), .m_address(m_address));

								
initial begin
	rst = 0; clk = 0;
	#10 input_vector_B = 128'h12121444511AAAFFFFFFF;
	#10 mem_wen = 1;
	#10 mem_wen = 0;
	#10 mem_wen_v = 1;
	#10 mem_wen_v = 0;	
end

always #10 clk <= ~clk;

endmodule

