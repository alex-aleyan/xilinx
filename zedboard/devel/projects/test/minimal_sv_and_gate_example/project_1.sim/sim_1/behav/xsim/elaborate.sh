#!/bin/bash -f
# ****************************************************************************
# Vivado (TM) v2017.4 (64-bit)
#
# Filename    : elaborate.sh
# Simulator   : Xilinx Vivado Simulator
# Description : Script for elaborating the compiled design
#
# Generated by Vivado on Wed May 20 11:49:04 EDT 2020
# SW Build 2086221 on Fri Dec 15 20:54:30 MST 2017
#
# Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
#
# usage: elaborate.sh
#
# ****************************************************************************
ExecStep()
{
"$@"
RETVAL=$?
if [ $RETVAL -ne 0 ]
then
exit $RETVAL
fi
}
ExecStep xelab -wto f88c399aab0f4a36a49a17c273621074 --incr --debug typical --relax --mt 8 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip --snapshot my_and_gate_tb_behav xil_defaultlib.my_and_gate_tb xil_defaultlib.glbl -log elaborate.log
