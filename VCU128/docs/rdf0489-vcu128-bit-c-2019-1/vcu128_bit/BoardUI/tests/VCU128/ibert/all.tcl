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

set_property PROGRAM.FILE [pwd]/ibert/ibert_bank_all.bit [lindex [get_hw_devices -regexp xcvu37p_0] 0]

program_hw_devices [lindex [get_hw_devices -regexp xcvu37p_0] 0]
refresh_hw_device [lindex [get_hw_devices -regexp xcvu37p_0] 0]

set_property PORT.QPLL0RESET 1 [get_hw_sio_commons *];commit_hw_sio [list [get_hw_sio_commons {*}] ]
set_property PORT.QPLL0RESET 0 [get_hw_sio_commons *];commit_hw_sio [list [get_hw_sio_commons {*}] ]
set_property PORT.QPLL1RESET 1 [get_hw_sio_commons *];commit_hw_sio [list [get_hw_sio_commons {*}] ]
set_property PORT.QPLL1RESET 0 [get_hw_sio_commons *];commit_hw_sio [list [get_hw_sio_commons {*}] ]
set_property PORT.CPLLRESET 1 [get_hw_sio_gts *];commit_hw_sio [list [get_hw_sio_gts {*}] ]
set_property PORT.CPLLRESET 0 [get_hw_sio_gts *];commit_hw_sio [list [get_hw_sio_gts {*}] ]
set_property PORT.GTRXRESET 1 [get_hw_sio_gts *];commit_hw_sio [list [get_hw_sio_gts {*}] ]
set_property PORT.GTRXRESET 0 [get_hw_sio_gts *];commit_hw_sio [list [get_hw_sio_gts {*}] ]
set_property PORT.GTTXRESET 1 [get_hw_sio_gts *];commit_hw_sio [list [get_hw_sio_gts {*}] ]
set_property PORT.GTTXRESET 0 [get_hw_sio_gts *];commit_hw_sio [list [get_hw_sio_gts {*}] ]
refresh_hw_sio [get_hw_sio_gts *]
refresh_hw_sio [get_hw_sio_commons *]

set links {
"IBERT/Quad_124/MGT_X0Y0"
"IBERT/Quad_124/MGT_X0Y1"
"IBERT/Quad_124/MGT_X0Y2"
"IBERT/Quad_124/MGT_X0Y3"
"IBERT/Quad_125/MGT_X0Y4"
"IBERT/Quad_125/MGT_X0Y5"
"IBERT/Quad_125/MGT_X0Y6"
"IBERT/Quad_125/MGT_X0Y7"
"IBERT/Quad_126/MGT_X0Y8"
"IBERT/Quad_126/MGT_X0Y9"
"IBERT/Quad_126/MGT_X0Y10"
"IBERT/Quad_126/MGT_X0Y11"
"IBERT/Quad_127/MGT_X0Y12"
"IBERT/Quad_127/MGT_X0Y13"
"IBERT/Quad_127/MGT_X0Y14"
"IBERT/Quad_127/MGT_X0Y15"
"IBERT/Quad_128/MGT_X0Y16"
"IBERT/Quad_128/MGT_X0Y17"
"IBERT/Quad_128/MGT_X0Y18"
"IBERT/Quad_128/MGT_X0Y19"
"IBERT/Quad_129/MGT_X0Y20"
"IBERT/Quad_129/MGT_X0Y21"
"IBERT/Quad_129/MGT_X0Y22"
"IBERT/Quad_129/MGT_X0Y23"
"IBERT/Quad_131/MGT_X0Y28"
"IBERT/Quad_131/MGT_X0Y29"
"IBERT/Quad_131/MGT_X0Y30"
"IBERT/Quad_131/MGT_X0Y31"
"IBERT/Quad_132/MGT_X0Y32"
"IBERT/Quad_132/MGT_X0Y33"
"IBERT/Quad_132/MGT_X0Y34"
"IBERT/Quad_132/MGT_X0Y35"
"IBERT/Quad_134/MGT_X0Y40"
"IBERT/Quad_134/MGT_X0Y41"
"IBERT/Quad_134/MGT_X0Y42"
"IBERT/Quad_134/MGT_X0Y43"
"IBERT/Quad_135/MGT_X0Y44"
"IBERT/Quad_135/MGT_X0Y45"
"IBERT/Quad_135/MGT_X0Y46"
"IBERT/Quad_135/MGT_X0Y47"
"IBERT/Quad_224/MGT_X1Y0"
"IBERT/Quad_224/MGT_X1Y1"
"IBERT/Quad_224/MGT_X1Y2"
"IBERT/Quad_224/MGT_X1Y3"
"IBERT/Quad_225/MGT_X1Y4"
"IBERT/Quad_225/MGT_X1Y5"
"IBERT/Quad_225/MGT_X1Y6"
"IBERT/Quad_225/MGT_X1Y7"
"IBERT/Quad_226/MGT_X1Y8"
"IBERT/Quad_226/MGT_X1Y9"
"IBERT/Quad_226/MGT_X1Y10"
"IBERT/Quad_226/MGT_X1Y11"
"IBERT/Quad_227/MGT_X1Y12"
"IBERT/Quad_227/MGT_X1Y13"
"IBERT/Quad_227/MGT_X1Y14"
"IBERT/Quad_227/MGT_X1Y15"
}

set xil_newLinks [list]

set m 0
foreach link $links {
    set xil_newLink [create_hw_sio_link -description {Link $m} [lindex [get_hw_sio_txs -regexp (?i)localhost:3121/xilinx_tcf/.*/$serial.*/0_1_0_.*/$link/TX] 0] [lindex [get_hw_sio_rxs -regexp (?i)localhost:3121/xilinx_tcf/.*/$serial.*/0_1_0_.*/$link/RX] 0] ]
    lappend xil_newLinks $xil_newLink
    incr m
}

set xil_newLinkGroup [create_hw_sio_linkgroup -description {Link Group 0} [get_hw_sio_links $xil_newLinks]]
unset xil_newLinks

set_property TX_PATTERN {PRBS 31-bit} [get_hw_sio_links -of_objects [get_hw_sio_linkgroups {LINKGROUP_0}]]
commit_hw_sio [get_hw_sio_links -of_objects [get_hw_sio_linkgroups {LINKGROUP_0}]]
set_property RX_PATTERN {PRBS 31-bit} [get_hw_sio_links -of_objects [get_hw_sio_linkgroups {LINKGROUP_0}]]
commit_hw_sio [get_hw_sio_links -of_objects [get_hw_sio_linkgroups {LINKGROUP_0}]]
set_property LOGIC.TX_RESET_DATAPATH 1 [get_hw_sio_links -of_objects [get_hw_sio_linkgroups {LINKGROUP_0}]]
commit_hw_sio [get_hw_sio_links -of_objects [get_hw_sio_linkgroups {LINKGROUP_0}]]
set_property LOGIC.TX_RESET_DATAPATH 0 [get_hw_sio_links -of_objects [get_hw_sio_linkgroups {LINKGROUP_0}]]
commit_hw_sio [get_hw_sio_links -of_objects [get_hw_sio_linkgroups {LINKGROUP_0}]]
set_property LOGIC.RX_RESET_DATAPATH 1 [get_hw_sio_links -of_objects [get_hw_sio_linkgroups {LINKGROUP_0}]]
commit_hw_sio [get_hw_sio_links -of_objects [get_hw_sio_linkgroups {LINKGROUP_0}]]
set_property LOGIC.RX_RESET_DATAPATH 0 [get_hw_sio_links -of_objects [get_hw_sio_linkgroups {LINKGROUP_0}]]
commit_hw_sio [get_hw_sio_links -of_objects [get_hw_sio_linkgroups {LINKGROUP_0}]]
set_property LOGIC.MGT_ERRCNT_RESET_CTRL 1 [get_hw_sio_links -of_objects [get_hw_sio_linkgroups {LINKGROUP_0}]]
commit_hw_sio [get_hw_sio_links -of_objects [get_hw_sio_linkgroups {LINKGROUP_0}]]
set_property LOGIC.MGT_ERRCNT_RESET_CTRL 0 [get_hw_sio_links -of_objects [get_hw_sio_linkgroups {LINKGROUP_0}]]
commit_hw_sio [get_hw_sio_links -of_objects [get_hw_sio_linkgroups {LINKGROUP_0}]]


puts "ERRORS BEFORE REFRESH"
puts "===================="
puts "===================="
for {set i 0} { $i < $m} {incr i} {
  set display_name [get_property {DISPLAY_NAME} [lindex [get_hw_sio_gts] $i]]
  set quad_name [lindex [split [get_property {NAME} [lindex [get_hw_sio_gts] $i]] /] 6]
  puts "$quad_name:$display_name: LOGIC.ERRBIT_COUNT.BEFOREREFRESH=[get_property {LOGIC.ERRBIT_COUNT} [lindex [get_hw_sio_links] $i]]"
}
puts "===================="
puts "===================="

foreach link $links {
    refresh_hw_sio [list [get_hw_sio_links -regexp (?i)localhost:3121/xilinx_tcf/.*/$serial.*/0_1_0_.*/$link/TX->localhost:3121/xilinx_tcf/.*/$serial.*/0_1_0_.*/$link/RX] ]
}

array set errbit_count_before {}
array set errbit_count_before_dec {}
puts "ERRORS AFTER REFRESH"
puts "===================="
puts "===================="
for {set i 0} { $i < $m} {incr i} {
  set display_name [get_property {DISPLAY_NAME} [lindex [get_hw_sio_gts] $i]]
  set quad_name [lindex [split [get_property {NAME} [lindex [get_hw_sio_gts] $i]] /] 6]
  puts "$quad_name:$display_name: LOGIC.ERRBIT_COUNT.BEFOREREFRESH=[get_property {LOGIC.ERRBIT_COUNT} [lindex [get_hw_sio_links] $i]]"
  set errbit_count_before($i) [get_property {LOGIC.ERRBIT_COUNT} [lindex [get_hw_sio_links] $i]]
  scan $errbit_count_before($i) %x errbit_count_before_dec($i)
  set errbit_count_before_dec($i)
}
puts "===================="
puts "===================="

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

foreach link $links {
    refresh_hw_sio [list [get_hw_sio_links -regexp (?i)localhost:3121/xilinx_tcf/.*/$serial.*/0_1_0_.*/$link/TX->localhost:3121/xilinx_tcf/.*/$serial.*/0_1_0_.*/$link/RX] ]
}

array set errbit_count_after {}
array set errbit_count_after_dec {}
puts "ACTUAL TEST RESULTS"
puts "===================="
puts "===================="
for {set i 0} { $i < $m} {incr i} {
  set display_name [get_property {DISPLAY_NAME} [lindex [get_hw_sio_gts] $i]]
  set quad_name [lindex [split [get_property {NAME} [lindex [get_hw_sio_gts] $i]] /] 6]
  set qpll0 [expr [expr $i / 4] * 6]
  puts "$quad_name:$display_name: DESCRIPTION=[get_property {DESCRIPTION} [lindex [get_hw_sio_links] $i]]"
  puts "$quad_name:$display_name: STATUS=[get_property {STATUS} [lindex [get_hw_sio_links] $i]]"
  puts "$quad_name:$display_name: QPLL0_STATUS=[get_property {QPLL0_STATUS} [lindex [get_hw_sio_plls] $qpll0]]"
  puts "$quad_name:$display_name: LINE_RATE=[get_property {LINE_RATE} [lindex [get_hw_sio_links] $i]]"
  puts "$quad_name:$display_name: LOGIC.ERRBIT_COUNT=[get_property {LOGIC.ERRBIT_COUNT} [lindex [get_hw_sio_links] $i]]"
  set errbit_count_after($i) [get_property {LOGIC.ERRBIT_COUNT} [lindex [get_hw_sio_links] $i]]
  scan $errbit_count_after($i) %x errbit_count_after_dec($i)
  set errbit_count_after_dec($i)
  set totalcount [expr {$errbit_count_after_dec($i) - $errbit_count_before_dec($i)}]
  set totalreceived [get_property {RX_RECEIVED_BIT_COUNT} [lindex [get_hw_sio_links] $i]]
  set BER [expr $totalcount / $totalreceived]
#  if { $BER < 0.000000000001 } {
#    puts "$quad_name:$display_name: LOGIC.ERRBIT_COUNT_NO_VIVADO_BUG_DECIMAL=0"
#  } else {
    puts "$quad_name:$display_name: LOGIC.ERRBIT_COUNT_NO_VIVADO_BUG_DECIMAL=$totalcount"
    puts "$quad_name:$display_name: LOGIC.ERRBIT_BER=$BER"
#  }
  puts "$quad_name:$display_name: RX_RECEIVED_BIT_COUNT=[get_property {RX_RECEIVED_BIT_COUNT} [lindex [get_hw_sio_links] $i]]"
  puts "$quad_name:$display_name: TX_PATTERN=[get_property {TX_PATTERN} [lindex [get_hw_sio_links] $i]]"
  puts "$quad_name:$display_name: RX_PATTERN=[get_property {RX_PATTERN} [lindex [get_hw_sio_links] $i]]"
  puts "$quad_name:$display_name: LOOPBACK=[get_property {LOOPBACK} [lindex [get_hw_sio_links] $i]]"
  puts "$quad_name:$display_name: TX_ENDPOINT=[get_property {TX_ENDPOINT} [lindex [get_hw_sio_links] $i]]"
  puts "$quad_name:$display_name: RX_ENDPOINT=[get_property {RX_ENDPOINT} [lindex [get_hw_sio_links] $i]]"
  puts "$quad_name:$display_name: NAME=[get_property {NAME} [lindex [get_hw_sio_gts] $i]]"
  puts "$quad_name:$display_name: get_hw_sio_plls=[lindex [get_hw_sio_plls] $qpll0]"
}
puts "===================="
puts "===================="

refresh_hw_device -update_hw_probes false [lindex [get_hw_devices -regexp xcvu37p_0] 0]
set donepin [get_property {REGISTER.CONFIG_STATUS.BIT14_DONE_PIN} [lindex [get_hw_devices -regexp xcvu37p_0] 0]]
puts "DONE STATUS: $donepin"
close_hw_target [current_hw_target [get_hw_targets -regexp (?i).*/xilinx_tcf/.*/$serial.*]]
disconnect_hw_server localhost:3121
close_hw
exit
