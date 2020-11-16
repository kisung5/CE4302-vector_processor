module Reg_bank #(parameter V = 128, N = 32, M = 4) (
input logic clk, rst,
input logic we3,
input logic [M-1:0] ra1, ra2, wa3,
//input logic [V-1:0] wev,
input logic [V-1:0] wd3,
output logic [V-1:0] rd1, rd2/*,
output reg [31:0] r_vga*/);

logic [31:0] rf [11:0];
logic [127:0] rv [3:0];

integer i;


always_ff @(posedge clk)
begin
	if (rst)
		begin
        for (i=0; i<12; i++) rf[i] <= 32'b0;
		  for (i=0; i<4; i++) rv[i] <= 128'b0;
//		  r_vga <= 32'b0;
      end 
	else if(we3) 
	begin
		if(wa3 > 4'b1011)
			rv[wa3-4'b1100] <= wd3;
		else //if (we3 & wa3 != 15) 
			rf[wa3] <= wd3[N-1:0];
	end
//	else
//		r_vga <= (we3) ? wd3 : r_vga;
end

assign rd1 = (ra1 > 4'b1011)?/*(ra1 == 4'b1111) ? r_vga :*/rv[ra1-4'b1100] : {96'b0, rf[ra1]};

assign rd2 = (ra2 > 4'b1011)?/*(ra2 == 4'b1111) ? r_vga :*/rv[ra2-4'b1100] : {96'b0, rf[ra2]};

endmodule 
