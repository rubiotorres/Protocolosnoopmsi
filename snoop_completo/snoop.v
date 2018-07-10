/* ARRUMAR ERRO INSTRUÇÃO, URGENTE
	Inst:
		[6:5] escolhe_processador
		[4] operacao
		[3] Tag
		[2:0] Dado	
*/

module snoop (SW,LEDG,LEDR);
	input  [17:0]SW;
	output [7:0]LEDG;
	output [17:0]LEDR;
	wire [5:0] cache1;
	wire [5:0] cache2;
	wire [5:0] cache3;
	
	
	wire clk = SW[0];
	wire [6:0]Inst = SW[17:11];
	assign Inst = LEDR[17:11];
	snoopinstance s1(Ins,clk,cache1,cache2,cache3);
	assign LEDR[0] = clk;
	assign LEDR[17:11] = Inst;
	assign LEDR[9:4] = cache2;

endmodule

