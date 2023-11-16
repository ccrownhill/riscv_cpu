// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vtop.h for the primary calling header

#include "verilated.h"

#include "Vtop__Syms.h"
#include "Vtop___024root.h"

void Vtop___024root___eval_act(Vtop___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___eval_act\n"); );
}

VL_INLINE_OPT void Vtop___024root___nba_sequent__TOP__0(Vtop___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___nba_sequent__TOP__0\n"); );
    // Init
    CData/*4:0*/ __Vdlyvdim0__top__DOT__DataPath__DOT__RegFile__DOT__reg_file__v0;
    __Vdlyvdim0__top__DOT__DataPath__DOT__RegFile__DOT__reg_file__v0 = 0;
    IData/*31:0*/ __Vdlyvval__top__DOT__DataPath__DOT__RegFile__DOT__reg_file__v0;
    __Vdlyvval__top__DOT__DataPath__DOT__RegFile__DOT__reg_file__v0 = 0;
    CData/*0:0*/ __Vdlyvset__top__DOT__DataPath__DOT__RegFile__DOT__reg_file__v0;
    __Vdlyvset__top__DOT__DataPath__DOT__RegFile__DOT__reg_file__v0 = 0;
    // Body
    __Vdlyvset__top__DOT__DataPath__DOT__RegFile__DOT__reg_file__v0 = 0U;
    if (vlSelf->top__DOT__RegWrite) {
        __Vdlyvval__top__DOT__DataPath__DOT__RegFile__DOT__reg_file__v0 
            = vlSelf->top__DOT__DataPath__DOT__ALUout;
        __Vdlyvset__top__DOT__DataPath__DOT__RegFile__DOT__reg_file__v0 = 1U;
        __Vdlyvdim0__top__DOT__DataPath__DOT__RegFile__DOT__reg_file__v0 
            = (0x1fU & (vlSelf->top__DOT__Instr >> 7U));
    }
    if (__Vdlyvset__top__DOT__DataPath__DOT__RegFile__DOT__reg_file__v0) {
        vlSelf->top__DOT__DataPath__DOT__RegFile__DOT__reg_file[__Vdlyvdim0__top__DOT__DataPath__DOT__RegFile__DOT__reg_file__v0] 
            = __Vdlyvval__top__DOT__DataPath__DOT__RegFile__DOT__reg_file__v0;
    }
    vlSelf->a0 = vlSelf->top__DOT__DataPath__DOT__RegFile__DOT__reg_file
        [0xaU];
}

VL_INLINE_OPT void Vtop___024root___nba_sequent__TOP__1(Vtop___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___nba_sequent__TOP__1\n"); );
    // Body
    vlSelf->top__DOT__PC = ((IData)(vlSelf->rst) ? 0U
                             : vlSelf->top__DOT__PCReg__DOT__next_PC);
    vlSelf->top__DOT__Instr = ((0x63U >= (0x7fU & vlSelf->top__DOT__PC))
                                ? vlSelf->top__DOT__InstrMem__DOT__rom_arr
                               [(0x7fU & vlSelf->top__DOT__PC)]
                                : 0U);
    vlSelf->top__DOT__RegWrite = ((0U == (0x60U & vlSelf->top__DOT__Instr)) 
                                  | (0x33U == (0x7fU 
                                               & vlSelf->top__DOT__Instr)));
    vlSelf->top__DOT__ALUctrl = ((0U != (0x60U & vlSelf->top__DOT__Instr)) 
                                 & ((0x33U != (0x7fU 
                                               & vlSelf->top__DOT__Instr)) 
                                    & (0x63U == (0x7fU 
                                                 & vlSelf->top__DOT__Instr))));
    vlSelf->top__DOT__ALUsrc = ((0U == (0x60U & vlSelf->top__DOT__Instr)) 
                                | ((0x33U != (0x7fU 
                                              & vlSelf->top__DOT__Instr)) 
                                   & (0x63U == (0x7fU 
                                                & vlSelf->top__DOT__Instr))));
    vlSelf->top__DOT__ImmSrc = ((0U != (0x60U & vlSelf->top__DOT__Instr)) 
                                & ((0x33U != (0x7fU 
                                              & vlSelf->top__DOT__Instr)) 
                                   & (0x63U == (0x7fU 
                                                & vlSelf->top__DOT__Instr))));
    vlSelf->top__DOT__ImmOp = ((IData)(vlSelf->top__DOT__ImmSrc)
                                ? (((- (IData)((vlSelf->top__DOT__Instr 
                                                >> 0x1fU))) 
                                    << 0xcU) | ((0x800U 
                                                 & (vlSelf->top__DOT__Instr 
                                                    << 4U)) 
                                                | ((0x7e0U 
                                                    & (vlSelf->top__DOT__Instr 
                                                       >> 0x14U)) 
                                                   | (0x1eU 
                                                      & (vlSelf->top__DOT__Instr 
                                                         >> 7U)))))
                                : (((- (IData)((vlSelf->top__DOT__Instr 
                                                >> 0x1fU))) 
                                    << 0xcU) | (vlSelf->top__DOT__Instr 
                                                >> 0x14U)));
}

VL_INLINE_OPT void Vtop___024root___nba_comb__TOP__0(Vtop___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___nba_comb__TOP__0\n"); );
    // Body
    vlSelf->top__DOT__DataPath__DOT__ALUop1 = vlSelf->top__DOT__DataPath__DOT__RegFile__DOT__reg_file
        [(0x1fU & (vlSelf->top__DOT__Instr >> 0xfU))];
    vlSelf->top__DOT__DataPath__DOT__ALUop2 = ((IData)(vlSelf->top__DOT__ALUsrc)
                                                ? vlSelf->top__DOT__ImmOp
                                                : vlSelf->top__DOT__DataPath__DOT__RegFile__DOT__reg_file
                                               [(0x1fU 
                                                 & (vlSelf->top__DOT__Instr 
                                                    >> 0x14U))]);
    if (vlSelf->top__DOT__ALUctrl) {
        vlSelf->top__DOT__DataPath__DOT__ALUout = (vlSelf->top__DOT__DataPath__DOT__ALUop1 
                                                   - vlSelf->top__DOT__DataPath__DOT__ALUop2);
        vlSelf->top__DOT__EQ = (vlSelf->top__DOT__DataPath__DOT__ALUop1 
                                == vlSelf->top__DOT__DataPath__DOT__ALUop2);
    } else {
        vlSelf->top__DOT__DataPath__DOT__ALUout = (vlSelf->top__DOT__DataPath__DOT__ALUop1 
                                                   + vlSelf->top__DOT__DataPath__DOT__ALUop2);
        vlSelf->top__DOT__EQ = 0U;
    }
    vlSelf->top__DOT__PCsrc = ((0U != (0x60U & vlSelf->top__DOT__Instr)) 
                               & ((0x33U != (0x7fU 
                                             & vlSelf->top__DOT__Instr)) 
                                  & ((0x63U == (0x7fU 
                                                & vlSelf->top__DOT__Instr)) 
                                     & (IData)(vlSelf->top__DOT__EQ))));
    vlSelf->top__DOT__PCReg__DOT__next_PC = ((IData)(vlSelf->top__DOT__PCsrc)
                                              ? (vlSelf->top__DOT__ImmOp 
                                                 + vlSelf->top__DOT__PC)
                                              : ((IData)(4U) 
                                                 + vlSelf->top__DOT__PC));
}

void Vtop___024root___eval_nba(Vtop___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___eval_nba\n"); );
    // Body
    if ((2ULL & vlSelf->__VnbaTriggered.word(0U))) {
        Vtop___024root___nba_sequent__TOP__0(vlSelf);
        vlSelf->__Vm_traceActivity[1U] = 1U;
    }
    if ((1ULL & vlSelf->__VnbaTriggered.word(0U))) {
        Vtop___024root___nba_sequent__TOP__1(vlSelf);
        vlSelf->__Vm_traceActivity[2U] = 1U;
    }
    if ((3ULL & vlSelf->__VnbaTriggered.word(0U))) {
        Vtop___024root___nba_comb__TOP__0(vlSelf);
        vlSelf->__Vm_traceActivity[3U] = 1U;
    }
}

void Vtop___024root___eval_triggers__act(Vtop___024root* vlSelf);
#ifdef VL_DEBUG
VL_ATTR_COLD void Vtop___024root___dump_triggers__act(Vtop___024root* vlSelf);
#endif  // VL_DEBUG
#ifdef VL_DEBUG
VL_ATTR_COLD void Vtop___024root___dump_triggers__nba(Vtop___024root* vlSelf);
#endif  // VL_DEBUG

void Vtop___024root___eval(Vtop___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___eval\n"); );
    // Init
    VlTriggerVec<2> __VpreTriggered;
    IData/*31:0*/ __VnbaIterCount;
    CData/*0:0*/ __VnbaContinue;
    // Body
    __VnbaIterCount = 0U;
    __VnbaContinue = 1U;
    while (__VnbaContinue) {
        __VnbaContinue = 0U;
        vlSelf->__VnbaTriggered.clear();
        vlSelf->__VactIterCount = 0U;
        vlSelf->__VactContinue = 1U;
        while (vlSelf->__VactContinue) {
            vlSelf->__VactContinue = 0U;
            Vtop___024root___eval_triggers__act(vlSelf);
            if (vlSelf->__VactTriggered.any()) {
                vlSelf->__VactContinue = 1U;
                if (VL_UNLIKELY((0x64U < vlSelf->__VactIterCount))) {
#ifdef VL_DEBUG
                    Vtop___024root___dump_triggers__act(vlSelf);
#endif
                    VL_FATAL_MT("top.sv", 1, "", "Active region did not converge.");
                }
                vlSelf->__VactIterCount = ((IData)(1U) 
                                           + vlSelf->__VactIterCount);
                __VpreTriggered.andNot(vlSelf->__VactTriggered, vlSelf->__VnbaTriggered);
                vlSelf->__VnbaTriggered.thisOr(vlSelf->__VactTriggered);
                Vtop___024root___eval_act(vlSelf);
            }
        }
        if (vlSelf->__VnbaTriggered.any()) {
            __VnbaContinue = 1U;
            if (VL_UNLIKELY((0x64U < __VnbaIterCount))) {
#ifdef VL_DEBUG
                Vtop___024root___dump_triggers__nba(vlSelf);
#endif
                VL_FATAL_MT("top.sv", 1, "", "NBA region did not converge.");
            }
            __VnbaIterCount = ((IData)(1U) + __VnbaIterCount);
            Vtop___024root___eval_nba(vlSelf);
        }
    }
}

#ifdef VL_DEBUG
void Vtop___024root___eval_debug_assertions(Vtop___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___eval_debug_assertions\n"); );
    // Body
    if (VL_UNLIKELY((vlSelf->clk & 0xfeU))) {
        Verilated::overWidthError("clk");}
    if (VL_UNLIKELY((vlSelf->rst & 0xfeU))) {
        Verilated::overWidthError("rst");}
}
#endif  // VL_DEBUG
