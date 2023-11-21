module ram #(
	parameter SIZE = 1024
)(
	input logic [31:0] addr,
	output logic [31:0] dout
);

logic [31:0] ram_arr[SIZE];

initial
	$readmemh("sinerom.mem", ram_arr);

assign dout = ram_arr[addr[31:2]];

endmodule
