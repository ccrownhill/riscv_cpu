module DataMem #(
	parameter		MEMSIZE = 18'h20000
)(
	input logic		      clk_i,
	input logic	[31:0]	AddressPort_i,
	input logic	[31:0]	WriteData_i,
	input logic		      MemWrite_i,

	output logic [7:0]	ReadData_o
);

logic [7:0] ram_arr[MEMSIZE-1:0];

initial
	$readmemh("data.mem", ram_arr, 17'h10000);

// READ instruction
assign ReadData_o = ram_arr[AddressPort_i];

// WRITE instruction
always_ff @(posedge clk_i) begin
	if(MemWrite_i) begin
		ram_arr[AddressPort_i] <= WriteData_i[7:0];
	end
end

endmodule
