module regMux(
    parameter DATA_WIDTH = 32
)(
    logic input  [DATA_WIDTH-1:0]   regOp2,
    logic input  [DATA_WIDTH-1:0]   ImmOp,
    logic input                     ALUsrc,
    logic output [DATA_WIDTH-1:0]   MuxOut
);

assign MuxOut = ALUsrc ? ImmOp : regOp2;
endmodule   
