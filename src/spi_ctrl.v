module spi_ctrl (clk, rst_n, en, start, done, data_in, mosi, cs);
	input wire clk;
	input wire rst_n;
	input wire en;
	input wire start;
	output wire done;
	input wire[7:0] data_in;
	output wire mosi;
	output wire cs;
	
	reg [3:0] count;
	wire rst;
	
	always @(posedge clk)
		if(!rst_n)
			count <= 4'd8;
		else
			begin
				if(en)
					begin
						if(count == 4'd8)
							begin
								if(start)
									count <= 4'd0;
							end
						else
							count <= count + 4'd1;
					end
			end
			
	assign cs = count[3];
	assign mosi = data_in[~count[2:0]];
	assign done = (count == 4'd7);

endmodule