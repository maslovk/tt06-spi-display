module tt_um_maslovk_lcd_ctrl_top (clk, rst_n, sck, mosi, cs, dc, reset);
	input wire clk;
	input wire rst_n;
	input wire ena;
	output wire mosi;
	output wire cs;
	output wire dc;
	output wire sck;
	output wire reset;
	
	`define COLOR_RED 16'hF800
	
	parameter INIT_LIST_LENGTH = 46;
	
	`ifdef COCOTB_SIM
	parameter SCREEN_RESOLUTION = 32*24 * 2;
	`else
	parameter SCREEN_RESOLUTION = 320*240 * 2;
	`endif
	
	parameter MAX_DELAY_COUNT = 10000000;
	
	reg [$clog2(INIT_LIST_LENGTH + SCREEN_RESOLUTION) - 1:0] count;
	
	
	wire start;
	wire done;
	wire [8:0]init_rom_data;
	wire [8:0] pixel_rom_data;
	wire [8:0] rom_data;
	wire [$clog2(MAX_DELAY_COUNT) - 1:0]delay;
	wire wait_req;
	
	wire data_clk_en;
	wire latch_clk_en;
	
	spi_clk_phase #(.PHASE(0)) spi_clk_phase_inst(.clk(clk), .rst_n(rst_n), .data_clk_en(data_clk_en), .latch_clk_en(latch_clk_en));
	
	init_rom #(.INIT_LIST_LENGTH(INIT_LIST_LENGTH + SCREEN_RESOLUTION)) ili9341_init_rom(.addr(count), .data(init_rom_data));
	init_delay_rom #(.INIT_LIST_LENGTH(INIT_LIST_LENGTH + SCREEN_RESOLUTION), .MAX_DELAY_COUNT(MAX_DELAY_COUNT)) ili9341_init_delay_rom(.addr(count), .delay(delay));
	
	color_data_rom #(.DATA_LIST_LENGTH(INIT_LIST_LENGTH + SCREEN_RESOLUTION)) ili9341_color_data_rom(.addr(count), 
		.data(pixel_rom_data), .color(`COLOR_RED));
	
	
	delay #(.MAX_DELAY_COUNT(MAX_DELAY_COUNT)) delay_inst(.clk(clk), .rst_n(rst_n), .en(data_clk_en), .start(done), .delay(delay), .wait_req(wait_req));
	spi_ctrl spi(.clk(clk), .rst_n(rst_n), .en(data_clk_en), .start(start), .done(done), .data_in(rom_data[7:0]), .mosi(mosi), .cs(cs));
	
	always @(posedge clk)
		if(!rst_n)
			count <= 'd0;
		else
			begin
				if(data_clk_en)
					begin
						if(count != (INIT_LIST_LENGTH + SCREEN_RESOLUTION))
							if(done)
								count <= count + 'd1;	
					end
			end
			
	assign dc = rom_data[8];
	assign start = (count != (INIT_LIST_LENGTH + SCREEN_RESOLUTION)) && !wait_req;
	
	assign rom_data = (count > INIT_LIST_LENGTH) ? pixel_rom_data : init_rom_data;
	
	assign sck = latch_clk_en;
	
	assign reset = 1'b1;
	
	
	`ifdef COCOTB_SIM
	initial begin
  	$dumpfile ("tb.vcd");
  	$dumpvars (0, tt_um_maslovk_lcd_ctrl_top);
  	#1;
	end
	`endif


endmodule

module delay(clk, rst_n, en, start, delay, wait_req);
	parameter MAX_DELAY_COUNT = 1000000;
	input wire clk;
	input wire rst_n;
	input wire en;
	input wire start;
	input wire[$clog2(MAX_DELAY_COUNT) - 1:0] delay;
	output wire wait_req;
	
	reg [$clog2(MAX_DELAY_COUNT) - 1:0] delay_count;
	
	always @(posedge clk)
		if(!rst_n)
			delay_count <= 'd0;
		else
			begin
				if(en)
					begin
						if(delay_count == 'd0)
							begin
								if(start)
									delay_count <= delay;
							end
						else
							delay_count <= delay_count - 'd1;
					end
			end
			
	assign wait_req = (delay_count != 'd0);
			
endmodule

module spi_clk_phase(clk, rst_n, data_clk_en, latch_clk_en);
	parameter PHASE = 0;
	input wire clk;
	input wire rst_n;
	output wire data_clk_en;
	output wire latch_clk_en;
	
	reg count;
	reg count_phase_shift;
	
	always @(posedge clk)
		if(!rst_n)
			count <= 1'b0;
		else
			begin
				count <= ~count;
			end
			
	always @(posedge clk)
		if(!rst_n)
			count_phase_shift <= 1'b0;
		else
			begin
				count_phase_shift <= count;
			end
			
	assign data_clk_en = count;
	assign latch_clk_en = (PHASE == 0) ? count : count_phase_shift;
			
endmodule
