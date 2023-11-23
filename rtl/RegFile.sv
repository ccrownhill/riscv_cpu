module RegFile #(
    parameter ADDRESS_WIDTH = 5
)(
    input logic                        clk,
    input logic  [ADDRESS_WIDTH-1:0]   AD1,
    input logic  [ADDRESS_WIDTH-1:0]   AD2,
    input logic  [ADDRESS_WIDTH-1:0]   AD3,
    input logic                        WE3,
    input logic  [31:0]      WD3,
    output logic [31:0]      RD1,
    output logic [31:0]      RD2,
    output logic [31:0]	a0
);

logic [31:0] reg_file [2**ADDRESS_WIDTH-1:0];

// Write operation (synchronous)
always_ff @(posedge clk) begin
	// AD3 != 0 because writing zero register has to stay 0	
	if (WE3 && AD3 != {ADDRESS_WIDTH{1'b0}}) begin
		reg_file[AD3] <= WD3;   // Write data to port 3
	end
end

// Read operations (asynchronous)
assign RD1 = reg_file[AD1];     // Read data from port 1
assign RD2 = reg_file[AD2];     // Read data from port 2
assign a0 = reg_file[10];
endmodule
