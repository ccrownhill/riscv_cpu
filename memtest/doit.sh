#!/bin/sh

set -e

rm -rf obj_dir

verilator -Wall -Wno-SELRANGE -Wno-UNUSED -Wno-WIDTH -Wno-ALWCOMBORDER -Wno-UNOPTFLAT --cc --trace mem_pkg.sv Memory.sv --top-module Memory --exe Memory_tb.cpp

make -j -C obj_dir/ -f VMemory.mk VMemory

./obj_dir/VMemory

gtkwave Memory.vcd
