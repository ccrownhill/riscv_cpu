module PCsrcDecode (
  input logic EQ_i,
  input logic Branch_i,
  input logic Jump_i,
  input logic Ret_i,

  output logic [1:0] PCsrc_o
);

always_comb begin
  if (((!EQ_i & Branch_i) | Jump_i) == 1'b1)
    PCsrc_o = 2'b01;
  else if (Ret_i == 1'b1)
    PCsrc_o = 2'b10;
  else
    PCsrc_o = 2'b00;
end

endmodule
