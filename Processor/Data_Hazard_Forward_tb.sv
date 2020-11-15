module Data_Hazard_Forward_tb ();

logic memtoreg, wrenM, wrenW;
logic [3:0] R1_E, R2_E, Rd_M, Rd_WB;
logic [1:0] S_Hazard_A, S_Hazard_B;
Data_Hazard_Forward data_hazard_unit
(.memtoreg_M(memtoreg), .regw_m(wrenM), .regw_w(wrenW),
.RegA_E(R1_E), .RegB_E(R2_E), .Rd_M(Rd_M), .Rd_WB(Rd_WB),
.S_Hazard_A(S_Hazard_A), .S_Hazard_B(S_Hazard_B));


initial begin
	memtoreg = 1'b0;
	wrenM = 1'b0;
	wrenW = 1'b0;
	R1_E = 4'b0001; R2_E = 4'b0001; Rd_M = 4'b0001; Rd_WB = 4'b0000; 
	#10;
	memtoreg = 1'b0;
	wrenM = 1'b1;
	wrenW = 1'b0;
	R2_E = 4'b0001; R2_E = 4'b0000; Rd_M = 4'b0001; Rd_WB = 4'b0000; 
	#10;
	memtoreg = 1'b1;
	wrenM = 1'b1;
	wrenW = 1'b0;
	R2_E = 4'b0001; R2_E = 4'b0000; Rd_M = 4'b0001; Rd_WB = 4'b0000; 
	#10;
	memtoreg = 1'b0;
	wrenM = 1'b1;
	wrenW = 1'b1;
	R2_E = 4'b0001; R2_E = 4'b0000; Rd_M = 4'b0001; Rd_WB = 4'b0000; 
	#10;
	memtoreg = 1'b0;
	wrenM = 1'b1;
	wrenW = 1'b1;
	R2_E = 4'b0001; R2_E = 4'b0010; Rd_M = 4'b0001; Rd_WB = 4'b0000;
end
	

endmodule
