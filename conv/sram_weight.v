
module memory_weight
#(
    parameter integer  DATA_WIDTH                   = 8,
    parameter integer  SIZE_IN_BITS                 = 1<<4,
    parameter integer  ADDR_WIDTH                   = 10
)
(

    input  wire                                         clk,
    input  wire                                         reset,


    input  wire                                         s_read_req_b,
    input  wire  [ ADDR_WIDTH           -1 : 0 ]        s_read_addr_b,
    output reg  [ DATA_WIDTH           -1 : 0 ]        s_read_data_b
);
//=============================================================

//=============================================================
  reg  [ DATA_WIDTH -1 : 0 ] mem [ 0 : SIZE_IN_BITS ];


initial 

     begin

    $readmemb("./weight.txt", mem);

    end

  always @(posedge clk)
  begin: RAM_READ_PORT
    if (s_read_req_b) begin
        s_read_data_b <= mem[s_read_addr_b];
    end
  end
endmodule
