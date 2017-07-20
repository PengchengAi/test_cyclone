`define CNT_WIDTH 32
`define CYCYLE 100
module measure_intval(
  input rst,
  input clk_0,//0 degree
  input clk_1,//90 degree
  input clk_2,//180 degree
  input clk_3,//270 degree
  input sig_a,
  input sig_b,
  output [`CNT_WIDTH-1:0] intval_cnt,
  output cnt_valid);
  
reg [7:0] cycle_cnt;
reg cnt_restart;
reg cnt_valid_r;
always@(posedge sig_a or posedge rst)
begin
  if(rst)
  begin
    cycle_cnt<=4'd0;
    cnt_restart<=1'b0;
    cnt_valid_r<=1'b0;
  end
  else if(cycle_cnt>`CYCYLE)
  begin
    cycle_cnt<=0;
    cnt_restart<=1'b1;
    cnt_valid_r<=1'b0;
  end
  else if(cycle_cnt>`CYCYLE-1)
  begin
    cycle_cnt<=cycle_cnt+1;
    cnt_restart<=1'b0;
    cnt_valid_r<=1'b1;
  end
  else
  begin
    cycle_cnt<=cycle_cnt+1;
    cnt_restart<=1'b0;
    cnt_valid_r<=1'b0;
  end
end

assign cnt_valid=cnt_valid_r;

//produce gate
wire gate;
assign gate=sig_a & (~sig_b) & (~cnt_valid_r);

wire rst_or;
assign rst_or=rst | cnt_restart;

//0 degree
reg [`CNT_WIDTH-1:0] cnt_intval_0;
always@(posedge clk_0 or posedge rst_or)
begin
  if(rst_or)
    cnt_intval_0<={`CNT_WIDTH{1'b0}};
  else if(gate)
    cnt_intval_0<=cnt_intval_0+1;
end

//90 degree
reg [`CNT_WIDTH-1:0] cnt_intval_1;
always@(posedge clk_1 or posedge rst_or)
begin
  if(rst_or)
    cnt_intval_1<={`CNT_WIDTH{1'b0}};
  else if(gate)
    cnt_intval_1<=cnt_intval_1+1;
end

//180 degree
reg [`CNT_WIDTH-1:0] cnt_intval_2;
always@(posedge clk_2 or posedge rst_or)//posedge clk_2
begin
  if(rst_or)
    cnt_intval_2<={`CNT_WIDTH{1'b0}};
  else if(gate)
    cnt_intval_2<=cnt_intval_2+1;
end

//270 degree
reg [`CNT_WIDTH-1:0] cnt_intval_3;
always@(posedge clk_3 or posedge rst_or)//posedge clk_3
begin
  if(rst_or)
    cnt_intval_3<={`CNT_WIDTH{1'b0}};
  else if(gate)
    cnt_intval_3<=cnt_intval_3+1;
end

wire [`CNT_WIDTH-1:0] cnt_intval_last;
assign cnt_intval_last=cnt_intval_0 + cnt_intval_1 + cnt_intval_2 + cnt_intval_3;

reg [`CNT_WIDTH-1:0] cnt_intval_last_r;
always@(posedge clk_0)
begin
  if(cnt_valid_r)
    cnt_intval_last_r<=cnt_intval_last;
end

assign intval_cnt=cnt_intval_last_r;

endmodule
