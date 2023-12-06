#include <iostream>
#include "verilated.h"
#include "verilated_vcd_c.h"
#include "Vtop.h"
#define MAX_SIM_CYC 1000000

int main(int argc, char **argv, char **env) {
	int simcyc;     
	int tick;       

	Verilated::commandArgs(argc, argv);
	
	Vtop* top = new Vtop;

	Verilated::traceEverOn(true);
	VerilatedVcdC* tfp = new VerilatedVcdC;
	top->trace (tfp, 99);
	tfp->open ("top.vcd");
 
	// initialize simulation inputs
	top->clk = 1;

	// run simulation for MAX_SIM_CYC clock cycles
	for (simcyc=0; simcyc<MAX_SIM_CYC; simcyc++) {
		// dump variables into VCD file and toggle clock
	
    // test read
    if (simcyc == 5 || ((simcyc > 5 && simcyc < 11) && !top->MemReady_o)) {
      top->AddressPort_i = 0x10000;
      top->MemWrite_i = 0;
      top->MemRead_i = 1;
      top->funct3_i = 0b0;
    }
    else if (simcyc == 11 || ((simcyc > 11 && simcyc < 17) && !top->MemReady_o)) {
      top->AddressPort_i = 0x10001;
      top->MemWrite_i = 0;
      top->MemRead_i = 1;
      top->funct3_i = 0b1;
    }
    else if (simcyc == 17 || ((simcyc > 17 && simcyc < 23) && !top->MemReady_o)) {
      top->AddressPort_i = 0x10010;
      top->MemWrite_i = 0;
      top->MemRead_i = 1;
      top->funct3_i = 0b10;
    }

    // test write
    else if (simcyc == 25) {
      top->AddressPort_i = 0x10100;
      top->MemWrite_i = 1;
      top->WriteData_i = 0x10;
      top->MemRead_i = 0;
      top->funct3_i = 0b0; // sb
    }

    // test cached read
    else if (simcyc == 27) {
      top->AddressPort_i = 0x10100;
      top->MemWrite_i = 0;
      top->WriteData_i = 0x10;
      top->MemRead_i = 1;
      top->funct3_i = 0b10;
    }

    // test write back
    else if (simcyc == 35) {
      top->AddressPort_i = 0x10000;
      top->MemWrite_i = 1;
      top->WriteData_i = 0x20;
      top->MemRead_i = 0;
      top->funct3_i = 0b10;
    }

    else if (simcyc == 45 || ((simcyc > 45 && simcyc < 55) && !top->MemReady_o)) {
      top->AddressPort_i = 0x10004;
      top->MemWrite_i = 1;
      top->WriteData_i = 0x30;
      top->MemRead_i = 0;
      top->funct3_i = 0b10;
    }
    else if (simcyc == 60) {
      top->AddressPort_i = 0x10004;
      top->MemWrite_i = 0;
      top->WriteData_i = 0x30;
      top->MemRead_i = 1;
      top->funct3_i = 0b10;
    }

    else {
	    top->MemRead_i = 0;
	    top->MemWrite_i = 0;
    }

    for (tick=0; tick<2; tick++) {
			top->eval ();
			tfp->dump (2*simcyc+tick);
			top->clk = !top->clk;
		}

		if ((Verilated::gotFinish())) {
			tfp->close();
			exit(0);                
		}

	}
	tfp->close(); 
	exit(0);
}
