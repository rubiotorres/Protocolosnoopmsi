module bus (Barramento1,Barramento2,Barramento3,BarramentoMemoria,Clock,BusWire);
	input [10:0]Barramento1;
	input [10:0]Barramento2;
	input [10:0]Barramento3;
	input [10:0]BarramentoMemoria;
	input Clock;
	output reg [10:0]BusWire;
		
	always @(Clock) begin
		BusWire = 11'b00000000000;
		if(Barramento1[7] == 1 || Barramento1[5:4] != 2'b00) begin
			BusWire = Barramento1;
		end
		else if(Barramento2[7] == 1 || Barramento2[5:4] != 2'b00)begin
			BusWire = Barramento2;
		end
		else if(Barramento3[7] == 1 || Barramento3[5:4] != 2'b00)begin
			BusWire = Barramento3;
		end
		else if(BarramentoMemoria[5:4] != 2'b00)begin
			BusWire = BarramentoMemoria;
		end
	end
endmodule
