

module memory_output
#(
    parameter integer  DATA_WIDTH                   = 20,
    parameter integer  SIZE_IN_BITS                 = 1<<10,
    parameter integer  ADDR_WIDTH                   = 10
)
(

    input  wire                                         clk,
    input  wire                                         reset,

    input  wire                                         s_write_req_b,
    input  wire  [ ADDR_WIDTH           -1 : 0 ]        s_write_addr_b,
    input wire  [ DATA_WIDTH           -1 : 0 ]        s_write_data_b
);
//=============================================================

//=============================================================
  reg  [ DATA_WIDTH -1 : 0 ] mem [ 0 : SIZE_IN_BITS ];



  always @(posedge clk)
  begin:RAM_WRITE_PORT
    if (s_write_req_b) begin
        mem[s_write_addr_b] <= s_write_data_b;
    end
  end



integer  Write_Out_File;

always @(posedge clk) begin
if (s_write_req_b) begin
  Write_Out_File =$fopen("Write_Out_File .txt");
  $fdisplay(Write_Out_File,"%h",s_write_data_b);
end
end

endmodule