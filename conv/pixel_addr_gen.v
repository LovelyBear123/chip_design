// pixel address generation
// -----------------------------------------------------------------------------
// Author : ytcheng
// File   : pixel_addr_gen.v
// Create : 2020-06-14 11:06:14
// Revise : 2020-06-14 11:06:14
// Editor : sublime text3, tab size (2)
// -----------------------------------------------------------------------------
// module function:
// input:clk,reset,start;
// output：1.give out the pixel_addr in the conv windows pixel_addr
// -----------------------------------------------------------------------------

module pixel_addr_gen (clk,
	                   reset,
	                   start,
	                   pixel_addr);


//--- port definition ---
input clk,reset,start;
output [`pixel_addr_width-1:0] pixel_addr;
reg [`pixel_addr_width-1:0] pixel_addr;
reg [`pixel_addr_width-1:0] first_pixel;
reg [3:0] pixel_cnt; //a 9-counter, used for count the pixel_addr generated, when =9 cnt->0


//the 9-counter
always @(posedge clk or negedge reset) begin
if (!reset) 
	pixel_cnt <= 0;
else if (pixel_cnt==8)
	pixel_cnt <= 0;
else begin
if (start)
	pixel_cnt <= pixel_cnt+1;
end
end


//generate the first position(top-left) in the conv window
always @(posedge clk or negedge reset) begin
if (!reset) 
	first_pixel <= `pixel_addr_width'b0;
else if (start&&pixel_cnt==8) begin
	case(first_pixel)
	29,61,93,125,157,189,221,253,285,317,349,381,413, 
	445,477,509,541,573,605,637,669,701,733,765,797,
	829,861,893,925: 
	first_pixel <= first_pixel+3;
	default:first_pixel <= first_pixel+1;
	endcase
end
else 
	first_pixel <= first_pixel;
end

//generate output pixel_addr
always @(*) begin
if (start) begin
	case(pixel_cnt)
	4'd0:  pixel_addr = first_pixel + 7'd0;
	4'd1:  pixel_addr = first_pixel + 7'd1;
	4'd2:  pixel_addr = first_pixel + 7'd2;
	4'd3:  pixel_addr = first_pixel + 7'd32;
	4'd4:  pixel_addr = first_pixel + 7'd33;
	4'd5:  pixel_addr = first_pixel + 7'd34;
	4'd6:  pixel_addr = first_pixel + 7'd64;
	4'd7:  pixel_addr = first_pixel + 7'd65;
	4'd8:  pixel_addr = first_pixel + 7'd66;
	default:pixel_addr = `pixel_addr_width'bx;
	endcase
end
else
pixel_addr = 0;
end

endmodule