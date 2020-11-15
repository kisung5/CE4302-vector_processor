module zeroextend_tb #(parameter N = 32);

	logic [N-1:0] extended;
	logic [18:0] operand_to_extend;
	
	zeroextend #(32) zeroxtend_module (operand_to_extend, extended);
	
	
	initial begin
		operand_to_extend = 260100; #10;
		operand_to_extend = 10; #10;
		
	end


endmodule 