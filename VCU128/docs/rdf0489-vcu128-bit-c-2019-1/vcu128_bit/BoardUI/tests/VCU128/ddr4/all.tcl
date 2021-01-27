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
    incr i
    if {$i > 10} {
        break
    }
}

open_hw_target [get_hw_targets -regexp (?i).*/xilinx_tcf/.*/$serial.*]
program_hw_devices -key {bbr} -clear [get_hw_devices xcvu37p_0]
current_hw_device [lindex [get_hw_devices -regexp xcvu37p_0] 0]
refresh_hw_device -update_hw_probes false [lindex [get_hw_devices -regexp xcvu37p_0] 0]

set_property PROBES.FILE [pwd]/ddr4/vcu128_ddr4.ltx [lindex [get_hw_devices -regexp xcvu37p_0] 0]
set_property FULL_PROBES.FILE [pwd]/ddr4/vcu128_ddr4.ltx [lindex [get_hw_devices -regexp xcvu37p_0] 0]
set_property PROGRAM.FILE [pwd]/ddr4/vcu128_ddr4.bit [lindex [get_hw_devices -regexp xcvu37p_0] 0]

program_hw_devices [lindex [get_hw_devices -regexp xcvu37p_0] 0]
refresh_hw_device [lindex [get_hw_devices -regexp xcvu37p_0] 0]

refresh_hw_mig [get_hw_migs -regexp (?i).*/xilinx_tcf/.*/$serial.*/.*/MIG.*]

puts "Waiting $TEST_DELAY minutes for test to run."

set iserror 0
set finaltime [expr [ clock click -milliseconds] + $TEST_DELAY * 60 * 1000]
while {[ clock click -milliseconds] < $finaltime} {
    for {set j 0} {$j < 30} {incr j} {
        if { [ catch {
            set sysmon [lindex [get_hw_sysmons -of_objects [lindex [get_hw_devices] 0]] 0]
            refresh_hw_sysmon $sysmon
            set TEMP_final [get_property TEMPERATURE [lindex [get_hw_sysmons -of_objects [lindex [get_hw_devices] 0]] 0]]
            set systemTime [clock seconds]
        } err ] } {
            puts $err
            puts "ERROR: coulnd't set variables"
            set iserror 1
            break
        }

        if {$TEMP_final > 100} {
            puts "The temperature at: [clock format $systemTime -format %H:%M:%S] was $TEMP_final degrees celsius"
            puts "Temp check: $TEMP_final"
            if {$TEMP_final > 105} {
                puts "ERROR: OVERHEAT WILL LIKELY OCCUR"
            }
        }

        if {$iserror == 1} {
            break
        }
    
        after 1000
    }
    
    puts "The temperature at: [clock format $systemTime -format %H:%M:%S] was $TEMP_final degrees celsius"
    puts "Temp check: $TEMP_final"

    if {$iserror == 1} {
        break
    }
}

refresh_hw_mig [get_hw_migs -regexp (?i).*/xilinx_tcf/.*/$serial.*/.*/MIG.*]
set microblaze_status [get_property MICROBLAZE_START_UP [get_hw_migs -regexp (?i).*/xilinx_tcf/.*/$serial.*/.*/MIG.*]]
set config_status [get_property CALIBRATION_FAIL.STATUS [get_hw_migs -regexp (?i).*/xilinx_tcf/.*/$serial.*/.*/MIG.*]]

if {$config_status == "FALSE"} {
    puts "MIG status: CAL PASS"
} else {
    puts "MIG status: CAL FAIL"
}
puts "MicroBlaze status: $microblaze_status"

refresh_hw_device -update_hw_probes false [lindex [get_hw_devices -regexp xcvu37p_0] 0]
set donepin [get_property {REGISTER.CONFIG_STATUS.BIT14_DONE_PIN} [lindex [get_hw_devices -regexp xcvu37p_0] 0]]
puts "DONE STATUS: $donepin"
close_hw_target [current_hw_target [get_hw_targets -regexp (?i).*/xilinx_tcf/.*/$serial.*]]
disconnect_hw_server localhost:3121
close_hw
exit
