

puts "Build ZedBoard Processing System"
#update_compile_order -fileset sources_1
create_bd_design "design_1"
#update_compile_order -fileset sources_1
#startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0
#endgroup
#startgroup
apply_bd_automation -rule xilinx.com:bd_rule:processing_system7 -config {make_external "FIXED_IO, DDR" apply_board_preset "1" Master "Disable" Slave "Disable" }  [get_bd_cells processing_system7_0]
#endgroup
