module InstrMem #(
	parameter MEMSIZE = 100 // in words
) (
	input logic A[31:0],
	output logic RD[31:0]
);

logic [31:0] rom_arr[MEMSIZE-1:0];

initial
	$loadmemh("insrom.mem", rom_array);

assign RD = rom_arr[A];

endmodule
