#!/bin/sh

#clean up
rm -rf obj_dir
rm -rf riscvsingle.vcd

# run Verilator to translate Verilog into C++, including C++ testbench
verilator -Wall --cc --trace riscvsingle.sv --exe riscvsingle_tb.cpp

# build C++ project via make automatically generated by Verilator
make -j -C obj_dir/ -f Vriscvsingle.mk Vriscvsingle

# run executable simulation file
obj_dir/Vriscvsingle
