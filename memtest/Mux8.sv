module Mux8 #(
  parameter DATA_WIDTH = 32
)(
    input logic [2:0]             sel_i,
    input logic [DATA_WIDTH-1:0]  in0_i,
    input logic [DATA_WIDTH-1:0]  in1_i,
    input logic [DATA_WIDTH-1:0]  in2_i,
    input logic [DATA_WIDTH-1:0]  in3_i,
    input logic [DATA_WIDTH-1:0]  in4_i,
    input logic [DATA_WIDTH-1:0]  in5_i,
    input logic [DATA_WIDTH-1:0]  in6_i,
    input logic [DATA_WIDTH-1:0]  in7_i,

    output logic [DATA_WIDTH-1:0] out_o
);

always_comb
  case (sel_i)
    3'b000: out_o = in0_i;
    3'b001: out_o = in1_i;
    3'b010: out_o = in2_i;
    3'b011: out_o = in3_i;
    3'b100: out_o = in4_i;
    3'b101: out_o = in5_i;
    3'b110: out_o = in6_i;
    3'b111: out_o = in7_i;
  endcase

endmodule
