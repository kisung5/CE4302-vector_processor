// Top module of the RSA ASIP system.
// clk_50mhz of the DE1 SOC FPGA, clock generator for SOC is 50MHz

module rsa_asip_system
(input logic clk, rst,
selected,
output logic h_sync, v_sync, clk_25mhz, sync_n, blank_n, 
output logic reg15,
output logic [7:0] R, G, B
);

logic m_write_e, m_wren_cpu,
rst_sys, vga_select, mux_select;
logic [7:0] m_rdata, m_rdata_cpu, m_rdata_vga, rgb;
logic [31:0] inst, pc_f, reg_15,
m_write_data, m_address_cpu; 
logic [18:0] m_address_vga, m_address;
logic [1:0] state, next;	

// I/O unit as a DMA in system using a FSM
//sequential logic
always_ff @(posedge clk, posedge rst)
begin
	if (rst) state <= 2'b0;
	else state <= next;
end

//next state
always_comb
	case (state)
	2'b00:
		if (selected) begin
			next <= 2'b01;
			mux_select <= 1'b0;
			vga_select <= 1'b0;
			rst_sys <= 1'b0;
		end 
		else begin
			next <= 2'b00;
			mux_select <= 1'b1;
			vga_select <= 1'b0;
			rst_sys <= 1'b1;
		end
	2'b01: 
		if (!reg_15[0] && selected) begin
			next <= 2'b01;
			mux_select <= 1'b0;
			vga_select <= 1'b0;
			rst_sys <= 1'b0;
		end
		else if(reg_15[0] && selected) begin 
			next <= 2'b10;
			mux_select <= 1'b1;
			vga_select <= 1'b1;
			rst_sys <= 1'b1;
		end else begin
			next <= 2'b00;
			mux_select <= 1'b1;
			vga_select <= 1'b0;
			rst_sys <= 1'b1;
		end
	2'b10: 
//		if (selected) 
		begin
			next <= 2'b10;
			mux_select <= 1'b1;
			vga_select <= 1'b1;
			rst_sys <= 1'b1;
		end 
//		else begin
//			next <= 2'b00;
//			mux_select <= 1'b1;
//			vga_select <= 1'b0;
//			rst_sys <= 1'b1;
//		end
	default: next <= 2'b00;
	endcase

// MUX for address input to data memory controlled by I/O logic
 multiplexer #(.N(19)) mux1 
 (.d1(m_address_cpu[18:0]), .d2(m_address_vga), .d3(19'b0),
.selector({1'b0,mux_select}),
.out(m_address));

// MUX for write enable in memory controlled by I/O logic
 multiplexer #(.N(1)) mux2  
 (.d1(m_wren_cpu), .d2(1'b0), .d3(1'b0),
.selector({1'b0,mux_select}),
.out(m_write_e));

// DEMUX for read data from meory controlled by I/O logic
demultiplexer #(.N(8)) demux
(.in(m_rdata),
.selector(mux_select),
.out1(m_rdata_cpu), .out2(m_rdata_vga));

// Processor is a ASIP for the RSA algorithm
processor cpu
(.clk(clk), .rst(rst||rst_sys), .inst(inst), // instruction input from inst memory
.input_data({24'b0,m_rdata_cpu}), // data input from data memory
.memw_m(m_wren_cpu), // memory write enable output control
.pcf(pc_f), // pc address output to inst memory
.m_address(m_address_cpu), // memory address output to data memory
.m_data(m_write_data),
.reg_15(reg_15));

// Data memory, RAM type. 
data_memory ram
(.address(m_address), .clock(~clk), .data(m_write_data[7:0]),
.wren(m_write_e), .q(m_rdata));

// Instruction memory, ROM type
Instr_mem rom
(.a(pc_f), .rd(inst));

// Single output of the system, VGA controller for a 640x480 display
VGA_Controller Vga_controller
// Inputs
(.clk(~clk), .selected(~vga_select), .current_pixel(m_rdata_vga),
// Outputs
.h_sync(h_sync), .v_sync(v_sync), .rgb(rgb),
.clk_25mhz(clk_25mhz), .sync_n(sync_n), .blank_n(blank_n), .address(m_address_vga));

assign reg15 = reg_15[0];
assign R = rgb;
assign G = rgb;
assign B = rgb;

endmodule 