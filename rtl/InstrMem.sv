module InstrMem #(
	parameter MEMSIZE = 12'hfff // in bytes
)(
	input logic [31:0] A,
	output logic [31:0] RD
);

logic [31:0] rom_arr[MEMSIZE-1:0];

initial
	$readmemh("instructions.mem", rom_arr);

assign RD = rom_arr[A[13:2]]; // 13:2 for byte adressing reasons and to avoid verilator error

endmodule
