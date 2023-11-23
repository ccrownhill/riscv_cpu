module DataMem #(
	parameter		MEMSIZE = 17'h1FFFF
)(
	input logic		      clk_i,
	input logic	[31:0]	AddressPort_i,
	input logic	[31:0]	WriteData_i,
	input logic		      MemWrite_i,

	output logic [7:0]	ReadData_o
);

logic [7:0] rom_arr[MEMSIZE-1:0];

initial
	$readmemh("datarom.mem", rom_arr);

// READ instruction
assign ReadData_o = rom_arr[AddressPort_i];

// WRITE instruction
always_ff @(posedge clk_i) begin
	if(MemWrite_i) begin
		rom_arr[AddressPort_i] <= WriteData_i[7:0];
	end
end

endmodule
