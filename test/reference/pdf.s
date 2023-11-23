.text
.equ base_pdf, 0x100
.equ base_data, 0x10000
.equ max_count, 200
main:
    JAL     ra, init  # jump to init, ra and save position to ra
    JAL     ra, build
forever:
    JAL     ra, display
    J       forever

init:       # function to initialise PDF buffer memory 
    LI      a1, 0x100           # loop_count a1 = 256
_loop1:                         # repeat
    ADDI    a1, a1, -1          #     decrement a1
    SB      zero, base_pdf(a1)  #     mem[base_pdf+a1) = 0
    BNE     a1, zero, _loop1    # until a1 = 0
    RET

build:      # function to build prob dist func (pdf)
    LI      a1, base_data       # a1 = base address of data array
    LI      a2, 0               # a2 = offset into of data array 
    LI      a3, base_pdf        # a3 = base address of pdf array
    LI      a4, max_count       # a4 = maximum count to terminate
_loop2:                         # repeat
    ADD     a5, a1, a2          #     a5 = data base address + offset
    LBU     t0, 0(a5)           #     t0 = data value
    ADD     a6, t0, a3          #     a6 = index into pdf array
    LBU     t1, 0(a6)           #     t1 = current bin count
    ADDI    t1, t1, 1           #     increment bin count
    SB      t1, 0(a6)           #     update bin count
    ADDI    a2, a2, 1           #     point to next data in array
    BNE     t1, a4, _loop2      # until bin count reaches max
    RET

display:    # function send PDF array value to a0 for display
    LI      a1, 0               # a1 = offset into pdf array
    LI      a2, 255             # a2 = max index of pdf array
_loop3:                         # repeat
    LBU     a0, base_pdf(a1)    #   a0 = mem[base_pdf+a1)
    addi    a1, a1, 1           #   incr 
    BNE     a1, a2, _loop3      # until end of pdf array
    RET
