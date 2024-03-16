module color_data_rom (addr, data, color);
	parameter DATA_LIST_LENGTH = 1;
	input wire [$clog2(DATA_LIST_LENGTH) - 1:0] addr;
	input wire [15:0] color; //RGB 565
	output reg [8:0] data;
	
	
	always @(*)
		begin
			case(addr[0])
					'd1: data <= {1'b1,color[15:8]};
				default: data <= {1'b1,color[7:0]};
			endcase
		end
	
	
endmodule