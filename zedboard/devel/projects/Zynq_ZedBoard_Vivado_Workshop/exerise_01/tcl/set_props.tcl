# This script overrides some process properties. Only those that need to be set
# differently from the defaults will be set here

puts "Setting Synthesis and Implementation properties"
puts "Setting Flatten Hierarchy property for synth_1 run"
# Insert a command to change flatten_hierarchy property to none
set_property steps.synth_design.args.flatten_hierarchy none [get_runs $synth_name]

puts "Enable power optimization for impl_1 run"
set_property steps.power_opt_design.is_enabled true [get_runs $impl_name]

puts "Setting ZedBoard Part: digilentinc.com:zedboard:part0:1.0"
set_property board_part digilentinc.com:zedboard:part0:1.0 [current_project]

