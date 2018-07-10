module snoopinstance (Inst,clk,cache1,cache2,cache3);
	
	input clk;
	input [6:0]Inst;
	output [5:0] cache1;
	output [5:0] cache2;
	output [5:0] cache3;
	wire [10:0]b1; 
	wire [10:0]b2;
	wire [10:0]b3;
	wire [10:0]mem_bus;
	wire [10:0]bus_wire;
	
	processador p1(Inst,bus_wire,clk,2'b01,b1,cache1);
	processador p2(Inst,bus_wire,clk,2'b10,b2,cache2);
	processador p3(Inst,bus_wire,clk,2'b11,b3,cache3);
	mem m1(bus_wire,Clock,mem_bus);
	bus barramento1(b1,b2,b3,mem_bus,clk,bus_wire);

endmodule

