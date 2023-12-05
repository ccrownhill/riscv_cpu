module MemConv
  import mem_pkg::*;
(
  input logic [BLOCK_SIZE-1:0]  data_i,
  input logic [2:0]   funct3_i,
  input logic [OFFSET_BITS-1:0] Offset_i,

  output logic [31:0] ExtData_o
);

logic [31:0] maskedData;

always_comb begin
  maskedData = {data_i >> (Offset_i*8)}[31:0];
  case (funct3_i)
		3'b000:		ExtData_o = {{24{maskedData[7]}}, maskedData[7:0]}; //lb
		3'b001:		ExtData_o = {{16{maskedData[15]}}, maskedData[15:0]}; //lh
		3'b010:		ExtData_o = maskedData[31:0]; //lw
		3'b100:		ExtData_o = {24'b0, maskedData[7:0]};//lbu
		3'b101:		ExtData_o = {16'b0, maskedData[15:0]};//lhu
    default:  ExtData_o = 32'bx;
	endcase
end

endmodule
