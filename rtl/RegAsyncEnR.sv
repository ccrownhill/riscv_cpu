module RegAsyncEnR #(
	parameter DATA_WIDTH = 32
)(
	input logic clk,
	input logic rst,
  input logic en,
	input logic [DATA_WIDTH-1:0] d,
	output logic [DATA_WIDTH-1:0] q
);


always_ff @(posedge clk, posedge rst)
    if (rst == 1'b1)
        q <= 0;
    else if (en == 1'b1)
        q <= d;

endmodule
