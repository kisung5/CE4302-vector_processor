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
logic [1:0] step;
//logic [N-1:0] value0, value1, value2;
// logic [V-1:0] tempvector;

// wen_v is a write enable vectorial
counter count_enable (.wen_v(mem_wen_v), .clk(clk), .rst(rst), 
							 /*.stall(enable_vec), */.count(step));

always @(*)
	case (step)
		0: output_vector <= {96'b0, mem_data};
		1: output_vector <= {64'b0, mem_data, output_vector[31:0]};
		2: output_vector <= {32'b0, mem_data, output_vector[63:0]};
		3: output_vector <= {mem_data, output_vector[95:0]};
		default: output_vector <= {96'b0, mem_data};
	endcase

	
always_comb begin
	case (step)
		0: if (mem_wen_v) begin
			if (mem_wen) begin 
				m_address <= input_vector_A[31:0];
				to_mem_data <= input_vector_B[31:0];
				enable_vec <= 1'b1;
			end
			else begin
				m_address <= input_vector_A[31:0];
				to_mem_data <= 32'b0;
				enable_vec <= 1'b1;
			end
		end
		else begin
			m_address <= input_vector_A[31:0];
			to_mem_data <= input_vector_B[31:0];
			enable_vec <= 1'b0;
		end
		1: if (mem_wen) begin 
				m_address <= input_vector_A[63:32];
				to_mem_data <= input_vector_B[63:32];
				enable_vec <= 1'b1;
			end
			else begin
				m_address <= input_vector_A[63:32];
				to_mem_data <= 32'b0;
				enable_vec <= 1'b1;
			end
		2: if (mem_wen) begin 
				m_address <= input_vector_A[95:64];
				to_mem_data <= input_vector_B[95:64];
				enable_vec <= 1'b1;
			end
			else begin
				m_address <= input_vector_A[95:64];
				to_mem_data <= 32'b0;
				enable_vec <= 1'b1;
			end
		3: if (mem_wen) begin 
				m_address <= input_vector_A[127:96];
				to_mem_data <= input_vector_B[127:96];
				enable_vec <= 1'b0;
			end
			else begin
				m_address <= input_vector_A[127:96];
				to_mem_data <= 32'b0;
				enable_vec <= 1'b0;
			end
		default: begin
			m_address <= input_vector_A[31:0];
			to_mem_data <= input_vector_B[31:0];
			enable_vec <= 1'b0;
		end
	endcase
end


assign stall_cpu = enable_vec;
assign mem_wen_output = mem_wen;
// assign output_vector = tempvector;

endmodule
