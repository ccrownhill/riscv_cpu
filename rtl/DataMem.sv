Module DataMemory #(
	parameter		MEMSIZE = 17'h1FFFF
)(
	input logic		clk_i,
	input logic	[31:0]	AddressPort_i,
	input logic	[31:0]	WriteData_i,
	input logic		MemWrite_i,
	output logic	ReadData_o
)

logic [31:0] rom_arr[MEMSIZE-1:0];

initial
	$readmemh("datarom.mem", rom_arr);

// READ instruction
always_ff @(posedge clk) begin
	if(!MemWrite_i) begin
		assign ReadData_o <= rom_arr[AddressPort_i[31:2]];
	end
end

// WRITE instruction
always_ff @(posedge clk) begin
	if(MemWrite_i) begin
		rom_arr[AddressPort_i[31:2]] <= WriteData_i
	end
end

endmodule