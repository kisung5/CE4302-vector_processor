// Porcessor module, contains basic "sweets" for a pipelined cpu.
// Instruction memory and data memory are outside of this module.
module processor #(parameter N = 32, V = 128)
(input logic clk, rst,
input [N-1:0] inst, // instruction input from inst memory
input_data, // data input from data memory
output logic memw_m, // memory write enable output control
output [N-1:0] pcf, // pc address output to inst memory
m_address, // memory address output to data memory
m_data, // data output to data memory
reg_15);  // register from Register Bank that connects to DMA

// %% List of connections/wires in the processor %%

logic [N-1:0] inst_fetched; // wire between fdpipe and register bank

logic [3:0] register_src_e, // source register to Execution stage
register_src_m, // source register to Memory stage
register_src_w, // source register to Writeback stage
registerB_decode, // register B to decode in Register Bank

alu_control_o, // function code for ALU from the control unit
alu_control_e, // function code for ALU to Execution stage

register_A, register_B; // register bypass from Decode for the forward unit

logic regw_o, alusrc_o, branche_o, memw_o, memtoreg_o, vector_o,
branch_e, // control bits from the control unit
regw_e, alusrc_e, memw_e, memtoreg_e, vector_e, // control bits to Execution stage
regw_m, memtoreg_m, vector_m,// control bits to Memory stage
regw_w, memtoreg_w; // control bits to Writeback stage

logic [N-1:0] pc_adder_mux, // wire adder to PC selector MUX
pc_mux_reg, // wire MUX to PC register
imm_ext_o, // imm wire extended to decode/exe pipe
imm_ext_e; // imm wire in execution stage

logic [V-1:0] opA_o, opB_o, // operands in point of origin
opA_e, opB_e, // operands in Execution stage
opA_hazard, opB_hazard_imm, opB_hazard, // operands wires between MUXes in Exectuion Stage
alu_result_e, // result data from the ALU in Execution stage
alu_result_e_out, // final selected result in Execution stage
alu_result_m, // result data from the ALU to Memory stage
alu_result_w, // result data from the ALU to Writeback stage
read_data_w, // read data from Memory to Writeback stage
result_w; // data selected for writeback in register bank

logic select_pc, stall_fetch, flush_decode, stall_mem, //control bits for the control hazard unit
regB; // single control for mux select for operand B

logic [1:0] select_op_A, select_op_B;

logic [4:0] opCodeB;

// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/***********OJO: revisar este codigo porque hay que cambiarlo********/
assign m_address = (alu_result_m > 32'h4AFFF) ? 32'b0:alu_result_m;

// %% List of modules per stage %%

// --Fetch--

// PC register
register #(.N(N)) PC (.wen(1'b1), .rst(rst), .clk(clk), .in(pc_mux_reg), .out(pcf));

// PC adder for next inst address
adder pc_adder (.operandA(pcf), .operandB(32'b100), .result(pc_adder_mux), .cout());

// Mux selector for PC load data
multiplexer pc_load_select (.d1(pc_adder_mux), .d2(imm_ext_e), .d3(32'b0), 
.selector({1'b0,select_pc}), .out(pc_mux_reg));

/************Fetch/Decode instruction pipelined register**************/
fdpipe fetch_decode (.stall_D(stall_fetch), .flush_F(rst || flush_decode), .clk(clk), 
.inst_F(inst), .inst_D(inst_fetched));


// --Decode--

// Control unit, only operates in decode stage and is a combinational unit.
control_unit control (.opcode(inst_fetched[31:27]), .ALUControl(alu_control_o), .RegW(regw_o), 
.ALUSrc(alusrc_o), .BranchE(branche_o), .MemW(memw_o), .MemtoReg(memtoreg_o), .regB(regB),
.vectorMem(vector_o));

// Instruction immidiate extender to 32 bits
zeroextend extender (.operand(inst_fetched[18:0]), .result(imm_ext_o));

// MUX selector for register B
multiplexer #(.N(4)) registerB_mux (.d1(inst_fetched[18:15]), .d2(inst_fetched[26:23]), .d3(4'b0), 
.selector({1'b0, regB}), .out(registerB_decode));

// Register bank
Reg_bank register_bank(.clk(~clk), .rst(rst), .we3(regw_w), 
.ra1(inst_fetched[22:19]), .ra2(registerB_decode), .wa3(register_src_w),
.wd3(result_w),
.rd1(opA_o), .rd2(opB_o), .r_t2(reg_15));


// (input logic flush_E, clk, stall_E,
// input logic regw_D, memw_D, regmem_D, ALUope_D, branch_D, vect_D,
// input [4:0] op_code_D,
// input [L-1:0] ALUctrl_D, 
// input [M-1:0] regScr_D, regAD, regBD,
// input [N-1:0] inm_D,
// input [V-1:0] regA_D, regB_D, /*regVA_D, regVB_D,*/
// output logic regw_E, memw_E, regmem_E, ALUope_E, branch_E, vect_E,
// output [4:0] op_code_E,
// output [L-1:0] ALUctrl_E, 
// output [M-1:0] regScr_E, regAE, regBE,
// output [N-1:0] inm_E,
// output [V-1:0] regA_E, regB_E /*regVA_E, regVB_E*/);

/*************Decode/Execution instrucion pipelined register************************/
depipe decode_execution (.flush_E(rst || flush_decode), .clk(clk), .stall_E(stall_mem),
// input control
.regw_D(regw_o), .memw_D(memw_o), .regmem_D(memtoreg_o), .branch_D(branche_o),
.vect_D(vector_o),
.ALUope_D(alusrc_o), .ALUctrl_D(alu_control_o), .op_code_D(inst_fetched[31:27]),
// input data
.regScr_D(inst_fetched[26:23]), .regA_D(opA_o), .regB_D(opB_o), .inm_D(imm_ext_o),
.regAD(inst_fetched[22:19]), .regBD(registerB_decode),
// output control
.regw_E(regw_e), .memw_E(memw_e), .regmem_E(memtoreg_e), .branch_E(branch_e),
.vect_E(vector_e),
.ALUope_E(alusrc_e), .ALUctrl_E(alu_control_e), .op_code_E(opCodeB),
// output data 
.regScr_E(register_src_e), .regA_E(opA_e), .regB_E(opB_e), .inm_E(imm_ext_e),
.regAE(register_A), .regBE(register_B));

// --Execution--

// Operand A selector MUX for hazard unit
multiplexer_4 #(.N(V)) opA_select (.d1(opA_e), .d2(alu_result_m), .d3(input_data), .d4(result_w), 
.selector(select_op_A), .out(opA_hazard));

// Operand B selector MUX for hazard unit
multiplexer_4 #(.N(V)) opB_select (.d1(opB_e), .d2(alu_result_m), .d3(input_data), .d4(result_w), 
.selector(select_op_B), .out(opB_hazard_imm));

// Operand B selector MUX register or imm
multiplexer #(.N(V)) opB_select1  (.d1(opB_hazard_imm), .d2({imm_ext_e,imm_ext_e,imm_ext_e,imm_ext_e}), .d3(128'b0), 
.selector({1'b0,alusrc_e}), .out(opB_hazard));

// Control hazard unit for branches
control_hazard_unit #(.N(N)) control_hazard
(.branchE(branch_e), .opCode(opCodeB),
.opeA(opA_hazard[N-1:0]), .opeB(opB_hazard[N-1:0]),
.select_pc(select_pc), .flush(flush_decode), .stall(stall_fetch));

// ALU 0
alu #(.N(N)) alu_unit0  (.opcode(alu_control_e[2:0]), // control
.operandA(opA_hazard[N-1:0]), .operandB(opB_hazard[N-1:0]), .result(alu_result_e[N-1:0]), // data
.C_Flag(), .O_Flag(), .N_Flag(), .Z_Flag()); // flags - unused

// ALU 1
alu #(.N(N)) alu_unit1 (.opcode(alu_control_e[2:0]), // control
.operandA(opA_hazard[(N*2)-1:N]), .operandB(opB_hazard[(N*2)-1:N]), .result(alu_result_e[(N*2)-1:N]), // data
.C_Flag(), .O_Flag(), .N_Flag(), .Z_Flag()); // flags - unused

// ALU 2
alu #(.N(N)) alu_unit2 (.opcode(alu_control_e[2:0]), // control
.operandA(opA_hazard[(N*3)-1:N*2]), .operandB(opB_hazard[(N*3)-1:N*2]), .result(alu_result_e[(N*3)-1:N*2]), // data
.C_Flag(), .O_Flag(), .N_Flag(), .Z_Flag()); // flags - unused

// ALU 3
alu #(.N(N)) alu_unit3 (.opcode(alu_control_e[2:0]), // control
.operandA(opA_hazard[V-1:N*3]), .operandB(opB_hazard[V-1:N*3]), .result(alu_result_e[V-1:N*3]), // data
.C_Flag(), .O_Flag(), .N_Flag(), .Z_Flag()); // flags - unused

// Operand B selector MUX register or imm
multiplexer_4 #(.N(V)) alu_rslt_sel  (
    .d1(alu_result_e), 
    .d2(alu_result_e),
    .d3({opA_hazard[N-1:0],opA_hazard[N-1:0],opA_hazard[N-1:0],opA_hazard[N-1:0]}),
    .d4(),
    .selector({alu_control_e[3],alu_control_e[0]}), .out(alu_result_e_out));

// (input logic clk, rst, stall_M,
// input logic regw_E, memw_E, regmem_E, vect_E,
// input [M-1:0] regScr_E,
// input [V-1:0] ALUrslt_E, address_E,
// output logic regw_M, memw_M, regmem_M, vect_M,
// output [M-1:0] regScr_M,
// output [V-1:0] ALUrslt_M, address_M);

/*************Execution/Memory instruction pipelined register********************/
empipe execution_memory (.clk(clk), .rst(rst), .stall_M(stall_mem),
// input control
.regw_E(regw_e), .memw_E(memw_e), .regmem_E(memtoreg_e), .vect_E(vector_e),
// input data
.regScr_E(register_src_e), .ALUrslt_E(opB_hazard_imm), .address_E(alu_result_e_out),
// output control
.regw_M(regw_m), .memw_M(memw_m), .regmem_M(memtoreg_m), .vect_M(vector_m),
// output data
.regScr_M(register_src_m), .ALUrslt_M(m_data), .address_M(alu_result_m));

// --Memory--
// ATENTION: This needs a new module for vector loads and stores
// This stage has no modules, data memory is outside the processor

// (input logic clk, rst, stall_W,
// input logic regw_M, regmem_M,
// input [M-1:0] regScr_M, 
// input [V-1:0] ALUrslt_M, readdata_M,
// output logic regw_W, regmem_W,
// output [M-1:0] regScr_W, 
// output [V-1:0] ALUrslt_W, readdata_W);

/*************Memory/Writeback instruction pipelined register********************/
mwpipe memory_writeback (.clk(clk), .rst(rst), .stall_W(stall_mem),
// input control
.regw_M(regw_m), .regmem_M(memtoreg_m),
// input data
.regScr_M(register_src_m), .ALUrslt_M(alu_result_m), .readdata_M(input_data),
// output control
.regw_W(regw_w), .regmem_W(memtoreg_w),
// output data
.regScr_W(register_src_w), .ALUrslt_W(alu_result_w), .readdata_W(read_data_w));

// Selector MUX for memory data result or ALU operation result
multiplexer #(.N(V)) memory_alu_mux (.d1(alu_result_w), .d2(read_data_w), .d3(128'b0), 
.selector({1'b0,memtoreg_w}), .out(result_w));

// Data hazard unit
Data_Hazard_Forward data_hazard_unit
(.memtoreg_M(memtoreg_m), .regw_m(regw_m), .regw_w(regw_w),
.RegA_E(register_A), .RegB_E(register_B), .Rd_M(register_src_m), .Rd_WB(register_src_w),
.S_Hazard_A(select_op_A), .S_Hazard_B(select_op_B));

endmodule 