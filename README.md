# Team 11 repo

## Lab 4 - Reduced-RISC-V

We successfully conquered the challenge and displayed a sine wave on the Vbuddy as shown below.

![WechatIMG404](https://github.com/ccrownhill/Team11/assets/109323873/705e8ab0-2214-4310-bf9a-81d820b735e8)


# Team Project Logbook

## Objectives

1. To learn RISC-V 32-bit integer instruction set architecture
2. To implememnt a single-cycle RV32I instruction set in a microarchitecture
3. To implemententing the F1 starting light algorithm in RV32I assembly language
4. To verify your RV32I design by executing the F1 light program
5. As stretched goal, to implement a simple pipelined version of the microarchitecutre with hazard detection and mitigation
6. As a further stretched goal, add data cache to the pipelined RV32I

# Stretch Goal 1: Pipelined RV32I Design

## Testing and Report

*`F1_light` can be successfully run on Vbuddy with noticeable longer time interval, around 3.1 seconds and 130 cycles, from current light on to next light on. However, the time interval for non-pipelined version is around 1.5 seconds and 60 cycles. This sounds wired because verilator lock the clock speed to 2ps/cycle (in reality, the clock speed will be increased since only one stage is executed in one cycle instead of 5 stages). This phenomenon means that we do pipelined the instructions successfully.

*`Guassian` `Noisy` `Sine` `Triangle` can be plotted on Vbuddy with noticeable slower plotting speed compared to non-pipelined version, which means plotting instructions can be successfully run with pipelined hardware, reason as explained above. 

## Evidence

Here is a video comparison when `Noisy.mem` is run on a pipelined version and a non-pipelined one



https://github.com/ccrownhill/Team11/assets/109323873/36f99c2b-c3e1-4079-9823-c8a6841b5b61



https://github.com/ccrownhill/Team11/assets/109323873/37fe8da2-174c-4ef9-8724-69ba9ef2e71a

