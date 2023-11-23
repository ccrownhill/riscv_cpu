module InstrMem #(
	parameter MEMSIZE = 12'hfff // in bytes
)(
	input logic [31:0] A,
	output logic [31:0] RD
);

logic [31:0] rom_arr[MEMSIZE-1:0];

initial
	$readmemh("insrom.mem", rom_arr);

assign RD = rom_arr[A[31:2]];

endmodule
