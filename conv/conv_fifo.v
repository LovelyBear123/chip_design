
// -----------------------------------------------------------------------------
// fifo for conv
// -----------------------------------------------------------------------------
// Author : ytcheng
// File   : conv_fifo.v
// Create : 2020-06-14 21:07:58
// Revise : 2020-06-14 21:07:58
// Editor : sublime text3, tab size (4)
// -----------------------------------------------------------------------------
// module function:
// used for inter-module communication
// -----------------------------------------------------------------------------

module conv_fifo(clk,reset,w_en, data_w, r_en, data_r, empty, full);

//parameter setting
parameter width = 4'd9;
parameter depth = 8'd1024;
parameter depth_bits = 5'd10;

//--- port definition ---
input clk, reset, w_en, r_en;
input [width-1: 0] data_w;
output reg [width-1: 0] data_r;
output empty, full;

reg [depth_bits-1:0] r_ptr,w_ptr; 
reg [width-1:0] fifo_ram [0:depth-1];

// generate full and empty signals
assign full =(r_ptr[depth_bits-2:0]==w_ptr[depth_bits-2:0]) && (r_ptr[depth_bits-1]!=w_ptr[depth_bits-1]);
assign empty =r_ptr[depth_bits-1:0]==w_ptr[depth_bits-1:0];

//write
always @(posedge clk) begin
if (w_en && !full)
	fifo_ram[w_ptr[depth_bits-1:0]]<=data_w;
else
	fifo_ram[w_ptr[depth_bits-1:0]]<=fifo_ram[w_ptr[depth_bits-1:0]];
end

//read
always @(posedge clk or negedge reset) begin
if (!reset)
	data_r <= 0;
else if (r_en && !empty)
	data_r <= fifo_ram[r_ptr[depth_bits-1:0]];
else
	data_r <= data_r;
end

//update w_ptr
always @(posedge clk or negedge reset) begin
if (!reset)
	w_ptr <= 0;
else if (w_en && !full)
	w_ptr <= w_ptr+1'b1;
else
	w_ptr <= w_ptr;
end

//update r_ptr
always @(posedge clk or negedge reset) begin
if (!reset)
	r_ptr <= 0;
else if (r_en && !empty)
	r_ptr <= r_ptr+1'b1;
else
	r_ptr <= r_ptr;
end

endmodule
