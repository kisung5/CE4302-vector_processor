/**
* Vector load/store module
* Uses various system cycles to load and store vectors,
* also supports escalar registers.
*/

module vector_ld_st #(parameter V = 128, N = 32)
(input logic clk, rst, mem_wen, memtoreg, regw_m,
input [N-1:0] address, output_data, input_data,
input [V-1:0] input_vector,
output logic stall_cpu,
output [N-1:0] m_address, m_output_data,
output [V-1:0] output_vector);



endmodule
