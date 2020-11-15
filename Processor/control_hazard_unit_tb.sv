module control_hazard_unit_tb ();

logic be, selpc, flush, stall;
logic [4:0] op;
logic [31:0] opeA, opeB;

control_hazard_unit DUT
(.branchE(be), .opCode(op), .opeA(opeA), .opeB(opeB),
.select_pc(selpc), .flush(flush), .stall(stall));


initial begin
	be = 0;
	op = 5'b0;
	opeA = 32'b0;
	opeB = 32'b0;
	#20;
	be = 0;
	op = 5'b00101;
	opeA = 32'h5c;
	opeB = 32'h5c;
	#20;
	be = 1;
	op = 5'b01000;
	opeA = 32'h5c;
	opeB = 32'h5c;
	#20;
	be = 0;
	op = 5'b01000;
	opeA = 32'h5c;
	opeB = 32'h5c;
	#20;
	be = 1;
	op = 5'b01000;
	opeA = 32'h55;
	opeB = 32'h5c;
	#20;
	be = 1;
	op = 5'b01001;
	opeA = 32'h5c;
	opeB = 32'h5c;
	#20;
	be = 1;
	op = 5'b01001;
	opeA = 32'h60;
	opeB = 32'h5c;
end
endmodule 