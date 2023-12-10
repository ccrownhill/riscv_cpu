#include <iostream>
#include "verilated.h"
#include "verilated_vcd_c.h"
#include "VMemory.h"
#define MAX_SIM_CYC 1000000

int main(int argc, char **argv, char **env) {
	int simcyc;     
	int tick;       

	Verilated::commandArgs(argc, argv);
	
	VMemory* Memory = new VMemory;

	Verilated::traceEverOn(true);
	VerilatedVcdC* tfp = new VerilatedVcdC;
	Memory->trace (tfp, 99);
	tfp->open ("Memory.vcd");
 
	// initialize simulation inputs
	Memory->clk = 1;


	// run simulation for MAX_SIM_CYC clock cycles
	for (simcyc=0; simcyc<MAX_SIM_CYC; simcyc++) {
		// dump variables into VCD file and toggle clock
	
    // test read
    if (simcyc == 5 || ((simcyc > 5 && simcyc < 11) && !Memory->Mready_o)) {
      Memory->Addr_i = 0x10000;
      Memory->Mwrite_i = 0;
      Memory->Mread_i = 1;
      Memory->funct3_i = 0b0;
    }
    else if (simcyc == 11 || (simcyc > 11 && simcyc < 17) && !Memory->Mready_o) {
      Memory->Addr_i = 0x10001;
      Memory->Mwrite_i = 0;
      Memory->Mread_i = 1;
      Memory->funct3_i = 0b0;
    }
    else if (simcyc == 17 || ((simcyc > 17 && simcyc < 23) && !Memory->Mready_o)) {
      Memory->Addr_i = 0x10010;
      Memory->Mwrite_i = 0;
      Memory->Mread_i = 1;
      Memory->funct3_i = 0b0;

    }

    // test write back
    else if (simcyc == 35 || ((simcyc > 35 && simcyc < 45) && !Memory->Mready_o)) {
      Memory->Addr_i = 0x10000;
      Memory->Mwrite_i = 1;
      Memory->WriteD_i = 0x20;
      Memory->Mread_i = 0;
      Memory->funct3_i = 0b0;
    }

    else if (simcyc == 45 || (simcyc > 45 && simcyc < 55) && !Memory->Mready_o) {
      Memory->Addr_i = 0x10004;
      Memory->Mwrite_i = 1;
      Memory->WriteD_i = 0x30;
      Memory->Mread_i = 0;
      Memory->funct3_i = 0b0;
    }
    else if (simcyc == 60) {
      Memory->Addr_i = 0x10004;
      Memory->Mwrite_i = 0;
      Memory->WriteD_i = 0x30;
      Memory->Mread_i = 1;
      Memory->funct3_i = 0b0;
    }

    else {
	    Memory->Mread_i = 0;
	    Memory->Mwrite_i = 0;
    }

    for (tick=0; tick<2; tick++) {
			Memory->eval ();
			tfp->dump (2*simcyc+tick);
			Memory->clk = !Memory->clk;
		}

		if ((Verilated::gotFinish())) {
			tfp->close();
			exit(0);                
		}

	}
	tfp->close(); 
	exit(0);
}
