/*
	memoria
		[3]	= Tag
		[2:0]	= Dado
*/
module mem(barin,clk,barout);
		
		input [10:0]barin;
		input clk;
		output reg [10:0]barout;

		parameter readmiss = 2'b01;
		parameter invalidate = 2'b10;
		parameter return = 2'b11;
		
		reg [3:0]Memoria[1:0];
		
		initial begin
			Memoria[0] = 4'b1001;
			Memoria[1] = 4'b1000;
		end
		
		always @(posedge clk) begin
			barout = 11'b00000000000;
			if(barin[5:4] == readmiss) begin
				barout[10] = 0;
				barout[9:8] = barin[9:8];
				barout[5:4] = return;
				barout[3] = barin[3];
				if(barin[3] == 0) begin
					barout[2:0] = Memoria[0][2:0];
				end
				else begin 
					barout[2:0]	= Memoria[1][2:0];
				end
			end
		end
endmodule
