module processador (inst,barin,clk,escolhe_processador,barout,Cache);
		input [6:0]inst;
		input clk;
		input [1:0]escolhe_processador;
		input [10:0]barin;
		output reg [10:0]barout;
		/*			
			Barramento 
				[10] 	= alternacpu
				[9:8]	= escolhe_processador
				[7]	= wb
				[6]	= TAG - wb
				[5:4]	= Mensagem
				[3]	= Tag
				[2:0]	= Dado
		*/
		
		output reg [5:0]Cache = 6'b000000;
		/*	
			cache
				[5:4] estado  E(10), S(01), I(00)
				[3]	= Tag
				[2:0]	= Dado
		*/
		reg writeback;	
		reg alternabus;		//receptor
		reg alternacpu;		//emissor
		reg [1:0]ocorrencias;
		/*				
			ocorrencicas
				[1] = Opcode
				[0] = acerto
		*/
		
		
		wire [1:0]estado;
		
		parameter exclusive = 2'b10;
		parameter shared  = 2'b01;
		parameter invalid = 2'b00;
		
		parameter read  = 1'b0; 
		parameter write = 1'b1;
		
		parameter readMiss = 2'b01;
		parameter invalidate = 2'b10;
		parameter return = 2'b11;
		
		always @(posedge clk) begin
			alternabus = 0;
			alternacpu = 0;
			barout = 11'b00000000000;
			Cache[5:4] = estado;
			if(inst[6:5] == escolhe_processador) begin
				alternacpu = 1;
				ocorrencias[1] = inst[4];	//Seta o Opcode da instrução para a requisição
				if(inst[4] == read && inst[3] == Cache[3] && Cache[5:4] != invalid) begin
					//Read Hit
					barout[3] = Cache[3];
					barout[2:0] = Cache[2:0];
					ocorrencias[0] = 1;
				end
				else if(inst[4] == read) begin
					//Read Miss
					barout[9:8] = escolhe_processador;
					barout[5:4] = readMiss;
					barout[3] = inst[3];
					alternacpu = 0;
					if(Cache[5:4] == exclusive) begin
						barout[6] = Cache[3];
						barout[7] = 1;
						barout[2:0] = Cache[2:0];
					end
				end
				else if(inst[4] == write && inst[3] == Cache[3] && Cache[5:4] != invalid) begin 
				// Write Hit
					Cache[2:0] = inst[2:0];
					ocorrencias[0] = 1;
					if(Cache[5:4] == shared) begin
						barout[9:8] = escolhe_processador;
						barout[5:4] = invalidate;
						barout[3] = Cache[3];
					end
				end
				else if(inst[4] == write) begin 
					// Write Miss
					if(Cache[5:4] == exclusive) begin // Write miss em estado exclusive gera um writeback
						barout[7] = 1;
						barout[6] = Cache[3];
						barout[2:0] = Cache[2:0];
					end
					// Envia invalidate
					ocorrencias[0] = 0;
					barout[9:8] = escolhe_processador;
					barout[5:4] = invalidate;
					barout[3] = inst[3];
					// Escreve valor na cache
					Cache[3] = inst[3];
					Cache[2:0] = inst[2:0];
				end
			end
			else if(barin[5:4]!= 2'b00) begin
				/*if(barin[5:4] == invalidate && barin[3] == Cache[3] && barin[9:8] != escolhe_processador) begin
					//Cache[5:4] = invalid;
				end
				else*/ if(barin[5:4] == readMiss && barin[3] == Cache[3] && Cache[5:4] != invalid) begin
					if(Cache[5:4] == exclusive) begin
						barout[7] = 1;
						barout[6] = Cache[3];
					end
						barout[10] = 1;
						barout[9:8] = barin[9:8];
						barout[5:4] = return;
						barout[3] = Cache[3];
						barout[2:0] = Cache[2:0];
						Cache[5:4] = shared;
			   end
				else if(barin[5:4] == return && barout[9:8] == escolhe_processador) begin
					//
					if(barout[10] == 1) begin
						Cache[5:4] = shared;
					end
					Cache[3] = barin[3];
					Cache[2:0] = barin[2:0];
				end
			end
		end
	emissor e1(alternacpu,Cache[5:4],ocorrencias[1],ocorrencias[0],clk,estado);
endmodule
