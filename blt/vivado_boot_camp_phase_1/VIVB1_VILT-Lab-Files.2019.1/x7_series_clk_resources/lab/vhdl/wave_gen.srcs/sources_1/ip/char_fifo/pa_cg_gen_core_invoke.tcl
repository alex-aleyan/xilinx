# Tcl script generated by PlanAhead

set reloadAllCoreGenRepositories true

set tclUtilsPath "c:/Xilinx_P28xd.2.0/14.2/ISE_DS/PlanAhead/scripts/pa_cg_utils.tcl"

set repoPaths ""

set cgProjectPath "c:/training/des_7/labs/clocking/kintex7/vhdl/wave_gen.srcs/sources_1/ip/char_fifo/coregen.cgc"

set ipFile "c:/training/des_7/labs/clocking/kintex7/vhdl/wave_gen.srcs/sources_1/ip/char_fifo/char_fifo.xco"

set ipName "char_fifo"

set hdlType "VHDL"

set cgPartSpec "xc7k70t-2fbg484"

set chains "GENERATE_CURRENT_CHAIN"

set params ""

set bomFilePath "c:/training/des_7/labs/clocking/kintex7/vhdl/wave_gen.srcs/sources_1/ip/char_fifo/pa_cg_bom.xml"

global env
set env(XIL_CG_ENABLE_RODIN_SYNTHESIS) true

# generate the IP
set result [source "c:/Xilinx_P28xd.2.0/14.2/ISE_DS/PlanAhead/scripts/pa_cg_gen_core.tcl"]

exit $result
