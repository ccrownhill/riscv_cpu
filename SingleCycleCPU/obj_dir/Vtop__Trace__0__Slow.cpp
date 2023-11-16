// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals
#include "verilated_vcd_c.h"
#include "Vtop__Syms.h"


VL_ATTR_COLD void Vtop___024root__trace_init_sub__TOP__0(Vtop___024root* vlSelf, VerilatedVcd* tracep) {
    if (false && vlSelf) {}  // Prevent unused
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root__trace_init_sub__TOP__0\n"); );
    // Init
    const int c = vlSymsp->__Vm_baseCode;
    // Body
    tracep->declBit(c+50,"clk", false,-1);
    tracep->declBit(c+51,"rst", false,-1);
    tracep->declBus(c+52,"a0", false,-1, 31,0);
    tracep->pushNamePrefix("top ");
    tracep->declBit(c+50,"clk", false,-1);
    tracep->declBit(c+51,"rst", false,-1);
    tracep->declBus(c+52,"a0", false,-1, 31,0);
    tracep->declBus(c+33,"ImmOp", false,-1, 31,0);
    tracep->declBus(c+34,"PC", false,-1, 31,0);
    tracep->declBus(c+35,"Instr", false,-1, 31,0);
    tracep->declBit(c+45,"EQ", false,-1);
    tracep->declBit(c+36,"ImmSrc", false,-1);
    tracep->declBit(c+37,"RegWrite", false,-1);
    tracep->declBit(c+38,"ALUsrc", false,-1);
    tracep->declBit(c+39,"ALUctrl", false,-1);
    tracep->declBit(c+46,"PCsrc", false,-1);
    tracep->pushNamePrefix("ControlUnit ");
    tracep->declBit(c+45,"EQ", false,-1);
    tracep->declBus(c+35,"Instr", false,-1, 31,0);
    tracep->declBit(c+37,"RegWrite", false,-1);
    tracep->declBit(c+39,"ALUctrl", false,-1);
    tracep->declBit(c+38,"ALUsrc", false,-1);
    tracep->declBit(c+36,"ImmSrc", false,-1);
    tracep->declBit(c+46,"PCsrc", false,-1);
    tracep->popNamePrefix(1);
    tracep->pushNamePrefix("DataPath ");
    tracep->declBus(c+55,"A_WIDTH", false,-1, 31,0);
    tracep->declBus(c+56,"D_WIDTH", false,-1, 31,0);
    tracep->declBit(c+50,"clk", false,-1);
    tracep->declBus(c+40,"rs1", false,-1, 4,0);
    tracep->declBus(c+41,"rs2", false,-1, 4,0);
    tracep->declBus(c+42,"rd", false,-1, 4,0);
    tracep->declBit(c+37,"RegWrite", false,-1);
    tracep->declBit(c+38,"ALUsrc", false,-1);
    tracep->declBit(c+39,"ALUctrl", false,-1);
    tracep->declBus(c+33,"ImmOp", false,-1, 31,0);
    tracep->declBit(c+45,"EQ", false,-1);
    tracep->declBus(c+52,"a0", false,-1, 31,0);
    tracep->declBus(c+53,"regOp2", false,-1, 31,0);
    tracep->declBus(c+47,"ALUop1", false,-1, 31,0);
    tracep->declBus(c+48,"ALUop2", false,-1, 31,0);
    tracep->declBus(c+49,"ALUout", false,-1, 31,0);
    tracep->pushNamePrefix("ALU ");
    tracep->declBus(c+56,"DATA_WIDTH", false,-1, 31,0);
    tracep->declBus(c+47,"ALUop1", false,-1, 31,0);
    tracep->declBus(c+48,"ALUop2", false,-1, 31,0);
    tracep->declBit(c+39,"ALUctrl", false,-1);
    tracep->declBit(c+45,"EQ", false,-1);
    tracep->declBus(c+49,"ALUout", false,-1, 31,0);
    tracep->popNamePrefix(1);
    tracep->pushNamePrefix("RegFile ");
    tracep->declBus(c+55,"ADDRESS_WIDTH", false,-1, 31,0);
    tracep->declBus(c+56,"DATA_WIDTH", false,-1, 31,0);
    tracep->declBit(c+50,"clk", false,-1);
    tracep->declBus(c+40,"AD1", false,-1, 4,0);
    tracep->declBus(c+41,"AD2", false,-1, 4,0);
    tracep->declBus(c+42,"AD3", false,-1, 4,0);
    tracep->declBit(c+37,"WE3", false,-1);
    tracep->declBus(c+49,"WD3", false,-1, 31,0);
    tracep->declBus(c+47,"RD1", false,-1, 31,0);
    tracep->declBus(c+53,"RD2", false,-1, 31,0);
    tracep->declBus(c+52,"a0", false,-1, 31,0);
    for (int i = 0; i < 32; ++i) {
        tracep->declBus(c+1+i*1,"reg_file", true,(i+0), 31,0);
    }
    tracep->popNamePrefix(1);
    tracep->pushNamePrefix("regMux ");
    tracep->declBus(c+56,"DATA_WIDTH", false,-1, 31,0);
    tracep->declBus(c+53,"regOp2", false,-1, 31,0);
    tracep->declBus(c+33,"ImmOp", false,-1, 31,0);
    tracep->declBit(c+38,"ALUsrc", false,-1);
    tracep->declBus(c+48,"MuxOut", false,-1, 31,0);
    tracep->popNamePrefix(2);
    tracep->pushNamePrefix("InstrMem ");
    tracep->declBus(c+57,"MEMSIZE", false,-1, 31,0);
    tracep->declBus(c+34,"A", false,-1, 31,0);
    tracep->declBus(c+35,"RD", false,-1, 31,0);
    tracep->popNamePrefix(1);
    tracep->pushNamePrefix("PCReg ");
    tracep->declBit(c+46,"PCsrc", false,-1);
    tracep->declBit(c+50,"clk", false,-1);
    tracep->declBit(c+51,"rst", false,-1);
    tracep->declBus(c+33,"ImmOp", false,-1, 31,0);
    tracep->declBus(c+34,"PC", false,-1, 31,0);
    tracep->declBus(c+54,"next_PC", false,-1, 31,0);
    tracep->pushNamePrefix("MuxReg ");
    tracep->declBit(c+46,"PCsrc", false,-1);
    tracep->declBus(c+34,"PC", false,-1, 31,0);
    tracep->declBus(c+33,"ImmOp", false,-1, 31,0);
    tracep->declBus(c+54,"next_PC", false,-1, 31,0);
    tracep->declBus(c+43,"branch_PC", false,-1, 31,0);
    tracep->declBus(c+44,"inc_PC", false,-1, 31,0);
    tracep->popNamePrefix(2);
    tracep->pushNamePrefix("SignExtend ");
    tracep->declBit(c+36,"ImmSrc", false,-1);
    tracep->declBus(c+35,"Instr", false,-1, 31,0);
    tracep->declBus(c+33,"ImmOp", false,-1, 31,0);
    tracep->popNamePrefix(2);
}

VL_ATTR_COLD void Vtop___024root__trace_init_top(Vtop___024root* vlSelf, VerilatedVcd* tracep) {
    if (false && vlSelf) {}  // Prevent unused
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root__trace_init_top\n"); );
    // Body
    Vtop___024root__trace_init_sub__TOP__0(vlSelf, tracep);
}

VL_ATTR_COLD void Vtop___024root__trace_full_top_0(void* voidSelf, VerilatedVcd::Buffer* bufp);
void Vtop___024root__trace_chg_top_0(void* voidSelf, VerilatedVcd::Buffer* bufp);
void Vtop___024root__trace_cleanup(void* voidSelf, VerilatedVcd* /*unused*/);

VL_ATTR_COLD void Vtop___024root__trace_register(Vtop___024root* vlSelf, VerilatedVcd* tracep) {
    if (false && vlSelf) {}  // Prevent unused
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root__trace_register\n"); );
    // Body
    tracep->addFullCb(&Vtop___024root__trace_full_top_0, vlSelf);
    tracep->addChgCb(&Vtop___024root__trace_chg_top_0, vlSelf);
    tracep->addCleanupCb(&Vtop___024root__trace_cleanup, vlSelf);
}

VL_ATTR_COLD void Vtop___024root__trace_full_sub_0(Vtop___024root* vlSelf, VerilatedVcd::Buffer* bufp);

VL_ATTR_COLD void Vtop___024root__trace_full_top_0(void* voidSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root__trace_full_top_0\n"); );
    // Init
    Vtop___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vtop___024root*>(voidSelf);
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    // Body
    Vtop___024root__trace_full_sub_0((&vlSymsp->TOP), bufp);
}

VL_ATTR_COLD void Vtop___024root__trace_full_sub_0(Vtop___024root* vlSelf, VerilatedVcd::Buffer* bufp) {
    if (false && vlSelf) {}  // Prevent unused
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root__trace_full_sub_0\n"); );
    // Init
    uint32_t* const oldp VL_ATTR_UNUSED = bufp->oldp(vlSymsp->__Vm_baseCode);
    // Body
    bufp->fullIData(oldp+1,(vlSelf->top__DOT__DataPath__DOT__RegFile__DOT__reg_file[0]),32);
    bufp->fullIData(oldp+2,(vlSelf->top__DOT__DataPath__DOT__RegFile__DOT__reg_file[1]),32);
    bufp->fullIData(oldp+3,(vlSelf->top__DOT__DataPath__DOT__RegFile__DOT__reg_file[2]),32);
    bufp->fullIData(oldp+4,(vlSelf->top__DOT__DataPath__DOT__RegFile__DOT__reg_file[3]),32);
    bufp->fullIData(oldp+5,(vlSelf->top__DOT__DataPath__DOT__RegFile__DOT__reg_file[4]),32);
    bufp->fullIData(oldp+6,(vlSelf->top__DOT__DataPath__DOT__RegFile__DOT__reg_file[5]),32);
    bufp->fullIData(oldp+7,(vlSelf->top__DOT__DataPath__DOT__RegFile__DOT__reg_file[6]),32);
    bufp->fullIData(oldp+8,(vlSelf->top__DOT__DataPath__DOT__RegFile__DOT__reg_file[7]),32);
    bufp->fullIData(oldp+9,(vlSelf->top__DOT__DataPath__DOT__RegFile__DOT__reg_file[8]),32);
    bufp->fullIData(oldp+10,(vlSelf->top__DOT__DataPath__DOT__RegFile__DOT__reg_file[9]),32);
    bufp->fullIData(oldp+11,(vlSelf->top__DOT__DataPath__DOT__RegFile__DOT__reg_file[10]),32);
    bufp->fullIData(oldp+12,(vlSelf->top__DOT__DataPath__DOT__RegFile__DOT__reg_file[11]),32);
    bufp->fullIData(oldp+13,(vlSelf->top__DOT__DataPath__DOT__RegFile__DOT__reg_file[12]),32);
    bufp->fullIData(oldp+14,(vlSelf->top__DOT__DataPath__DOT__RegFile__DOT__reg_file[13]),32);
    bufp->fullIData(oldp+15,(vlSelf->top__DOT__DataPath__DOT__RegFile__DOT__reg_file[14]),32);
    bufp->fullIData(oldp+16,(vlSelf->top__DOT__DataPath__DOT__RegFile__DOT__reg_file[15]),32);
    bufp->fullIData(oldp+17,(vlSelf->top__DOT__DataPath__DOT__RegFile__DOT__reg_file[16]),32);
    bufp->fullIData(oldp+18,(vlSelf->top__DOT__DataPath__DOT__RegFile__DOT__reg_file[17]),32);
    bufp->fullIData(oldp+19,(vlSelf->top__DOT__DataPath__DOT__RegFile__DOT__reg_file[18]),32);
    bufp->fullIData(oldp+20,(vlSelf->top__DOT__DataPath__DOT__RegFile__DOT__reg_file[19]),32);
    bufp->fullIData(oldp+21,(vlSelf->top__DOT__DataPath__DOT__RegFile__DOT__reg_file[20]),32);
    bufp->fullIData(oldp+22,(vlSelf->top__DOT__DataPath__DOT__RegFile__DOT__reg_file[21]),32);
    bufp->fullIData(oldp+23,(vlSelf->top__DOT__DataPath__DOT__RegFile__DOT__reg_file[22]),32);
    bufp->fullIData(oldp+24,(vlSelf->top__DOT__DataPath__DOT__RegFile__DOT__reg_file[23]),32);
    bufp->fullIData(oldp+25,(vlSelf->top__DOT__DataPath__DOT__RegFile__DOT__reg_file[24]),32);
    bufp->fullIData(oldp+26,(vlSelf->top__DOT__DataPath__DOT__RegFile__DOT__reg_file[25]),32);
    bufp->fullIData(oldp+27,(vlSelf->top__DOT__DataPath__DOT__RegFile__DOT__reg_file[26]),32);
    bufp->fullIData(oldp+28,(vlSelf->top__DOT__DataPath__DOT__RegFile__DOT__reg_file[27]),32);
    bufp->fullIData(oldp+29,(vlSelf->top__DOT__DataPath__DOT__RegFile__DOT__reg_file[28]),32);
    bufp->fullIData(oldp+30,(vlSelf->top__DOT__DataPath__DOT__RegFile__DOT__reg_file[29]),32);
    bufp->fullIData(oldp+31,(vlSelf->top__DOT__DataPath__DOT__RegFile__DOT__reg_file[30]),32);
    bufp->fullIData(oldp+32,(vlSelf->top__DOT__DataPath__DOT__RegFile__DOT__reg_file[31]),32);
    bufp->fullIData(oldp+33,(vlSelf->top__DOT__ImmOp),32);
    bufp->fullIData(oldp+34,(vlSelf->top__DOT__PC),32);
    bufp->fullIData(oldp+35,(vlSelf->top__DOT__Instr),32);
    bufp->fullBit(oldp+36,(vlSelf->top__DOT__ImmSrc));
    bufp->fullBit(oldp+37,(vlSelf->top__DOT__RegWrite));
    bufp->fullBit(oldp+38,(vlSelf->top__DOT__ALUsrc));
    bufp->fullBit(oldp+39,(vlSelf->top__DOT__ALUctrl));
    bufp->fullCData(oldp+40,((0x1fU & (vlSelf->top__DOT__Instr 
                                       >> 0xfU))),5);
    bufp->fullCData(oldp+41,((0x1fU & (vlSelf->top__DOT__Instr 
                                       >> 0x14U))),5);
    bufp->fullCData(oldp+42,((0x1fU & (vlSelf->top__DOT__Instr 
                                       >> 7U))),5);
    bufp->fullIData(oldp+43,((vlSelf->top__DOT__ImmOp 
                              + vlSelf->top__DOT__PC)),32);
    bufp->fullIData(oldp+44,(((IData)(4U) + vlSelf->top__DOT__PC)),32);
    bufp->fullBit(oldp+45,(vlSelf->top__DOT__EQ));
    bufp->fullBit(oldp+46,(vlSelf->top__DOT__PCsrc));
    bufp->fullIData(oldp+47,(vlSelf->top__DOT__DataPath__DOT__ALUop1),32);
    bufp->fullIData(oldp+48,(vlSelf->top__DOT__DataPath__DOT__ALUop2),32);
    bufp->fullIData(oldp+49,(vlSelf->top__DOT__DataPath__DOT__ALUout),32);
    bufp->fullBit(oldp+50,(vlSelf->clk));
    bufp->fullBit(oldp+51,(vlSelf->rst));
    bufp->fullIData(oldp+52,(vlSelf->a0),32);
    bufp->fullIData(oldp+53,(vlSelf->top__DOT__DataPath__DOT__RegFile__DOT__reg_file
                             [(0x1fU & (vlSelf->top__DOT__Instr 
                                        >> 0x14U))]),32);
    bufp->fullIData(oldp+54,(((IData)(vlSelf->top__DOT__PCsrc)
                               ? (vlSelf->top__DOT__ImmOp 
                                  + vlSelf->top__DOT__PC)
                               : ((IData)(4U) + vlSelf->top__DOT__PC))),32);
    bufp->fullIData(oldp+55,(5U),32);
    bufp->fullIData(oldp+56,(0x20U),32);
    bufp->fullIData(oldp+57,(0x64U),32);
}
