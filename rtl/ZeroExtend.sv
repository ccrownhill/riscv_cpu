module ZeroExtend (
  input logic [7:0]   in_i,

  output logic [31:0] out_i
);

assign out_i = {{24{1'b0}}, in_i};

endmodule
