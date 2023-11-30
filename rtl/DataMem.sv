module DataMem #(
	parameter		MEMSIZE = 18'h20000
)(
	input logic		      clk_i,
	input logic	[31:0]	AddressPort_i,
	input logic	[31:0]	WriteData_i,
	input logic		      MemWrite_i,
	input logic [2:0]  funct3_i,
	output logic [31:0]	ReadData_o
);

logic [7:0] ram_arr[MEMSIZE-1:0];

initial
	$readmemh("data.mem", ram_arr, 17'h10000);

// READ instruction
always_comb
	case(funct3_i)
		3'b000:		ReadData_o = {{24{ram_arr[AddressPort_i][7]}}, ram_arr[AddressPort_i]}; //lb
		3'b001:		ReadData_o = {{16{ram_arr[AddressPort_i+1][7]}}, ram_arr[AddressPort_i+1], ram_arr[AddressPort_i]}; //lh
		3'b010:		ReadData_o = {ram_arr[AddressPort_i+3], ram_arr[AddressPort_i+2], ram_arr[AddressPort_i+1], ram_arr[AddressPort_i]}; //lw
		3'b100:		ReadData_o = {24'b0, ram_arr[AddressPort_i]};//lbu
		3'b101:		ReadData_o = {16'b0, ram_arr[AddressPort_i+1], ram_arr[AddressPort_i]};//lhu
    default: ReadData_o = 32'bx;
	endcase

// WRITE instruction
always_ff @(posedge clk_i) begin
	if(MemWrite_i) begin
		case(funct3_i)
			3'b000: ram_arr[AddressPort_i] <= WriteData_i[7:0]; //sb
			3'b001: {ram_arr[AddressPort_i+1], ram_arr[AddressPort_i]} <= {WriteData_i[15:8], WriteData_i[7:0]}; //sh
			3'b010: {ram_arr[AddressPort_i+3], ram_arr[AddressPort_i+2], ram_arr[AddressPort_i+1], ram_arr[AddressPort_i]} <= {WriteData_i[31:24], WriteData_i[23:16], WriteData_i[15:8], WriteData_i[7:0]}; //sw
      default: ram_arr[AddressPort_i] <= ram_arr[AddressPort_i];
		endcase
	end
end

endmodule
