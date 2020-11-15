module Reg_bank(input logic clk, rst,
					input logic we3,
					input logic [3:0] ra1, ra2, wa3,
					input logic [127:0] wev,
					input logic [31:0] wd3,
					output logic [31:0] rd1, rd2,
					output reg [31:0] r_vga);

logic [31:0] rf [14:0];
logic [127:0] rv [3:0];

integer i;


always_ff @(posedge clk)
begin
	if (rst)
		begin
        for (i=0; i<15; i=i+1) rf[i] <= 32'b0;
		  r_vga <= 32'b0;
      end 
	else if(we3 > 4'b1100)
		rv[wa3] <= wev;
	else if (we3 & wa3 != 15) 
		rf[wa3] <= wd3;
	else
		r_vga <= (we3) ? wd3 : r_vga;
end

assign rd1 = (ra1 == 4'b1111) ? r_vga : rf[ra1];

assign rd2 = (ra2 == 4'b1111) ? r_vga : rf[ra2];

endmodule 
