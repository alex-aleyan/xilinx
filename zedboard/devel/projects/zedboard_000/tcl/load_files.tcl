# This script loads all the files required by the project


puts "Adding RTL files to the project"
# Insert the command to import the RTL files form $src_dir here 
###add_files [glob $src_dir/*]

# For VHDL users only: Insert the command to associate string_utilities_synth_pkg.vhd with utilities_lib
###set_property library utilities_lib [get_files string_utilities_synth_pkg.vhd]

puts "Importing XDC file to the project"
# Insert the command to import the XDC file form $xdc_dir here 
add_files -fileset  [get_filesets constrs_1] $xdc_dir/zedboard_master_XDC_RevC_D_v3.xdc

puts "Importing Char_fifo IP to the project"
# Insert the command to import the char_fifo IP  form $core_dir here 
###read_ip -files $core_dir/char_fifo.xci
###upgrade_ip [get_ips]
###generate_target -verbose all [get_files $core_dir/char_fifo.xci]

puts "Adding clk_core IP to the project"
###create_ip -name clk_wiz -vendor xilinx.com -library ip -module_name clk_core 

###set_property -dict [list CONFIG.Component_Name {clk_core} CONFIG.PRIM_SOURCE {Differential_clock_capable_pin} \
###                                                          CONFIG.PRIM_IN_FREQ {300.000} \
###                                                          CONFIG.CLKOUT2_USED {true} \
###                                                          CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {200.000} \
###                                                          CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {193.750}] [get_ips clk_core]