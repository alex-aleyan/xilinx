# FIXME:
#     change the code to store multiple directories as a list and not a var
#     change the code to check whether the list is empty and react to results of the check appropriately
#

set date_string [clock format [clock seconds] -format "%y%m%d_%H%M%S"]
set proj_dir    [file normalize build_$date_string]

puts "$proj_dir"

puts "Creating build directory $proj_dir"
file mkdir $proj_dir

set project_name "zedboard_ex03"
#set device       "xc7z020clg484-1"
set boardpart    "em.avnet.com:zed:part0:1.0"

#set top_file_dir  "$proj_dir/.."
#set top_file_name "zedboard_top.vhd"

set script_dir $proj_dir/../tcl

set block_design_name design_1

set constrs_name    "constrs_1"
set xdc_dir         "$proj_dir/../constraints"
set xdc_filename    "zedboard_master_XDC_RevC_D_v3.xdc"
set timing_dir      "$proj_dir/../constraints"
set timing_filename "timing.tcl"

set src_dir  "$proj_dir/${project_name}.srcs/sources_1/bd/$block_design_name/hdl"
set core_dir "$proj_dir/.."

set synth_name "synth_1"
set impl_name  "impl_1"

puts "Changing directory to $proj_dir"
cd $proj_dir
puts "\n\n\n"

source $script_dir/create_proj.tcl
puts "\n\n\n"

source $script_dir/set_props.tcl
puts "\n\n\n"

source $script_dir/create_zedboard_ps.tcl
puts "\n\n\n"

source $script_dir/load_files.tcl
puts "\n\n\n"

source $script_dir/synthesis.tcl
puts "\n\n\n"

source $script_dir/implement.tcl

start_gui

#exit
