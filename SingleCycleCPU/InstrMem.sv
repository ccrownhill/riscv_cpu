module InstrMem #(
	parameter MEMSIZE = 5000, // in bytes
		  DATA_WIDTH = 32
) (
	input logic [DATA_WIDTH-1:0] A,
	output logic [DATA_WIDTH-1:0] RD
);

logic [7:0] rom_arr[MEMSIZE-1:0];

initial
	$readmemh("insrom.mem", rom_arr);

assign RD = {rom_arr[A], rom_arr[A+1], rom_arr[A+2], rom_arr[A+3]};

endmodule
