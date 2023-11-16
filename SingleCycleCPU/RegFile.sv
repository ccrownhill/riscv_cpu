module RegFile #(
    parameter ADDRESS_WIDTH = 5,
              DATA_WIDTH = 32       // Depth of the register file, 2^ADDRESS_WIDTH
)(
    input logic                        clk,
    input logic  [ADDRESS_WIDTH-1:0]   AD1,
    input logic  [ADDRESS_WIDTH-1:0]   AD2,
    input logic  [ADDRESS_WIDTH-1:0]   AD3,
    input logic                        WE3,
    input logic  [DATA_WIDTH-1:0]      WD3,
    output logic [DATA_WIDTH-1:0]      RD1,
    output logic [DATA_WIDTH-1:0]      RD2,
    output logic  [DATA_WIDTH-1:0]                  a0
);

logic [DATA_WIDTH-1:0] reg_file [DATA_WIDTH-1:0];

// Read operations (asynchronous)
assign RD1 = reg_file[AD1];     // Read data from port 1
assign RD2 = reg_file[AD2];     // Read data from port 2
assign a0 = reg_file[10];
// Write operation (synchronous)
always_ff @(posedge clk) begin
    if (WE3) begin
        reg_file[AD3] <= WD3;   // Write data to port 3
    end
end

endmodule
