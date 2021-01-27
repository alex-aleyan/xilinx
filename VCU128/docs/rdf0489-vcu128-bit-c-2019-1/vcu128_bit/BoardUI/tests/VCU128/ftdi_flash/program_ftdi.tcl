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
set board [lindex $argv 1]
set rev [lindex $argv 2]

#puts [pwd]
#cd ftdi_flash
source [pwd]/ftdi_flash/ftdieeprom.tcl
set number_of_devices [number_of_devices]
puts "Number of devices = $number_of_devices"
if {$number_of_devices != 1} { 
    puts "Test Failed: Incorrect number of FTDI chips detected" 
    exit
    }
set device_list [device_list]
puts "device_list = $device_list"
set serial_number [return_serial_number]
set description [return_description]
if {$serial_number == $serial && $description == "VCU128 A" } { 
    puts "FTDI Programming Passed" 
    exit
    }
set location [return_location]
puts "location = $location"
set description [return_description]
puts "description = $description"
if {$number_of_devices == 1 && $description == "Quad RS232-HS A" } { 
    set status [program_eeprom $location VCU128 $serial]
    puts "FTDI Programming Passed"
    }
exit
