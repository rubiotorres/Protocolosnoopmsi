/*	Teste Receptor
	p/alternar=1;
	Bus		Estado		estado_saida		wb		abortaAcessoMemoria
	01				10					01				1				1				
	01				01					01				0				0
	10				10					00				1				1
	10				01					00				0				0
	10				10					00				1				1
	11				01					00				0				0
	

*/

module ReceptorSnoopingMESI (alternar,bus,estado,estado_saida,wb,abortaAcessoMemoria);
	input alternar;
	input [1:0]bus;
	input [1:0]estado; 
	output reg [1:0]estado_saida; 
	output reg wb,abortaAcessoMemoria;
	
	parameter  exclusive = 2'b10;
	parameter  shared    = 2'b01;
	parameter  invalid	= 2'b00;
	
	parameter  read		= 1'b0;
	parameter  write		= 1'b1;
	
	parameter  readMiss	 = 2'b01;
	parameter  writeMiss	 = 2'b10;
	parameter  invalidate = 2'b11;
	
	always @(bus) begin
		if(alternar == 1) begin
			wb = 0;
			abortaAcessoMemoria = 0;
			estado_saida = estado;
			case(estado) 	 
				exclusive: begin
					estado_saida = exclusive;
					if(bus == writeMiss) begin
//write miss
						estado_saida = invalid;
						wb = 1;
						abortaAcessoMemoria  = 1;
					end
//read miss
					else if (bus == readMiss) begin
						estado_saida = shared;
						wb = 1;
						abortaAcessoMemoria = 1;
					end
				end
				shared: begin 
//write miss e invalidate
					if(bus == writeMiss || bus == invalidate) begin
						estado_saida = invalid;
					end
//read miss
					else if (bus == readMiss) begin
						estado_saida = shared;
					end
				end
				invalid: begin 
					estado_saida = invalid;
				end
			endcase
		end
	end

endmodule
