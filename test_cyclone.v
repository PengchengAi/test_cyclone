module test_cyclone(
	input rst,
	input CLOCK_50,
	input CLOCK_27,
	input sig_a,
	input sig_b,
	//output sig_out,
	inout	 [7:0]	LCD_DATA,				//	LCD Data bus 8 bits
	output			LCD_ON,					//	LCD Power ON/OFF
	output			LCD_BLON,				//	LCD Back Light ON/OFF
	output			LCD_RW,					//	LCD Read/Write Select, 0 = Write, 1 = Read
	output			LCD_EN,					//	LCD Enable
	output			LCD_RS					//	LCD Command/Data Select, 0 = Command, 1 = Data
	);

//assign sig_out=sig_in;
wire DLY_RST;
wire [31:0] sig_cnt;
wire [31:0] gate_cnt;
wire [31:0] cnt_interval;
wire [31:0] cnt_duty;

wire [31:0] sig_cnt_32b;
wire [31:0] gate_cnt_32b;
wire [31:0] cnt_interval_32b;
wire [31:0] cnt_duty_32b;

wire [63:0] sig_cnt_lcd;
wire [63:0] gate_cnt_lcd;
wire [63:0] cnt_interval_lcd;
wire [63:0] cnt_duty_lcd;

Reset_Delay			r0	(	.iCLK(CLOCK_27),.oRESET(DLY_RST)	);

LCD_TEST 			u5	(	//	Host Side
							.iCLK(CLOCK_27),
							.iRST_N(DLY_RST),
							//	LCD Side
							.LCD_DATA(LCD_DATA),
							.LCD_RW(LCD_RW),
							.LCD_EN(LCD_EN),
							.LCD_RS(LCD_RS),
							.Data_line1(sig_cnt_lcd),
							.Data_line2(gate_cnt_lcd),
							.Data_line3(cnt_interval_lcd),
							.Data_line4(cnt_duty_lcd));
//	LCD ON
assign	LCD_ON		=	1'b1;
assign	LCD_BLON	=	1'b1;

wire clk_250M;
wire clk_0;
wire clk_90;

wire rst_or;
wire real_gate;
wire cnt_fre_valid;

pll_250M pll_250M_inst(
	.inclk0(CLOCK_50),
	.c0(clk_250M),
	.c1(clk_90),
	.locked());

measure_fre measure_fre_insta(
  .rst(~DLY_RST),
  .clk(clk_250M),//250M
  .sig_in(sig_a),
  .sig_cnt(sig_cnt),
  .gate_cnt(gate_cnt),
  .cnt_valid(cnt_fre_valid),
  .rst_out(rst_or),
  .gate_out(real_gate));
 
wire clk_180,clk_270;
assign clk_0=clk_250M;
assign clk_180=~clk_250M;
assign clk_270=~clk_90;
 
measure_intval measure_intval_inst(
  .rst(~DLY_RST),
  .clk_0(clk_0),//0 degree
  .clk_1(clk_90),//90 degree
  .clk_2(clk_180),//180 degree
  .clk_3(clk_270),//270 degree
  .sig_a(sig_a),
  .sig_b(sig_b),
  .intval_cnt(cnt_interval),
  .cnt_valid());

measure_duty measure_duty_insta(
  .rst(rst_or),//from measure_fre,rst_or
  .clk_0(clk_0),//0 degree
  .clk_1(clk_90),//90 degree
  .clk_2(clk_180),//180 degree
  .clk_3(clk_270),//270 degree
  .sig_in(sig_a),
  .gate(real_gate),//from measure_fre,real_gate
  .duty_cnt(cnt_duty),
  .cnt_valid(),//not used
  .cnt_lock(cnt_fre_valid));//not used
  

  
assign sig_cnt_32b=sig_cnt;
assign gate_cnt_32b=gate_cnt;
assign cnt_interval_32b=cnt_interval;
assign cnt_duty_32b=cnt_duty;
/*
reg [3:0] data_inc;
always@(posedge CLOCK_27)
begin
	data_inc<=data_inc+1;
end
*/
HextoLCD HextoLCD_inst1(
	.Hex_data(sig_cnt_32b),//sig_cnt_32b
	.Char_data(sig_cnt_lcd)
	);

HextoLCD HextoLCD_inst2(
	.Hex_data(gate_cnt_32b),
	.Char_data(gate_cnt_lcd)
	);

HextoLCD HextoLCD_inst3(
	.Hex_data(cnt_interval_32b),
	.Char_data(cnt_interval_lcd)
	);
	
HextoLCD HextoLCD_inst4(
	.Hex_data(cnt_duty_32b),
	.Char_data(cnt_duty_lcd)
	);
	
endmodule
