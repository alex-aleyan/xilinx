puts "There are $argc arguments to this script"
puts "The name of this script is $argv0"
# setup all defaults here in case an argument is not passed
if {$argc > 0} {
    set i 0
    foreach arg $argv {
        puts "Argument $i is $arg"
        incr i
    }
}

puts "There should be at least 7 arguments at all times (0-6):"
puts "Argument 0 is [lindex $argv 0]"
puts "Argument 1 is [lindex $argv 1]"
puts "Argument 2 is [lindex $argv 2]"
puts "Argument 3 is [lindex $argv 3]"
puts "Argument 4 is [lindex $argv 4]"
puts "Argument 5 is [lindex $argv 5]"
puts "Argument 6 is [lindex $argv 6]"

#puts "You have these environment variables set:"
#foreach index [array names env] {
#    puts "$index: $env($index)"
#}

set serial [lindex $argv 3]

set_param xicom.use_bitstream_version_check false
open_hw
connect_hw_server -url localhost:3121
current_hw_target [get_hw_targets -regexp (?i).*/xilinx_tcf/.*/$serial.*]
set_property PARAM.FREQUENCY 15000000 [get_hw_targets -regexp (?i).*/xilinx_tcf/.*/$serial.*]
open_hw_target
current_hw_device [lindex [get_hw_devices] 0]
refresh_hw_device [lindex [get_hw_devices] 0]
#
# VCU128 XCVU27P E Silicon
# IDCODE: 14B79093
#
set IDCODE [get_property IDCODE_HEX [lindex [get_hw_device] 0]]
puts $IDCODE
if { $IDCODE == "14B79093"} {
   puts "IDCODE check PASSED"
} else {
   puts "IDCODE check FAILED" 
}
puts [lindex [split [version] "\n"] 0]
if {[lindex [split [version] "\n"] 0] == "Vivado v2019.1 (64-bit)" || [lindex [split [version] "\n"] 0] == "Vivado Lab Edition v2019.1 (64-bit)"} {
   puts "Vivado check PASSED"
} else {
   puts "Vivado check FAILED" 
}
puts [lindex [split [version] "\n"] 1]
if {[lindex [split [version] "\n"] 1] == "SW Build 2552052 on Fri May 24 14:49:42 MDT 2019"} {
   puts "SW Build check PASSED"
} else {
   puts "SW Build check FAILED" 
}
close_hw_target [current_hw_target [get_hw_targets -regexp (?i).*/xilinx_tcf/.*/$serial.*]]
disconnect_hw_server localhost:3121
close_hw
exit
