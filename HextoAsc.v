module HextoAsc(
	input [3:0] Hex_data,
	output [7:0] Char_data
	);

reg [7:0] Char_data_r;
always@(Hex_data)
begin
	case(Hex_data)
	4'h0:Char_data_r<=8'd48;
	4'h1:Char_data_r<=8'd49;
	4'h2:Char_data_r<=8'd50;
	4'h3:Char_data_r<=8'd51;
	4'h4:Char_data_r<=8'd52;
	4'h5:Char_data_r<=8'd53;
	4'h6:Char_data_r<=8'd54;
	4'h7:Char_data_r<=8'd55;
	4'h8:Char_data_r<=8'd56;
	4'h9:Char_data_r<=8'd57;
	4'ha:Char_data_r<=8'd97;
	4'hb:Char_data_r<=8'd98;
	4'hc:Char_data_r<=8'd99;
	4'hd:Char_data_r<=8'd100;
	4'he:Char_data_r<=8'd101;
	4'hf:Char_data_r<=8'd102;
	endcase
end

assign Char_data=Char_data_r;

endmodule
