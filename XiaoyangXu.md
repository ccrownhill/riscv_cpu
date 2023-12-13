# IAC Coursework Autumn 2023

## Personal Statement of Contribution

Xiaoyang Xu(X454XU)

## Overview

* `Mux8`
* `Mux16`
* `MainDecoder`
* Testing for Pipelined CPU

## Mux8

<img width="308" alt="Screen Shot 2023-12-13 at 11 46 52" src="https://github.com/ccrownhill/Team11/assets/109323873/1a62d94a-fb51-4b7a-b31a-2bf5ef0bc080">

As Shown in the image, We have 9 inputs which 8 of them are input value and 1 selection input.

<img width="330" alt="Screen Shot 2023-12-13 at 11 48 16" src="https://github.com/ccrownhill/Team11/assets/109323873/553e04b3-2ec2-4351-957b-47011a097ec2">

Choosing the correct input as output according to the selection input.

## Mux16

With a very similar approach as Mux8, but this time we have 16 input value and 1 selection.

## MainDecoder

I designed the MainDecoder according to the structure as shown in the image below, the value of ouput of this module is assigned according to Table 7.6 in the image. However, due to the number of the types of the instruction needed is 5, we have to add an aditional value to ImmSrc which is 3-bit.

<img width="493" alt="Screen Shot 2023-12-13 at 11 55 31" src="https://github.com/ccrownhill/Team11/assets/109323873/46d11ed9-3b14-455d-a39b-508ca032e2a4">

The main part of the code is the secion in the image below

<img width="875" alt="Screen Shot 2023-12-13 at 11 56 27" src="https://github.com/ccrownhill/Team11/assets/109323873/d9924371-3647-4e88-819f-f7cb69e5ed32">

##Testing for Pipelined CPU
