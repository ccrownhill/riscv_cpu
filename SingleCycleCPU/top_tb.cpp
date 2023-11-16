#include "verilated.h"
#include "verilated_vcd_c.h"
#include "Vtop.h"
#include "vbuddy.cpp"     
#define MAX_SIM_CYC 1000000
#define ADDRESS_WIDTH 8
#define ROM_SZ 256

int main(int argc, char **argv, char **env) {
  int simcyc;     
  int tick;       

  Verilated::commandArgs(argc, argv);
  
  Vtop* top = new Vtop;

  Verilated::traceEverOn(true);
  VerilatedVcdC* tfp = new VerilatedVcdC;
  top->trace (tfp, 99);
  tfp->open ("top.vcd");
 
  if (vbdOpen()!=1) return(-1);
  vbdHeader("lab4");

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
    

    vbdPlot(int (top->a0), 0, 255);
    vbdCycle(simcyc);

    if ((Verilated::gotFinish()) || (vbdGetkey()=='q')) 
      exit(0);                
  }

  vbdClose();   
  tfp->close(); 
  exit(0);
}