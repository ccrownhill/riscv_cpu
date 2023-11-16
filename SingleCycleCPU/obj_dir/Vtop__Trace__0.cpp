// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals
#include "verilated_vcd_c.h"
#include "Vtop__Syms.h"


void Vtop___024root__trace_chg_sub_0(Vtop___024root* vlSelf, VerilatedVcd::Buffer* bufp);

void Vtop___024root__trace_chg_top_0(void* voidSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root__trace_chg_top_0\n"); );
    // Init
    Vtop___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vtop___024root*>(voidSelf);
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    if (VL_UNLIKELY(!vlSymsp->__Vm_activity)) return;
    // Body
    Vtop___024root__trace_chg_sub_0((&vlSymsp->TOP), bufp);
}

void Vtop___024root__trace_chg_sub_0(Vtop___024root* vlSelf, VerilatedVcd::Buffer* bufp) {
    if (false && vlSelf) {}  // Prevent unused
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root__trace_chg_sub_0\n"); );
    // Init
    uint32_t* const oldp VL_ATTR_UNUSED = bufp->oldp(vlSymsp->__Vm_baseCode + 1);
    // Body
    if (VL_UNLIKELY(vlSelf->__Vm_traceActivity[1U])) {
        bufp->chgIData(oldp+0,(vlSelf->top__DOT__DataPath__DOT__RegFile__DOT__reg_file[0]),32);
        bufp->chgIData(oldp+1,(vlSelf->top__DOT__DataPath__DOT__RegFile__DOT__reg_file[1]),32);
        bufp->chgIData(oldp+2,(vlSelf->top__DOT__DataPath__DOT__RegFile__DOT__reg_file[2]),32);
        bufp->chgIData(oldp+3,(vlSelf->top__DOT__DataPath__DOT__RegFile__DOT__reg_file[3]),32);
        bufp->chgIData(oldp+4,(vlSelf->top__DOT__DataPath__DOT__RegFile__DOT__reg_file[4]),32);
        bufp->chgIData(oldp+5,(vlSelf->top__DOT__DataPath__DOT__RegFile__DOT__reg_file[5]),32);
        bufp->chgIData(oldp+6,(vlSelf->top__DOT__DataPath__DOT__RegFile__DOT__reg_file[6]),32);
        bufp->chgIData(oldp+7,(vlSelf->top__DOT__DataPath__DOT__RegFile__DOT__reg_file[7]),32);
        bufp->chgIData(oldp+8,(vlSelf->top__DOT__DataPath__DOT__RegFile__DOT__reg_file[8]),32);
        bufp->chgIData(oldp+9,(vlSelf->top__DOT__DataPath__DOT__RegFile__DOT__reg_file[9]),32);
        bufp->chgIData(oldp+10,(vlSelf->top__DOT__DataPath__DOT__RegFile__DOT__reg_file[10]),32);
        bufp->chgIData(oldp+11,(vlSelf->top__DOT__DataPath__DOT__RegFile__DOT__reg_file[11]),32);
        bufp->chgIData(oldp+12,(vlSelf->top__DOT__DataPath__DOT__RegFile__DOT__reg_file[12]),32);
        bufp->chgIData(oldp+13,(vlSelf->top__DOT__DataPath__DOT__RegFile__DOT__reg_file[13]),32);
        bufp->chgIData(oldp+14,(vlSelf->top__DOT__DataPath__DOT__RegFile__DOT__reg_file[14]),32);
        bufp->chgIData(oldp+15,(vlSelf->top__DOT__DataPath__DOT__RegFile__DOT__reg_file[15]),32);
        bufp->chgIData(oldp+16,(vlSelf->top__DOT__DataPath__DOT__RegFile__DOT__reg_file[16]),32);
        bufp->chgIData(oldp+17,(vlSelf->top__DOT__DataPath__DOT__RegFile__DOT__reg_file[17]),32);
        bufp->chgIData(oldp+18,(vlSelf->top__DOT__DataPath__DOT__RegFile__DOT__reg_file[18]),32);
        bufp->chgIData(oldp+19,(vlSelf->top__DOT__DataPath__DOT__RegFile__DOT__reg_file[19]),32);
        bufp->chgIData(oldp+20,(vlSelf->top__DOT__DataPath__DOT__RegFile__DOT__reg_file[20]),32);
        bufp->chgIData(oldp+21,(vlSelf->top__DOT__DataPath__DOT__RegFile__DOT__reg_file[21]),32);
        bufp->chgIData(oldp+22,(vlSelf->top__DOT__DataPath__DOT__RegFile__DOT__reg_file[22]),32);
        bufp->chgIData(oldp+23,(vlSelf->top__DOT__DataPath__DOT__RegFile__DOT__reg_file[23]),32);
        bufp->chgIData(oldp+24,(vlSelf->top__DOT__DataPath__DOT__RegFile__DOT__reg_file[24]),32);
        bufp->chgIData(oldp+25,(vlSelf->top__DOT__DataPath__DOT__RegFile__DOT__reg_file[25]),32);
        bufp->chgIData(oldp+26,(vlSelf->top__DOT__DataPath__DOT__RegFile__DOT__reg_file[26]),32);
        bufp->chgIData(oldp+27,(vlSelf->top__DOT__DataPath__DOT__RegFile__DOT__reg_file[27]),32);
        bufp->chgIData(oldp+28,(vlSelf->top__DOT__DataPath__DOT__RegFile__DOT__reg_file[28]),32);
        bufp->chgIData(oldp+29,(vlSelf->top__DOT__DataPath__DOT__RegFile__DOT__reg_file[29]),32);
        bufp->chgIData(oldp+30,(vlSelf->top__DOT__DataPath__DOT__RegFile__DOT__reg_file[30]),32);
        bufp->chgIData(oldp+31,(vlSelf->top__DOT__DataPath__DOT__RegFile__DOT__reg_file[31]),32);
    }
    if (VL_UNLIKELY(vlSelf->__Vm_traceActivity[2U])) {
        bufp->chgIData(oldp+32,(vlSelf->top__DOT__ImmOp),32);
        bufp->chgIData(oldp+33,(vlSelf->top__DOT__PC),32);
        bufp->chgIData(oldp+34,(vlSelf->top__DOT__Instr),32);
        bufp->chgBit(oldp+35,(vlSelf->top__DOT__ImmSrc));
        bufp->chgBit(oldp+36,(vlSelf->top__DOT__RegWrite));
        bufp->chgBit(oldp+37,(vlSelf->top__DOT__ALUsrc));
        bufp->chgBit(oldp+38,(vlSelf->top__DOT__ALUctrl));
        bufp->chgCData(oldp+39,((0x1fU & (vlSelf->top__DOT__Instr 
                                          >> 0xfU))),5);
        bufp->chgCData(oldp+40,((0x1fU & (vlSelf->top__DOT__Instr 
                                          >> 0x14U))),5);
        bufp->chgCData(oldp+41,((0x1fU & (vlSelf->top__DOT__Instr 
                                          >> 7U))),5);
        bufp->chgIData(oldp+42,((vlSelf->top__DOT__ImmOp 
                                 + vlSelf->top__DOT__PC)),32);
        bufp->chgIData(oldp+43,(((IData)(4U) + vlSelf->top__DOT__PC)),32);
    }
    if (VL_UNLIKELY(vlSelf->__Vm_traceActivity[3U])) {
        bufp->chgBit(oldp+44,(vlSelf->top__DOT__EQ));
        bufp->chgBit(oldp+45,(vlSelf->top__DOT__PCsrc));
        bufp->chgIData(oldp+46,(vlSelf->top__DOT__DataPath__DOT__ALUop1),32);
        bufp->chgIData(oldp+47,(vlSelf->top__DOT__DataPath__DOT__ALUop2),32);
        bufp->chgIData(oldp+48,(vlSelf->top__DOT__DataPath__DOT__ALUout),32);
    }
    bufp->chgBit(oldp+49,(vlSelf->clk));
    bufp->chgBit(oldp+50,(vlSelf->rst));
    bufp->chgIData(oldp+51,(vlSelf->a0),32);
    bufp->chgIData(oldp+52,(vlSelf->top__DOT__DataPath__DOT__RegFile__DOT__reg_file
                            [(0x1fU & (vlSelf->top__DOT__Instr 
                                       >> 0x14U))]),32);
    bufp->chgIData(oldp+53,(((IData)(vlSelf->top__DOT__PCsrc)
                              ? (vlSelf->top__DOT__ImmOp 
                                 + vlSelf->top__DOT__PC)
                              : ((IData)(4U) + vlSelf->top__DOT__PC))),32);
}

void Vtop___024root__trace_cleanup(void* voidSelf, VerilatedVcd* /*unused*/) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root__trace_cleanup\n"); );
    // Init
    Vtop___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vtop___024root*>(voidSelf);
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    // Body
    vlSymsp->__Vm_activity = false;
    vlSymsp->TOP.__Vm_traceActivity[0U] = 0U;
    vlSymsp->TOP.__Vm_traceActivity[1U] = 0U;
    vlSymsp->TOP.__Vm_traceActivity[2U] = 0U;
    vlSymsp->TOP.__Vm_traceActivity[3U] = 0U;
}
