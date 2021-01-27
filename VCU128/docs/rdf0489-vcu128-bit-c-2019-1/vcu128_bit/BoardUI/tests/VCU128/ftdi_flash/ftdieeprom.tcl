
#Xilinx FTDI Programming routine Ver1.3
#Histor:
#	Version 1.0 Initial release
#	Version 1.1 Modified 06/14/2018 by Lou Morrison
#				Added support for XBB boards
#	Version 1.2 Modified 06/22/2018 by Lou Morrison
#				changed FirmwareID for pcietst to FT2232H
#	Version 1.3 Modified 07/13/2018 by JLM
#				Added calls for BIT automation.
#				    return_location
#				    return_serial_number
#				    return_description
#				    number_of_devices
#				Note: "device_list" call returns garbage when more than one board is connected. 
#				Note: New "number_of_devices" call correctly numbers the connected boards. 
#				Note: DLL is missing Erase call; must use FT_Prog to erase FTDI device.
#

source [file join [file dirname [info script]] ftd2xx.tcl]

set ftdi_configs {
    FT232H {VendorId 1027 ProductId 24596 MaxPower 100 PnP 1 SerNumEnableH 1 ACDriveCurrentH 4 ADDriveCurrentH 4 IsFifoH 1}
    FT2232H {VendorId 1027 ProductId 24592 MaxPower 100 PnP 1 SerNumEnable7 1 ALDriveCurrent 4 AHDriveCurrent 4 BLDriveCurrent 4 BHDriveCurrent 4 IFAIsFifo7 1 BIsVCP7 1}
    FT4232H {VendorId 1027 ProductId 24593 MaxPower 100 PnP 1 SerNumEnable8 1 ADriveCurrent 4 BDriveCurrent 4 CDriveCurrent 4 DDriveCurrent 4 BIsVCP8 1 CIsVCP8 1 DIsVCP8 1}
}

set boards {
    tul {FtdiConfig FT2232H FirmwareId 0x584a0001 Vendor Xilinx Product TUL Manufacturer Xilinx Description TUL}
    openjtag1 {FtdiConfig FT232H FirmwareId 0x584a0002 Vendor Xilinx Product {HW-FTDI-TEST FT232H} Manufacturer Xilinx Description JTAG}
    openjtag2 {FtdiConfig FT2232H FirmwareId 0x584a0003 Vendor Xilinx Product {HW-FTDI-TEST FT2232H} Manufacturer Xilinx Description JTAG+Serial}
    AU200A64G {FtdiConfig FT4232H FirmwareId 0x584a0004 Vendor Xilinx Product {A-U200-A64G FT4232H} Manufacturer Xilinx Description A-U200-A64G}
    VCU128    {FtdiConfig FT4232H FirmwareId 0x584a0004 Vendor Xilinx Product {HW-U1-VCU128 FT4232H} Manufacturer Xilinx Description VCU128}
    AU200P64G {FtdiConfig FT4232H FirmwareId 0x584a0004 Vendor Xilinx Product {A-U200-P64G FT4232H} Manufacturer Xilinx Description A-U200-P64G}
    AU250A64G {FtdiConfig FT4232H FirmwareId 0x584a0004 Vendor Xilinx Product {A-U250-A64G FT4232H} Manufacturer Xilinx Description A-U250-A64G}
    AU250P64G {FtdiConfig FT4232H FirmwareId 0x584a0004 Vendor Xilinx Product {A-U250-P64G FT4232H} Manufacturer Xilinx Description A-U250-P64G}
    AU280A32G {FtdiConfig FT4232H FirmwareId 0x584a0004 Vendor Xilinx Product {A-U280-A32G FT4232H} Manufacturer Xilinx Description A-U280-A32G}
    AU280P32G {FtdiConfig FT4232H FirmwareId 0x584a0004 Vendor Xilinx Product {A-U280-P32G FT4232H} Manufacturer Xilinx Description A-U280-P32G}
    CBU1AEBE {FtdiConfig FT4232H FirmwareId 0x584a0004 Vendor Xilinx Product {CB-U1-AEBE FT4232H} Manufacturer Xilinx Description CB-U1-AEBE}
    VCU1550 {FtdiConfig FT4232H FirmwareId 0x584a0004 Vendor Xilinx Product {HW-U1-VCU1550 FT4232H} Manufacturer Xilinx Description VCU1550}
    VCU1525 {FtdiConfig FT4232H FirmwareId 0x584a0004 Vendor Xilinx Product {HW-U1-VCU1525 FT4232H} Manufacturer Xilinx Description VCU1525}
    VCU1526 {FtdiConfig FT4232H FirmwareId 0x584a0004 Vendor Xilinx Product {HW-U1-VCU1526 FT4232H} Manufacturer Xilinx Description VCU1526}
    XBB1525 {FtdiConfig FT4232H FirmwareId 0x584a0004 Vendor Xilinx Product {HW-U1-XBB1525 FT4232H} Manufacturer Xilinx Description XBB1525}
    XBB1526 {FtdiConfig FT4232H FirmwareId 0x584a0004 Vendor Xilinx Product {HW-U1-XBB1526 FT4232H} Manufacturer Xilinx Description XBB1526}
    XBB1551 {FtdiConfig FT4232H FirmwareId 0x584a0004 Vendor Xilinx Product {HW-U1-XBB1550 FT4232H} Manufacturer Xilinx Description XBB1551}
    SP701 {FtdiConfig FT4232H FirmwareId 0x584a0004 Vendor Xilinx Product {HW-S7-SP701 FT4232H} Manufacturer Xilinx Description SP701}
    pcietst {FtdiConfig FT2232H FirmwareId 0x584a0003 Vendor Xilinx Product {HW-TST-PCIEPWR FT2232H} Manufacturer Xilinx Description TstPCIePwr}
    ZCU111 {FtdiConfig FT4232H FirmwareId 0x584a0004 Vendor Xilinx Product {HW-Z1-ZCU111 FT4232H} Manufacturer Xilinx Description ZCU111}
}

proc dict_get_safe {dict args} {
    if { [dict exists $dict {*}$args] } {
	return [dict get $dict {*}$args]
    }
    return {}
}

proc device_list {} {
    set devs [ftd2xx get_device_info_list]
    set res ""
    set skip 0
    foreach dev $devs {
	if { $skip > 0 } {
	    incr skip -1
	    continue
	}
	set ID [dict_get_safe $dev ID]
	set VID [expr {($ID >> 16) & 0xffff}]
	set PID [expr {$ID & 0xffff}]
	if { $VID != 0x0403 } continue
	if { $PID == 0x6010 } { incr skip 1 }
	if { $PID == 0x6011 } { incr skip 3 }

	if { $res == "" } {
	    append res [format "%-10s %-30s %-20s" Location Description SerialNumber]
	}
	append res "\n"
	append res [format "%-10s %-30s %-20s" [dict_get_safe $dev LocId] [dict_get_safe $dev Description] [dict_get_safe $dev SerialNumber]]
    }
    return $res
}

proc return_description {} {
    set devs [ftd2xx get_device_info_list]
    set res ""
    set skip 0
    foreach dev $devs {
	if { $skip > 0 } {
	    incr skip -1
	    continue
	}
	set ID [dict_get_safe $dev ID]
	set VID [expr {($ID >> 16) & 0xffff}]
	set PID [expr {$ID & 0xffff}]
	if { $VID != 0x0403 } continue
	if { $PID == 0x6010 } { incr skip 1 }
	if { $PID == 0x6011 } { incr skip 3 }

	#if { $res == "" } {
	#    append res [format "%-10s %-30s %-20s" Location Description SerialNumber]
	#}
	#append res "\n"
	set res [dict_get_safe $dev Description]
    }
    return $res
}

proc return_location {} {
    set devs [ftd2xx get_device_info_list]
    set res ""
    set skip 0
    foreach dev $devs {
	if { $skip > 0 } {
	    incr skip -1
	    continue
	}
	set ID [dict_get_safe $dev ID]
	set VID [expr {($ID >> 16) & 0xffff}]
	set PID [expr {$ID & 0xffff}]
	if { $VID != 0x0403 } continue
	if { $PID == 0x6010 } { incr skip 1 }
	if { $PID == 0x6011 } { incr skip 3 }

	#if { $res == "" } {
	#    append res [format "%-10s %-30s %-20s" Location Description SerialNumber]
	#}
	#append res "\n"
	append res [dict_get_safe $dev LocId]
    }
    return $res
}

proc number_of_devices {} {
    set devs [ftd2xx get_device_info_list]
    set res ""
    set numdev 0
    foreach dev $devs {
	      incr numdev 1
	      continue
	  }
	  set res [expr {$numdev / 4}]
    return $res
}

proc return_serial_number {} {
    set devs [ftd2xx get_device_info_list]
    set res ""
    set skip 0
    foreach dev $devs {
	if { $skip > 0 } {
	    incr skip -1
	    continue
	}
	set ID [dict_get_safe $dev ID]
	set VID [expr {($ID >> 16) & 0xffff}]
	set PID [expr {$ID & 0xffff}]
	if { $VID != 0x0403 } continue
	if { $PID == 0x6010 } { incr skip 1 }
	if { $PID == 0x6011 } { incr skip 3 }

	set res [string range [dict_get_safe $dev SerialNumber] 0 end-1]
    }
    return $res
}

proc program_eeprom {location board serial} {
    variable ftdi_configs
    variable boards
    if { ![dict exists $boards $board] } {
	error "unknown board type \"$board\": must be [join [dict keys $boards] {, }]"
    }
    set board_props [dict get $boards $board]
    set ftdi_config [dict get $ftdi_configs [dict get $board_props FtdiConfig]]
    dict set ftdi_config ManufacturerId ""
    dict set ftdi_config Manufacturer [dict get $board_props Manufacturer]
    dict set ftdi_config Description [dict get $board_props Description]
    dict set ftdi_config SerialNumber $serial

    set fwid [dict_get_safe $board_props FirmwareId]
    set vendor "[encoding convertto utf-8 [dict_get_safe $board_props Vendor]]\0"
    set product "[encoding convertto utf-8 [dict_get_safe $board_props Product]]\0"
    set user_area [binary format ia*a* $fwid $vendor $product]

    set handle {}
    set devs [ftd2xx get_device_info_list]
    foreach dev $devs {
	if { [dict_get_safe $dev LocId] != $location } continue
	set ID [dict_get_safe $dev ID]
	set VID [expr {($ID >> 16) & 0xffff}]
	set PID [expr {$ID & 0xffff}]
	set VID2 [dict_get_safe $ftdi_config VendorId]
	set PID2 [dict_get_safe $ftdi_config ProductId]
	if { $VID != $VID2 || $PID != $PID2 } {
	    error "unexpected VID/PID id, device $VID/$PID, board expects $VID2/$PID2"
	}
	set handle [ftd2xx open_by_location $location]
	break
    }
    if { $handle == {} } {
	error "no device at location \"$location\""
    }

    ftd2xx ee_program $handle $ftdi_config
    ftd2xx ee_ua_write $handle $user_area

    ftd2xx close $handle
}
