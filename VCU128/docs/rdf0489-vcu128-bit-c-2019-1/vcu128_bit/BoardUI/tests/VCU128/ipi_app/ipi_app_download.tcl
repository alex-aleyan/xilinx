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

puts "You have these environment variables set:"
foreach index [array names env] {
    puts "$index: $env($index)"
}

set serial [lindex $argv 3]

if { [string is integer -strict [lindex $argv 7]] } { 
    if { [lindex $argv 7] < 1 } {
        set TEST_DELAY 1
    } else {
        set TEST_DELAY [lindex $argv 7]
    }
} else {
    set TEST_DELAY 2
}

set_param xicom.use_bitstream_version_check false
set_param "labtools.core_refresh_on" 0

open_hw
catch {disconnect_hw_server localhost:3121}
set i 0
while {[catch {connect_hw_server -url localhost:3121}]} {
    puts "Trying to connect to hw_server again...."
    after 500
    incr i
    if {$i > 10} {
        break
    }
}

set i 0
while {[catch {open_hw_target [get_hw_targets -regexp (?i).*/xilinx_tcf/.*/$serial.*]}]} {
    puts "Trying to get_hw_targets again..."
    after 500
    incr i
    if {$i > 10} {
        break
    }
}

current_hw_device [lindex [get_hw_devices -regexp xcvu37p_0] 0]
refresh_hw_device -update_hw_probes false [lindex [get_hw_devices -regexp xcvu37p_0] 0]

set_property PROGRAM.FILE [pwd]/ipi_app/ipi_app.bit [lindex [get_hw_devices -regexp xcvu37p_0] 0]

program_hw_devices [lindex [get_hw_devices -regexp xcvu37p_0] 0]
refresh_hw_device [lindex [get_hw_devices -regexp xcvu37p_0] 0]

set donepin [get_property {REGISTER.CONFIG_STATUS.BIT14_DONE_PIN} [lindex [get_hw_devices -regexp xcvu37p_0] 0]]
puts "DONE STATUS: $donepin"
close_hw_target [current_hw_target [get_hw_targets -regexp (?i).*/xilinx_tcf/.*/$serial.*]]
disconnect_hw_server localhost:3121
close_hw
exit
