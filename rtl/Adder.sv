module Adder (
  input logic [31:0] x1_i,
  input logic [31:0] x2_i,

  output logic [31:0] y_o
);

assign y_o = x1_i + x2_i;

endmodule
