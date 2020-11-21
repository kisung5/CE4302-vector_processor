/**
* Vector load/store module
* Uses various system cycles to load and store vectors,
* also supports escalar registers.
*/

module vector_ld_st #(parameter V = 128, N = 32)
(input logic clk, rst, mem_wen, mem_wen_v,
input logic [V-1:0] input_vector_B,
output logic stall_cpu,
output logic [N-1:0] m_address);


logic enable_vec;
logic [1:0] step;

// wen_v is a write enable vectorial
counter count_enable (.wen_v(mem_wen_v), .clk(clk), .rst(rst), 
							 .stall(enable_vec), .count(step));

always @* begin
	if (mem_wen_v || enable_vec) begin
		case (step)
			0: m_address = input_vector_B[31:0];
			1:	m_address = input_vector_B[63:32];
			2: m_address = input_vector_B[95:64];
			3: m_address = input_vector_B[127:96];
			default: m_address <= 'b0;
		endcase
	end

	else if (mem_wen)
		m_address <= input_vector_B[31:0];
end
assign stall_cpu = enable_vec;


endmodule
