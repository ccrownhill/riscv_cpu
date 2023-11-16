module InstrMem #(
	parameter MEMSIZE = 100 // in words
) (
	input logic [31:0] A,
	output logic [31:0] RD
);

logic [31:0] rom_arr[MEMSIZE-1:0];

initial
	$loadmemh("insrom.mem", rom_array);

assign RD = rom_arr[A];

endmodule
