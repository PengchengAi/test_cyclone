`define CNT_WIDTH 32
module measure_duty(
  input rst,//from measure_fre,rst_or
  input clk_0,//0 degree
  input clk_1,//90 degree
  input clk_2,//180 degree
  input clk_3,//270 degree
  input sig_in,
  input gate,//from measure_fre,real_gate
  output [`CNT_WIDTH-1:0] duty_cnt,
  output cnt_valid,
  input cnt_lock);
  
//0
reg [`CNT_WIDTH-1:0] cnt_duty0;
always@(posedge clk_0 or posedge rst)
begin
  if(rst)
    cnt_duty0<={`CNT_WIDTH{1'b0}};
  else if(gate && sig_in)
    cnt_duty0<=cnt_duty0+1;    
end

//1
reg [`CNT_WIDTH-1:0] cnt_duty1;
always@(posedge clk_1 or posedge rst)
begin
  if(rst)
    cnt_duty1<={`CNT_WIDTH{1'b0}};
  else if(gate && sig_in)
    cnt_duty1<=cnt_duty1+1;    
end

//2
reg [`CNT_WIDTH-1:0] cnt_duty2;
always@(posedge clk_2 or posedge rst)
begin
  if(rst)
    cnt_duty2<={`CNT_WIDTH{1'b0}};
  else if(gate && sig_in)
    cnt_duty2<=cnt_duty2+1;    
end

//3
reg [`CNT_WIDTH-1:0] cnt_duty3;
always@(posedge clk_3 or posedge rst)
begin
  if(rst)
    cnt_duty3<={`CNT_WIDTH{1'b0}};
  else if(gate && sig_in)
    cnt_duty3<=cnt_duty3+1;    
end

wire [`CNT_WIDTH-1:0] cnt_duty_last;
assign cnt_duty_last=cnt_duty0 + cnt_duty1 + cnt_duty2 + cnt_duty3;

reg [`CNT_WIDTH-1:0] cnt_duty_last_r;
always@(posedge rst)
begin
	cnt_duty_last_r<=cnt_duty_last;
end

assign duty_cnt=cnt_duty_last_r;

endmodule

