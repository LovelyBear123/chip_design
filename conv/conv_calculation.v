
// conv_calulation module
// -----------------------------------------------------------------------------
// Author : ytcheng
// File   : conv_calculation.v
// Create : 2020-06-15 16:59:14
// Revise : 2020-06-15 16:59:14
// Editor : sublime text3, tab size (4)
// -----------------------------------------------------------------------------
// module function: used for calculate conv result
// input: clk, reset, pixel, weight, start,fifo_empty
// output: finish, output_data,output_addr,output_req;
// -----------------------------------------------------------------------------

module conv_calculation(clk,
						reset,
						start,
						pixel,
						weight,
						fifo_empty,
						finish,
						fifo_read,
						output_data,
						output_req,
						output_addr);

//port definition
input clk,reset,start,fifo_empty;
input wire [`pixel_width-1:0] pixel;
input wire [`weight_width-1:0] weight;
output finish,output_req,fifo_read;
output reg [`output_data_width-1:0] output_data;
output wire [`output_data_addr_width-1:0] output_addr;

reg partial_sum_done;//the sum of 9 elements in a window is done
reg signed [`output_data_width-1:0] partial_mul;
reg signed [`output_data_width-1:0] partial_sum;
reg finish;
reg cal_start;

//calculation start signal, 1 period after !fifo_empty to make sure fifo is not empty
always @(posedge clk or negedge reset) begin
if (!reset) 
cal_start  <=0;    
else
cal_start<=!fifo_empty;
end

wire read_disable = read_disable_1 | read_disable_2 ;//to make sure cnt=0, dont read from fifo
reg read_disable_1;
reg read_disable_2;
always @(negedge clk or negedge reset) begin
if (!reset)
	read_disable_1<=0;
else if (cal_cnt == 9)
	read_disable_1<=0;
else if (cal_cnt == 0)
	read_disable_1<=1;
else
	read_disable_1<=read_disable_1;
end

always @(posedge clk or negedge reset) begin
if (!reset)
	read_disable_2<=0;
else if (cal_cnt == 9)
	read_disable_2<=1;
else if (cal_cnt == 0)
	read_disable_2<=0;
else
	read_disable_2<=read_disable_2;
end


//fifo read signal
assign fifo_read = cal_start && read_disable;


//a 8 counter to determine partial_sum_done signal
reg [3:0] cal_cnt;
always @(posedge clk or negedge reset) begin
if (!reset) 
	cal_cnt <= 0;
else if (cal_cnt==9)
	cal_cnt <= 0;
else begin
if (cal_start)
	cal_cnt <= cal_cnt+1;
end
end

//generate partial_sum_done signal
always @(posedge clk or negedge reset) begin
if (!reset)
	partial_sum_done <= 0;
else if (cal_cnt==9&&!finish)
	partial_sum_done <=1;
else if (cal_cnt == 0)
	partial_sum_done <=0;
else
	partial_sum_done<=partial_sum_done;
end


//partion production calculation
wire signed [`pixel_width-1:0] _a; //transform to signed number
wire signed [`weight_width-1:0] _b;
assign _a = pixel;
assign _b = weight;
always @(*) begin
if (cal_start && cal_cnt!=0)
partial_mul = _a*_b;
else
partial_mul = 0;
end

//conv_sum calculation
always @(posedge clk or negedge reset) begin
if (!reset)
partial_sum <= 0;
else if (cal_cnt ==0)
partial_sum <= 0;
else
partial_sum <=partial_sum + partial_mul;
end

//relu
always @(*) begin
if (partial_sum[`output_data_width-1]==1)
output_data =0;
else
output_data = partial_sum;
end


reg [`output_data_addr_width-1:0] mem_addr;
//output_addr generate
always @(posedge clk or negedge reset) begin
if (!reset)
	mem_addr <= 0;
else if (partial_sum_done)
	mem_addr <= mem_addr+1;
else
	mem_addr <= mem_addr;
end


assign  output_addr = mem_addr;


//output_req
assign output_req = partial_sum_done;


reg [9:0] finish_cnt;
//finish
always @(posedge clk or negedge reset) begin
if (!reset)
	finish_cnt <=0;
else if (partial_sum_done) 
	finish_cnt <= finish_cnt+1;
else
	finish_cnt <=finish_cnt;
end

always @(posedge clk or negedge reset) begin
if (!reset)
	finish<=0;
else if (finish_cnt == 899)
	finish<=1;
else
	finish<=finish;
end

endmodule