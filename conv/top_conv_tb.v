// testbench for conv_top.v

`timescale 1ns/1ps


module top_conv_tb();

reg clk,reset, start;
wire finish;
//module conv_top (clk, reset, start, finish);
conv_top conv_top(.clk(clk),
				  .reset(reset),
				  .start(start),
				  .finish(finish));


//--- generate  100M clock  ---
initial begin
clk = 0;
end
always #5 clk = ~ clk;


//set other signal
initial begin
reset=1;
#5 reset = 0;
#10 reset = 1;
end

initial begin
start =0;
#23 start=1;
end

endmodule