# IAC Coursework Autumn 2023

## Personal Statement of Contribution

Xiaoyang Xu(X454XU)

## Overview

* `Mux8`
* `Mux16`
* `MainDecoder`
* Testing for Pipelined CPU

## Mux8

```
module Mux8 #(
  parameter DATA_WIDTH = 32
)(
    input logic [2:0]             sel_i,
    input logic [DATA_WIDTH-1:0]  in0_i,
    input logic [DATA_WIDTH-1:0]  in1_i,
    input logic [DATA_WIDTH-1:0]  in2_i,
    input logic [DATA_WIDTH-1:0]  in3_i,
    input logic [DATA_WIDTH-1:0]  in4_i,
    input logic [DATA_WIDTH-1:0]  in5_i,
    input logic [DATA_WIDTH-1:0]  in6_i,
    input logic [DATA_WIDTH-1:0]  in7_i,

    output logic [DATA_WIDTH-1:0] out_o
);
```

We have 9 inputs which 8 of them are input value and 1 selection input.

```
always_comb
  case (sel_i)
    4'b000: out_o = in0_i;
    4'b001: out_o = in1_i;
    4'b010: out_o = in2_i;
    4'b011: out_o = in3_i;
    4'b100: out_o = in4_i;
    4'b101: out_o = in5_i;
    4'b110: out_o = in6_i;
    4'b111: out_o = in7_i;
  endcase

endmodule
```

Choosing the correct input as output according to the selection input.

## Mux16

With a very similar approach as Mux8, but this time we have 16 input value and 1 selection.

## MainDecoder

I designed the MainDecoder according to the structure as shown in the image below, the value of ouput of this module is assigned according to Table 7.6 in the image. However, due to the number of the types of the instruction needed is 5, we have to add an aditional value to ImmSrc which is 3-bit.

<img width="493" alt="Screen Shot 2023-12-13 at 11 55 31" src="https://github.com/ccrownhill/Team11/assets/109323873/46d11ed9-3b14-455d-a39b-508ca032e2a4">

The main part of the code is the secion in the image below

```
assign {RegWrite_o, ImmSrc_o, ALUsrc_o, WriteSrc_o, ALUOp_o, MemRead_o, MemWrite_o, Branch_o, Jump_o, Ret_o} = controls;

always_comb
  case (op_i)
    7'b1101111: controls = 14'b1_011_x_10_xx_0_0_0_1_0; // jal
    7'b1100111: controls = 14'b1_000_1_10_10_0_0_0_0_1; // jalr
    7'b0010011: controls = 14'b1_000_1_00_11_0_0_0_0_0; // addi + slli + srli + andi
    7'b0110011: controls = 14'b1_xxx_0_00_10_0_0_0_0_0; // add + xor + and(r-type)
    7'b0100011: controls = 14'b0_001_1_xx_00_0_1_0_0_0; // sb
    7'b1100011: controls = 14'b0_010_0_xx_01_0_0_1_0_0; // bne
    7'b0110111: controls = 14'b1_100_x_11_xx_0_0_0_0_0; // lui u-type
    7'b0000011: controls = 14'b1_000_1_01_00_1_0_0_0_0; // lb+lh+lw+lbu+lhu (i-type)
    default: controls = 14'bx_xxx_x_xx_xx_x_x_x_x_x;
  endcase

endmodule 
```

## Testing for Pipelined CPU

Details can be found on [Stretch Goal 1: Pipelined RV32I Design](https://github.com/ccrownhill/Team11#stretch-goal-1-pipelined-rv32i-design) as it explains what we get and why do we think that it works correctly
