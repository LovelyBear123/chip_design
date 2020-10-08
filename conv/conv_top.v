
// Top module for conv calculation
// -----------------------------------------------------------------------------
// Author : ytcheng
// File   : conv_top.v
// Create : 2020-06-14 11:06:48
// Revise : 2020-06-14 11:06:48
// Editor : sublime text3, tab size (2)
// -----------------------------------------------------------------------------
// module function: connect conv module with sram
// input:clk, reset, start
// output:finish 
// -----------------------------------------------------------------------------
`include "./conv.v"

//macro defination
`define pixel_width  9
`define pixel_addr_width 10
`define weight_width  8
`define weight_addr_width  10
`define output_data_width  20
`define output_data_addr_width  10

module conv_top (clk, reset, start, finish);
input wire clk, reset, start;
output finish;

wire [`pixel_width-1:0] pixel;
wire [`weight_width-1:0] weight;
wire [`pixel_addr_width-1:0] pixel_addr;
wire [`weight_addr_width-1:0] weight_addr;
wire [`output_data_width-1:0] output_data;
wire [`output_data_addr_width-1:0] output_addr;
wire finish, output_req,weight_req,pixel_req;

// instantation of conv
conv conv(.clk(clk), 
          .reset(reset), 
          .start(start), 
          .pixel(pixel), 
          .weight(weight), 
          .finish(finish), 
          .output_data(output_data), 
          .output_addr(output_addr),
          .output_req(output_req),
          .weight_addr(weight_addr),
          .weight_req(weight_req),
          .pixel_addr(weight_addr),
          .pixel_req(pixel_req));

// instantation of input sram
// input  wire                                         clk,
// input  wire                                         reset,
// input  wire                                         s_read_req_b,
// input  wire  [ ADDR_WIDTH           -1 : 0 ]        s_read_addr_b,
// output reg  [ DATA_WIDTH           -1 : 0 ]        s_read_data_b

memory_input sram_in(.clk(clk),
                    .reset(reset),
                    .s_read_req_b(pixel_req),
                    .s_read_addr_b(pixel_addr),
                    .s_read_data_b(pixel));


// instantation of weight sram
//   input  wire                                         clk,
//   input  wire                                         reset,
//   input  wire                                         s_read_req_b,
//   input  wire  [ ADDR_WIDTH           -1 : 0 ]        s_read_addr_b,
//   output reg  [ DATA_WIDTH           -1 : 0 ]        s_read_data_b

memory_weight sram_weight(.clk(clk),
                          .reset(reset),
                          .s_read_req_b(weight_req),
                          .s_read_addr_b(weight_addr),
                          .s_read_data_b(weight));

// instantation of output sram
//input  wire                                         clk,
//input  wire                                         reset,
//input  wire                                         s_write_req_b,
//input  wire  [ ADDR_WIDTH           -1 : 0 ]        s_write_addr_b,
//input wire  [ DATA_WIDTH           -1 : 0 ]        s_write_data_b
memory_output sramm_output(.clk(clk),
                          .reset(reset),
                          .s_write_req_b(output_req),
                          .s_write_addr_b(output_addr),
                          .s_write_data_b(output_data));


endmodule
