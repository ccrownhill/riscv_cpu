module Cache(
input logic 	Valid_i,
input logic 	Wen_i,
input logic 	funct3_i [2:0],
input logic 	Addr_i [31:0], // this will form the various parts of the address such as tag and byte offset.
input logic 	WordData_i[31:0],
input logic 	HalfData_i [15:0],
input logic 	ByteData_i [7:0],
input logic 	clk,

output logic 	RData [127:0], // this is the block selected from the cache
output logic 	Cready_o
);


	
endmodule
