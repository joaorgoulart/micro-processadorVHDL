#!/bin/bash

ghdl -a ula.vhd
ghdl -a control_unit.vhd
ghdl -a D_ff.vhd
ghdl -a mux.vhd
ghdl -a uProc.vhd
ghdl -a state_mach.vhd
ghdl -a rom.vhd
ghdl -a ram.vhd
ghdl -a reg16bits.vhd
ghdl -a PC.vhd
ghdl -a mux4x1.vhd
ghdl -a banco_8reg.vhd 
ghdl -a testbenches/uProc_tb.vhd

ghdl -r uProc_tb --wave=uProc_tb.ghw
gtkwave uProc_tb.ghw

