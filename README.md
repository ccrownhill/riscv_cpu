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

## Corresponding Achievements

1. We refer to the book written by Harris & Harris, Control Unit as:

<img width="836" alt="Screen Shot 2023-11-30 at 10 48 00" src="https://github.com/ccrownhill/Team11/assets/109323873/182af720-c189-4339-a2b1-ba8f939fd0d7">

ALU section as:

<img width="630" alt="Screen Shot 2023-11-30 at 10 48 11" src="https://github.com/ccrownhill/Team11/assets/109323873/233053ef-cd99-4918-86dc-895bf0439bbd">

ImmSrc as:

<img width="882" alt="Screen Shot 2023-11-30 at 10 48 43" src="https://github.com/ccrownhill/Team11/assets/109323873/9a2a506a-a7d0-45ed-941c-00db4a568895">

finally, the whole design as

<img width="877" alt="Screen Shot 2023-11-30 at 10 47 06" src="https://github.com/ccrownhill/Team11/assets/109323873/7c040d0b-d810-4953-9943-1cc471ac524e">

2. We verified that we can implement the our single-cycle CPU as evidence shown under the folder `test`   
3. Assembly code as shown in `test/f1_light.s` as well as assembled hexadecimal code shown in `test/f1light.mem`. Futher details can also be found under `test` folder 
4. As shown in the video https://youtu.be/eAhKKpVeQog?si=jxR7XT2m2lLqG2_a
5. Further details refer to Stretch Goal 1: Pipelined RV32I Design section
6. Further details refer to Stretch Goal 2: RV32I with Memory Cache section

# Stretch Goal 1: Pipelined RV32I Design

## Testing and Report

*`F1_light` can be successfully run on Vbuddy with noticeable longer time interval, around 3.1 seconds and 130 cycles, from current light on to next light on. However, the time interval for non-pipelined version is around 1.5 seconds and 60 cycles. This sounds wired because verilator lock the clock speed to 2ps/cycle (in reality, the clock speed will be increased since only one stage is executed in one cycle instead of 5 stages). This phenomenon means that we do pipelined the instructions successfully.

*`Guassian` `Noisy` `Sine` `Triangle` can be plotted on Vbuddy with noticeable slower plotting speed compared to non-pipelined version, which means plotting instructions can be successfully run with pipelined hardware, reason as explained above. 

## Evidence

Here is a video comparison when `Noisy.mem` is run on a pipelined version and a non-pipelined one



https://github.com/ccrownhill/Team11/assets/109323873/36f99c2b-c3e1-4079-9823-c8a6841b5b61



https://github.com/ccrownhill/Team11/assets/109323873/37fe8da2-174c-4ef9-8724-69ba9ef2e71a


Here are image evidence related to other `.mem` files executed on pipelined version:
NOTE: testbench has been modified, the step length now is 7 which was 3 for non-pipelined version in order to narrow the plots (make pipelined plots looked the same as non-pipelined version).

`Triangle.mem` as shown:

![4091701276462_ pic](https://github.com/ccrownhill/Team11/assets/109323873/a19c1965-df81-442a-99d8-3e706e1a94a3)

`Gaussian.mem` as shown:

![4081701276460_ pic](https://github.com/ccrownhill/Team11/assets/109323873/5eb5bd29-1d37-44a6-bd3f-4f335a99a4e9)

`Sine.mem` as shown:

![4071701276458_ pic](https://github.com/ccrownhill/Team11/assets/109323873/b7c78869-c807-4f06-b8a9-90d72da8e7cc)

Obviously, non-pipelined hardware can work correctly since pipelined hardware does work correctly
