module init_delay_rom(addr,delay);
	parameter INIT_LIST_LENGTH = 1;
	parameter MAX_DELAY_COUNT = 1000000;	
	input wire [$clog2(INIT_LIST_LENGTH) - 1:0] addr;
	output reg [$clog2(MAX_DELAY_COUNT) - 1:0] delay;
	
	
	always @(*)
		begin
			case(addr)
				`ifdef COCOTB_SIM
				'd9 : delay = 'd5;			//Delay after 9th SPI transaction
				'd44 : delay = 'd50;		//Delay after 44th SPI transaction	
				`else
				'd9 : delay = 'd200000;		//Delay after 9th SPI transaction
				'd44 : delay = 'd2000000;	//Delay after 44th SPI transaction	
				`endif				
				default: delay = 'd0;
			endcase
		end
	
endmodule


module init_rom (addr, data);
	parameter INIT_LIST_LENGTH = 1;
	input wire [$clog2(INIT_LIST_LENGTH) - 1:0] addr;
	output reg [8:0] data;
	
	
	always @(*)
		begin
			case(addr)
				'd0 : data = {1'b0,8'hCB}; //0 for command, 1 for data
				'd1 : data = {1'b1,8'h39};
				'd2 : data = {1'b1,8'h2C};
				'd3 : data = {1'b1,8'h00};
				'd4 : data = {1'b1,8'h34};
				'd5 : data = {1'b1,8'h02};
				
				'd6 : data = {1'b0,8'hCF};
				'd7 : data = {1'b1,8'h00};
				'd8 : data = {1'b1,8'hC1};
				'd9 : data = {1'b1,8'h30};
				
				'd10 : data = {1'b0,8'hE8};
				'd11 : data = {1'b1,8'h85};
				'd12 : data = {1'b1,8'h00};
				'd13 : data = {1'b1,8'h78};
				
				'd14 : data = {1'b0,8'hEA};
				'd15 : data = {1'b1,8'h00};
				'd16 : data = {1'b1,8'h00};
				
				'd17 : data = {1'b0,8'hED};
				'd18 : data = {1'b1,8'h64};
				'd19 : data = {1'b1,8'h03};
				'd20 : data = {1'b1,8'h12};
				'd21 : data = {1'b1,8'h81};
				
				'd22 : data = {1'b0,8'hF7};
				'd23 : data = {1'b1,8'h20};
				
				'd24 : data = {1'b0,8'hC0};//Power control
				'd25 : data = {1'b1,8'h23};//VRH[5:0]
				
				'd26 : data = {1'b0,8'hC1};//Power control 
				'd27 : data = {1'b1,8'h10};//SAP[2:0];BT[3:0] 
				
				'd28 : data = {1'b0,8'hC5};//VCM control
				'd29 : data = {1'b1,8'h3E};//Contrast
				'd30 : data = {1'b1,8'h28};
				
				'd31 : data = {1'b0,8'hC7};//VCM control2
				'd32 : data = {1'b1,8'h86};
				
				'd33 : data = {1'b0,8'h36};// Memory Access Control
				'd34 : data = {1'b1,8'h08};//BGR565 Horizontal orientation
				
				'd35 : data = {1'b0,8'h3A};
				'd36 : data = {1'b1,8'h55};	

				'd37 : data = {1'b0,8'hB1};	
				'd38 : data = {1'b1,8'h00};	
				'd39 : data = {1'b1,8'h18};

				'd40 : data = {1'b0,8'hB6};// Display Function Control 
				'd41 : data = {1'b1,8'h08};
				'd42 : data = {1'b1,8'h82};
				'd43 : data = {1'b1,8'h27};
				
				'd44 : data = {1'b0,8'h11};//Exit Sleep
				
				
				'd45 : data = {1'b0,8'h29};//Display On
				'd46 : data = {1'b0,8'h2c};
				
				default: data <= {1'b1,8'h00};
			endcase
		end
	
	
endmodule