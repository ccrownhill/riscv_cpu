#!/bin/sh

rm -rf obj_dir

verilator -Wall -Wno-WIDTH -Wno-ALWCOMBORDER -Wno-UNOPTFLAT --cc --trace mem_pkg.sv top.sv --top-module top --exe top_tb.cpp

make -j -C obj_dir/ -f Vtop.mk Vtop

./obj_dir/Vtop

gtkwave top.vcd
