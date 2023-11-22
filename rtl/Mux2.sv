module Mux2 #(
    parameter DATA_WIDTH = 32
)(
    input logic sel,
    input logic [DATA_WIDTH-1:0] in0,
    input logic [DATA_WIDTH-1:0] in1,
    output logic [DATA_WIDTH-1:0] out
);

assign out = sel ? in1 : in0;

endmodule
