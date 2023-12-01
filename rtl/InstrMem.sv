module InstrMem #(
	parameter MEMSIZE = 4096 // in bytes
)(
	input logic [31:0] A,
	output logic [31:0] RD
);

logic [31:0] rom_arr[MEMSIZE-1:0];

initial
	$readmemh("instructions.mem", rom_arr);

assign RD = rom_arr[A[13:2]]; // 13:12 required to avoid verilator warning

endmodule
