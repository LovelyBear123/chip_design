// weight address generation
// -----------------------------------------------------------------------------
// Author : ytcheng
// File   : weight_addr_gen.v
// Create : 2020-06-14 11:06:14
// Revise : 2020-06-14 11:06:14
// Editor : sublime text3, tab size (2)
// -----------------------------------------------------------------------------
// module function:
// input:clk,reset,start;
// output：1.give out the weight_addr in the conv windows
// -----------------------------------------------------------------------------

module weight_addr_gen(clk,reset, start,weight_addr);


input clk,reset,start;
output [`weight_addr_width-1:0] weight_addr;
reg [`weight_addr_width-1:0] weight_addr;
reg [3:0] weight_cnt; //a 9-counter, used for count the weight_addr generated, when =9 cnt->0

//the 9-counter
always @(posedge clk or negedge reset) begin
if (!reset) 
	weight_cnt <= 0;
else if (weight_cnt==8)
	weight_cnt <= 0;
else begin
if (start)
	weight_cnt <= weight_cnt+1;
end
end

//generate output weight_addr
always @(*) begin
if (start) begin
	case(weight_cnt)
	4'd0:  weight_addr = 0;
	4'd1:  weight_addr = 1;
	4'd2:  weight_addr = 2;
	4'd3:  weight_addr = 3;
	4'd4:  weight_addr = 4;
	4'd5:  weight_addr = 5;
	4'd6:  weight_addr = 6;
	4'd7:  weight_addr = 7;
	4'd8:  weight_addr = 8;
	default:weight_addr = `weight_addr_width'bx;
	endcase
end
else
weight_addr = 0;
end


endmodule