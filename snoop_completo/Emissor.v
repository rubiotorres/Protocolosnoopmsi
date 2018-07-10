/*Testes emissor
	p/alternar=0
	Estado	operacao	acerto	estado_saida	wb		bus
	00				0			0			01				0		01
	00				1			0			10				0		10
	01				0			1			01				0		0
	01				1			1			10				0		11
	01				0			0			01				0		01
	01				1			0			10				0		10
	10				0			1			10				0		0			
	10				1			1			10				0		0	
	10				0			0			01				1		01
	10				1			0			10				1		10

*/

module emissor(alternar,estado,operacao,acerto,Clk,estado_saida);
	input alternar,operacao,acerto;
	input [1:0]estado;
	input Clk;
	output reg [1:0]estado_saida;
	
	parameter  exclusive  = 2'b10;
	parameter  shared    = 2'b01;
	parameter  invalid	= 2'b00;
	
	parameter  read		= 1'b0;
	parameter  write		= 1'b1;
	
	parameter  readMiss	 = 2'b01;
	parameter  writeMiss	 = 2'b10;
	parameter  invalidate = 2'b11;
	
	initial estado_saida = invalid;
	
	always @(negedge Clk) begin
		   if(alternar == 0) begin
			case(estado)
				exclusive: begin
					if(acerto == 1) begin
// write hit, read hit
						estado_saida = exclusive;
					end
					else if(operacao == read) begin
//read miss
						estado_saida = shared;
					end
					else begin
//write miss
						estado_saida = exclusive;
					end
				end
				shared: begin
					if(operacao == read && acerto == 1) begin
//Read Hit
						estado_saida = shared;
					end
					else if(operacao == read && acerto == 0 ) begin
//Read Miss
						estado_saida = shared;
					end
					else if(operacao == write && acerto == 1) begin
//Write Hit
						estado_saida = exclusive;
					end
					else if(operacao == write && acerto == 0) begin
//WriteMiss
						estado_saida = exclusive;
					end
				end
				invalid: begin
					if(operacao == read ) begin
						estado_saida = shared;
					end
					else if(operacao == write) begin
						estado_saida = exclusive;
					end
				end
			endcase
		end
	end
endmodule
