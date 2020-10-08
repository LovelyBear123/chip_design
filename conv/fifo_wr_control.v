// read controler for fifo
// -----------------------------------------------------------------------------
// Author : ytcheng
// File   : fifo_rd_control.v
// Create : 2020-06-16 09:28:25
// Revise : 2020-06-16 09:28:25
// Editor : sublime text3, tab size (4)
// -----------------------------------------------------------------------------
// input: data_req(pixel_req/weight_req),reset
// output:fifo_wr_en
// -----------------------------------------------------------------------------
module fifo_wr_control(clk,data_req,reset, fifo_wr_en);

input clk, data_req,reset;
output reg fifo_wr_en;

//fifo_wr_en signal is 1 period after data req;

always @(posedge clk or negedge reset) begin
if (!reset)
	fifo_wr_en<= 0;
else
	fifo_wr_en <= data_req;
end

endmodule