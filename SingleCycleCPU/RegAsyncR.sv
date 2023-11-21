module RegAsyncR #(
	parameter DATA_WIDTH = 32
)(
	input logic rst,
	input logic clk,
	input logic [DATA_WIDTH-1:0] d,
	output logic [DATA_WIDTH-1:0] q
);


always_ff @(posedge clk, posedge rst)
    if (rst)
        q <= 0;
    else
        q <= d;

endmodule
