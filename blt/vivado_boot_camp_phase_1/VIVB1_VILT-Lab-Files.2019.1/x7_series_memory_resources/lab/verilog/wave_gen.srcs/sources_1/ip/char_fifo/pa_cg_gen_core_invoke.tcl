# Tcl script generated by PlanAhead

set reloadAllCoreGenRepositories true

set tclUtilsPath "c:/Xilinx_P28xd.2.0/14.2/ISE_DS/PlanAhead/scripts/pa_cg_utils.tcl"

set repoPaths ""

set cgProjectPath "c:/training/des_7/labs/memory_architecture/KC705/verilog/wave_gen.srcs/sources_1/ip/char_fifo/coregen.cgc"

set ipFile "c:/training/des_7/labs/memory_architecture/KC705/verilog/wave_gen.srcs/sources_1/ip/char_fifo/char_fifo.xco"

set ipName "char_fifo"

set hdlType "Verilog"

set cgPartSpec "xc7k325t-2ffg900"

set chains "GENERATE_CURRENT_CHAIN"

set params ""

set bomFilePath "c:/training/des_7/labs/memory_architecture/KC705/verilog/wave_gen.srcs/sources_1/ip/char_fifo/pa_cg_bom.xml"

global env
set env(XIL_CG_ENABLE_RODIN_SYNTHESIS) true

# generate the IP
set result [source "c:/Xilinx_P28xd.2.0/14.2/ISE_DS/PlanAhead/scripts/pa_cg_gen_core.tcl"]

exit $result
