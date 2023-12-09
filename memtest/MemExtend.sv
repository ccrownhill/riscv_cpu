module MemExtend(
  input logic [31:0] WordData_i,
  input logic [15:0] HalfData_i,
  input logic [7:0] ByteData_i,
  input logic [2:0] funct3_i,
  output logic [31:0] ExtD_o
);

always_comb
	case(funct3_i)
		3'b000:		ExtD_o = {{24{ByteData_i[7]}}, ByteData_i}; //lb
		3'b001:		ExtD_o = {{16{HalfData_i[15]}}, HalfData_i}; //lh
		3'b010:		ExtD_o = WordData_i; //lw
		3'b100:		ExtD_o = {24'b0, ByteData_i};//lbu
		3'b101:		ExtD_o = {16'b0, HalfData_i};//lhu
    default: ExtD_o = 32'bx;
	endcase


endmodule
