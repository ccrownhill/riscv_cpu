module Mux16 #(
  parameter DATA_WIDTH = 32
)(
    input logic [3:0]             sel_i,
    input logic [DATA_WIDTH-1:0]  in0_i,
    input logic [DATA_WIDTH-1:0]  in1_i,
    input logic [DATA_WIDTH-1:0]  in2_i,
    input logic [DATA_WIDTH-1:0]  in3_i,
    input logic [DATA_WIDTH-1:0]  in4_i,
    input logic [DATA_WIDTH-1:0]  in5_i,
    input logic [DATA_WIDTH-1:0]  in6_i,
    input logic [DATA_WIDTH-1:0]  in7_i,
    input logic [DATA_WIDTH-1:0]  in8_i,
    input logic [DATA_WIDTH-1:0]  in9_i,
    input logic [DATA_WIDTH-1:0]  in10_i,
    input logic [DATA_WIDTH-1:0]  in11_i,
    input logic [DATA_WIDTH-1:0]  in12_i,
    input logic [DATA_WIDTH-1:0]  in13_i,
    input logic [DATA_WIDTH-1:0]  in14_i,
    input logic [DATA_WIDTH-1:0]  in15_i,

    output logic [DATA_WIDTH-1:0] out_o
);

always_comb
  case (sel_i)
    4'b0000: out_o = in0_i;
    4'b0001: out_o = in1_i;
    4'b0010: out_o = in2_i;
    4'b0011: out_o = in3_i;
    4'b0100: out_o = in4_i;
    4'b0101: out_o = in5_i;
    4'b0110: out_o = in6_i;
    4'b0111: out_o = in7_i;
    4'b1000: out_o = in8_i;
    4'b1001: out_o = in9_i;
    4'b1010: out_o = in10_i;
    4'b1011: out_o = in11_i;
    4'b1100: out_o = in12_i;
    4'b1101: out_o = in13_i;
    4'b1110: out_o = in14_i;
    4'b1111: out_o = in15_i;
  endcase

endmodule