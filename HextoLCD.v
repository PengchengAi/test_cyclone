module HextoLCD(
	input [31:0] Hex_data,
	output [63:0] Char_data
	);

//8
genvar i;
generate
for(i=0;i<8;i=i+1)
begin:HtC 
	HextoAsc HextoAsc_inst(
	.Hex_data(Hex_data[i*4+3:i*4]),
	.Char_data(Char_data[i*8+7:i*8])
	);
end
endgenerate

endmodule