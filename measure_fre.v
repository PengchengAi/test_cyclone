`define CNT_WIDTH 32
`define CLK_FRE 200000000
module measure_fre(
  input rst,
  input clk,
  input sig_in,
  output [`CNT_WIDTH-1:0] sig_cnt,
  output [`CNT_WIDTH-1:0] gate_cnt,
  output cnt_valid,
  output rst_out,
  output gate_out);


reg cnt_valid_r;
assign cnt_valid=cnt_valid_r;
//produce 2s CLK
`define GATE_2S 400000000
//produce 1s gate
`define GATE_1S `CLK_FRE

reg [`CNT_WIDTH-1:0] cnt_2s;
reg gate_1s;
reg pulse_2s;
always@(posedge clk)
begin
  if(rst)
  begin
    cnt_2s<={`CNT_WIDTH{1'b0}};
    gate_1s<=1'b0;
    pulse_2s<=1'b0;
  end
  else if(cnt_2s>=`GATE_2S-1)//clear
  begin
    cnt_2s<={`CNT_WIDTH{1'b0}};
    gate_1s<=1'b0;
    pulse_2s<=1'b1;
  end
  else if(cnt_2s>=`GATE_1S && cnt_2s<`GATE_2S-1)//++
  begin
    cnt_2s<=cnt_2s+1;
    gate_1s<=1'b0;
    pulse_2s<=1'b0;
  end
  else if(cnt_2s<`GATE_1S)//++
  begin
    cnt_2s<=cnt_2s+1;
    gate_1s<=1'b1;
    pulse_2s<=1'b0;
  end
end

wire rst_or;
assign rst_or=rst | pulse_2s;

//produce real_gate
reg real_gate;
always@(posedge sig_in)
begin
  if(gate_1s)
    real_gate<=1'b1;
  else if(!gate_1s && sig_in)
    real_gate<=1'b0;
end

reg [`CNT_WIDTH-1:0] std_gate_cnt_lock;
reg [`CNT_WIDTH-1:0] std_sig_cnt_lock;

//cnt real_gate
reg [`CNT_WIDTH-1:0] std_gate_cnt;
always@(posedge clk)
begin
  if(rst || pulse_2s)
  begin
    std_gate_cnt<={`CNT_WIDTH{1'b0}};
    std_gate_cnt_lock<=std_gate_cnt;
    cnt_valid_r<=1'b1;
  end
  else if(real_gate)
  begin
    std_gate_cnt<=std_gate_cnt+1;
    cnt_valid_r<=1'b0;
  end
end

//cnt sig_in
reg [`CNT_WIDTH-1:0] std_sig_cnt;

always@(posedge sig_in or posedge rst_or)
begin
  if(rst_or)
    std_sig_cnt<={`CNT_WIDTH{1'b0}};
  else if(real_gate)
    std_sig_cnt<=std_sig_cnt+1;
end

always@(posedge rst_or)
begin
  std_sig_cnt_lock<=std_sig_cnt;
end

//assign sig_cnt=std_sig_cnt;
//assign gate_cnt=std_gate_cnt;
assign sig_cnt=std_sig_cnt_lock;
assign gate_cnt=std_gate_cnt_lock;

//calculate sig fre
//do std_sig_cnt/std_gate_cnt*CLK_FRE
assign rst_out=rst_or;
assign gate_out=real_gate;

endmodule

