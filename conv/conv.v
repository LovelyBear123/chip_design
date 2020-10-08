// conv module, consists of fifo,conv_cal,fifo_write_control,addr_gen
// -----------------------------------------------------------------------------
// Author : ytcheng
// File   : conv.v
// Create : 2020-06-14 11:06:14
// Revise : 2020-06-14 11:06:14
// Editor : sublime text3, tab size (2)
// -----------------------------------------------------------------------------
// input: clk,reset,start,pixel,weight
// output:finish,output_data,output_addr,output_req, weight_addr,weight_req,pixel_addr,pixel_req
`define pixel_width  9
`define pixel_addr_width 10
`define weight_width  8
`define weight_addr_width  10
`define output_data_width  20
`define output_data_addr_width  10

`include "./pixel_addr_gen.v"
`include "./weight_addr_gen.v"
`include "./conv_fifo.v"
`include "./fifo_wr_control.v"
`include "./conv_calculation.v"

module conv(clk, 
            reset, 
            start, 
            pixel, 
            weight, 
            finish, 
            output_data, 
            output_addr,
            output_req,
            weight_addr,
            weight_req,
            pixel_addr,
            pixel_req);



//--- port definition ---
input clk, reset, start;
input wire [`weight_width-1:0] weight;
input wire [`pixel_width-1:0] pixel;
output wire [`pixel_addr_width-1:0] pixel_addr;
output wire [`weight_addr_width-1:0] weight_addr;
output wire [`output_data_width-1:0] output_data;
output wire [`output_data_addr_width-1:0] output_addr;
output finish, output_req,weight_req,pixel_req;

//pixel_addr_generation
pixel_addr_gen pixel_addr_gen (.clk(clk),
                               .reset(reset),
                               .start(start),
                               .pixel_addr(pixel_addr));

//weight_addr generation
weight_addr_gen weight_addr_gen(.clk(clk),
                                .reset(reset),
                                .start(start),
                                .weight_addr(weight_addr));

//pixel_in <----FIFO<----pixel
wire [`pixel_width-1:0] pixel_in;
wire [`weight_width-1:0] weight_in;
wire fifo_empty = empty_fifo_p;
wire fifo_read;
//conv result & output_addr calculatiom
conv_calculation conv_calculation(.clk(clk),
                                  .reset(reset),
                                  .start(start),
                                  .pixel(pixel_in),
                                  .weight(weight_in),
                                  .fifo_empty(fifo_empty),
                                  .finish(finish),
                                  .fifo_read(fifo_read),
                                  .output_data(output_data),
                                  .output_req(output_req),
                                  .output_addr(output_addr));

// request signal, output_req is generate in conv_calculation module
assign  pixel_req = start && !finish;
assign  weight_req =start && !finish;

//fifo mudule
//module conv_fifo(clk,reset,w_en, data_w, r_en, data_r, empty, full);
//fifo_p is for pixel storage 
wire full_p, empty_fifo_p;
conv_fifo #(.width(9),
            .depth(1024),
            .depth_bits(11))
            fifo_p(.clk(clk),
                   .reset(reset),
                   .w_en(w_en_p),
                   .data_w(pixel),
                   .r_en(fifo_read),
                   .data_r(pixel_in),
                   .empty(empty_fifo_p),
                   .full(full_p));

//fifo_w is for weight storage 
wire full_w, empty_fifo_w;
conv_fifo #(.width(8),
            .depth(1024),
            .depth_bits(10))
            fifo_w(.clk(clk),
                   .reset(reset),
                   .w_en(w_en_w),
                   .data_w(weight),
                   .r_en(fifo_read),
                   .data_r(weight_in),
                   .empty(empty_fifo_w),
                   .full(full_w));



//a fifo write controler to determine
//module fifo_wr_control(clk,data_req,reset, fifo_wr_en);
fifo_wr_control fifo_con_p(.clk(clk),
                          .data_req(pixel_req),
                          .reset(reset),
                          .fifo_wr_en(w_en_p));

fifo_wr_control fifo_con_w(.clk(clk),
                          .data_req(weight_req),
                          .reset(reset),
                          .fifo_wr_en(w_en_w));

endmodule