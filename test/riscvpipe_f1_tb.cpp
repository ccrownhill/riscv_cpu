#include <iostream>
#include "verilated.h"
#include "verilated_vcd_c.h"
#include "Vriscvpipe.h"
#include "vbuddy.cpp"     
#define MAX_SIM_CYC 1000000
#define ADDRESS_WIDTH 8
#define ROM_SZ 256

int main(int argc, char **argv, char **env) {
	int simcyc;     
	int tick;       

	Verilated::commandArgs(argc, argv);
	
	Vriscvpipe* top = new Vriscvpipe;

	Verilated::traceEverOn(true);
	VerilatedVcdC* tfp = new VerilatedVcdC;
	top->trace (tfp, 99);
	tfp->open ("riscvpipe.vcd");
 
	if (vbdOpen()!=1) return(-1);
	vbdHeader("Caching F1");
	vbdSetMode(1);

	// initialize simulation inputs
	top->clk = 1;
	top->rst = 0;

	// run simulation for MAX_SIM_CYC clock cycles
	for (simcyc=0; simcyc<MAX_SIM_CYC; simcyc++) {
		// dump variables into VCD file and toggle clock
		for (tick=0; tick<2; tick++) {
			tfp->dump (2*simcyc+tick);
			top->clk = !top->clk;
			top->eval ();
		}
		
		top->rst = vbdFlag();

		vbdBar(top->a0 & 0xff);
		vbdCycle(simcyc);

		if ((Verilated::gotFinish()) || (vbdGetkey()=='q')) 
			exit(0);                
// 		if ((Verilated::gotFinish())) 
// 			exit(0);                
	}

	vbdClose();   
	tfp->close(); 
	exit(0);
}
