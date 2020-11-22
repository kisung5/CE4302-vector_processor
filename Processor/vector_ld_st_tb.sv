module vector_ld_st_tb ();

logic clk, rst, mem_wen, mem_wen_v, stall_cpu, mem_wen_output;
logic [127:0] input_vector_A, input_vector_B, output_vector;
logic [31:0] m_address, m_data, to_m_data;


vector_ld_st DUT (
	.clk(clk), .rst(rst), .mem_wen(mem_wen), .mem_wen_v(mem_wen_v),
	.mem_data(m_data), .mem_wen_output(mem_wen_output),
	.input_vector_A(input_vector_A), .input_vector_B(input_vector_B),
	.output_vector(output_vector),
	.stall_cpu(stall_cpu), .m_address(m_address), .to_mem_data(to_m_data)
);

//always #10 clk <= ~clk;
								
initial begin
	rst = 1; clk = 0; mem_wen = 0; mem_wen_v = 0;
	input_vector_A = 128'b0; input_vector_B = 128'b0;
	m_data = 32'b0;
	#10;
	#20 rst = 0;
	input_vector_A = 128'h12121444511AAAFFFFFFF;
	input_vector_B = 128'h12121444511AAAFFFFFFF;
	#10 m_data = 32'h00AA;
	#10 mem_wen = 1;
	input_vector_A = 128'h12121444511AAAFFFFFFF;
	input_vector_B = 128'h12121444511AAAFFFFFFF;
	#10 m_data = 32'h00FF;
	#10 mem_wen = 0;
	input_vector_A = 128'h12121444511AAAFFFFFFF;
	input_vector_B = 128'h12121444511AAAFFFFFFF;
	#10 m_data = 32'h00FF;
	#10 mem_wen_v = 1;
	input_vector_A = 128'h12121444511AAAFFFFFFF;
	input_vector_B = 128'h12121444511AAAFFFFFFF;
	#10 m_data = 32'h00FF;
	@(negedge stall_cpu); 
	mem_wen_v = 0;
	input_vector_A = 128'h12121444511AAAFFFFFFF;
	input_vector_B = 128'h12121444511AAAFFFFFFF;
	#10 m_data = 32'h00FF;
end

always #10 clk <= ~clk;

endmodule

