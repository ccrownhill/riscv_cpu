module RegFile(
    parameter ADDRESS_WIDTH = 5,
              DATA_WIDTH = 32
              DEPTH = 1 << ADDRESS_WIDTH;       // Depth of the register file, 2^ADDRESS_WIDTH
)(
    logic input                        clk,
    logic input  [ADDRESS_WIDTH-1:0]   AD1,
    logic input  [ADDRESS_WIDTH-1:0]   AD2,
    logic input  [ADDRESS_WIDTH-1:0]   AD3,
    logic input                        WE3,
    logic input  [DATA_WIDTH-1:0]      WD3,
    logic output [DATA_WIDTH-1:0]      RD1,
    logic output [DATA_WIDTH-1:0]      RD2,
    logic output                       a0
);

reg [DATA_WIDTH-1:0] reg_file [0:DEPTH-1];

// Read operations (asynchronous)
assign RD1 = reg_file[AD1];     // Read data from port 1
assign RD2 = reg_file[AD2];     // Read data from port 2

// Write operation (synchronous)
always @(posedge clk) begin
    if (WE3) begin
        reg_file[AD3] <= WD3;   // Write data to port 3
    end
end

endmodule

