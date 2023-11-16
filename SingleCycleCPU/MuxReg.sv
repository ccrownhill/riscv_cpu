
/// This module generates the next_PC signal by either adding 4 to the previous value 
/// or by adding the immediate value to the PC and outputting this. 
module MuxReg(
            input logic PCsrc,
            input logic [31:0] PC,
            input logic [31:0] ImmOp,
            output logic [31:0] next_PC
            );
    logic branch_PC
    logic inc_PC

    assign branch_PC <=  PC + ImmOp;
    assign inc_PC <= PC + 4;
    
    assign next_PC = PCsrc ? branch_PC : inc_PC;
endmodule