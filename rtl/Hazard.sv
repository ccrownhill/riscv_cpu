module Hazard(
//	input logic 	   clk_i,
	input logic [4:0]  Rs1E_i,
	input logic [4:0]  Rs2E_i,
	input logic [4:0]  RdM_i,
	input logic [4:0]  RdW_i,
//	input logic [31:0] ALUResultM_i,
//	input logic [31:0] RD1E,
//	input logic [31:0] RD2E,
//	input logic [31:0] ResultW,
	input logic 	   RegWriteM_i,
	input logic 	   RegWriteW_i,
	output logic [1:0] ForwardAE,
	output logic [1:0] ForwardBE
);



always_comb begin // for forwarding

	if (Rs1E_i == RdM_i && RegWriteM_i == 1'b1) begin // this can be forwarded
		ForwardAE = 2'b10;
	end
	if (Rs1E_i == RdW_i && RegWriteW_i == 1'b1) begin // this can be forwarded
		ForwardAE = 2'b01;
	end
	else begin
		ForwardAE = 2'b00;
	end
	if (Rs2E_i == RdM_i && RegWriteM_i == 1'b1) // this can be forwarded
		ForwardBE = 2'b10;
	else if (Rs2E_i == RdW_i && RegWriteW_i == 1'b1) // this can be forwarded
		ForwardBE = 2'b01;
	else 
	ForwardBE = 2'b00;
end

endmodule
