module Hazard(
	input logic 	   clk_i
	input logic [4:0]  Rs1E_i
	input logic [4:0]  Rs2E_i
	input logic [4:0]  RdM_i
	input logic [4:0]  RdW_i
	input logic [31:0] ALUResultM_i
	input logic [31:0] RD1E
	input logic [31:0] RD2E
	input logic [31:0] ResultW
	input logic 	   RegWriteM_i
	input logic 	   RegWriteW_i
	output logic       ForwardAE
	output logic       ForwardBE
);



always_ff @(posedge clk_i)
	if (Rs1E_i == RdM_i)

	if (Rs1E_i == RdW_i)

	if (Rs2E_i == RdM_i)

	if (Rs2E_i == RdW_i)
	
endmodule