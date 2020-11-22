/**
* Vector load/store module
* Uses various system cycles to load and store vectors,
* also supports escalar registers.
*/

module vector_ld_st #(parameter V = 128, N = 32)
(input logic clk, rst, mem_wen, mem_wen_v,
input logic [N-1:0] mem_data,
input logic [V-1:0] input_vector_A, input_vector_B,
output logic stall_cpu, mem_wen_output,
output logic [N-1:0] m_address, to_mem_data,
output logic [V-1:0] output_vector);


logic enable_vec;
logic [2:0] step;

// wen_v is a write enable vectorial
counter count_enable (.wen_v(mem_wen_v), .clk(clk), .rst(rst), 
							 .stall(enable_vec), .count(step));

always_ff @(negedge clk)
	case (step)
		1: if (mem_wen) begin 
				output_vector <= 128'b0;
			end
			else begin
				output_vector <= {96'b0, mem_data};
			end
		2: if (mem_wen) begin 
				output_vector <= 128'b0;
			end
			else begin
				output_vector <= {64'b0, mem_data, output_vector[31:0]};
			end
		3: if (mem_wen) begin 
				output_vector <= 128'b0;
			end
			else begin
				output_vector <= {32'b0, mem_data, output_vector[63:0]};
			end
		4: if (mem_wen) begin 
				output_vector <= 128'b0;
			end
			else begin
				output_vector <= {mem_data, output_vector[95:0]};
			end
		default: begin
			output_vector <= {96'b0, mem_data};
		end
	endcase


always_comb begin
	case (step)
		1: if (mem_wen) begin 
				m_address <= input_vector_A[31:0];
				to_mem_data <= input_vector_B[31:0];
			end
			else begin
				m_address <= input_vector_A[31:0];
				to_mem_data <= 32'b0;
			end
		2: if (mem_wen) begin 
				m_address <= input_vector_A[63:32];
				to_mem_data <= input_vector_B[63:32];
			end
			else begin
				m_address <= input_vector_A[63:32];
				to_mem_data <= 32'b0;
			end
		3: if (mem_wen) begin 
				m_address <= input_vector_A[95:64];
				to_mem_data <= input_vector_B[95:64];
			end
			else begin
				m_address <= input_vector_A[95:64];
				to_mem_data <= 32'b0;
			end
		4: if (mem_wen) begin 
				m_address <= input_vector_A[127:96];
				to_mem_data <= input_vector_B[127:96];
			end
			else begin
				m_address <= input_vector_A[127:96];
				to_mem_data <= 32'b0;
			end
		default: begin
			m_address <= input_vector_A[31:0];
			to_mem_data <= input_vector_B[31:0];
		end
	endcase
end

assign stall_cpu = enable_vec;
assign mem_wen_output = mem_wen;


endmodule
