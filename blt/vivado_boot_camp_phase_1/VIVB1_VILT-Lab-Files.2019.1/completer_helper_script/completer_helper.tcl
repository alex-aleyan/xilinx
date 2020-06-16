#
# ***********************************************************************
#
# script for performing the common tasks that completer scripts require
#    
#   originally written to support the rapid development of both generic designs as well as the Embedded ULD
#
# ----- Alphabetic Listing of Procs -----
#
#       applyZynqProcessorPreset { }
#       bitstreamRun { }
#       blockDesignCreate { }
#       blockDesignSave { }
#       blockDesignWrap { }
#       buildStartingPoint { }
#       buttonsRosettaAdd { }
#       clearAll { }
#       constraintFilesAdd { constraintFileList }
#       constraintFilesDefaultAdd { }
#       designExport { }
#       hardwareManagerOpen { }
#       implementationRun { }
#       LEDsLinearAdd { }
#       LEDsRosettaAdd { }
#       make { stopAfterStep }
#       makeStep { stepToDo }
#       MIGadd { }
#       nextTerminator { str }
#       processorAdd { }
#       processorBlockAutomationRun { }
#       processorConfigure { }
#       processorDefaultConnect { }
#       projectCreate { }
#       reGenLayout { }
#       SDKlaunch { }
#       simSourceListAdd { sourceList }
#       simulationRun { }
#       sourcesAdd { sourceList }
#       switchesLinearAdd { }
#       synthesisRun { }
#       UARTadd { }
#       UARTaddConditional { }
#       VIOadd { }
#       VivadoClose { }
#       VivadoCloseProject { }
#
# ----------
#
#   note naming convention - nounVerb. This organizes the information by item then by what happens to that item
#   index: ("global" varaibles identified in curly braces)
#      projectCreate - {tcName, labName, language, verbose, platform, demoOrLab} to assemble a project
#      blockDesignCreate - {blockDesignName} to create an empty block design
#      sourcesAdd sourceList - adds HDL source files. If extension not specified then $language is used to append proper extension
#      processorAdd      - {platform, processor, tcName, verbose} to add the designated processor to the block design
#      processorConfigure - uses variable activePeripheralsList to enable selected peripherals
#      reGenLayout
#      processorBlockAutomationRun
#      blockDesignWrap
#      constraintFilesAdd(comma separated list of file names)
#      synthesisRun
#      implementationRun
#      bitstreamRun
#      designExport
#      SDKlaunch
#      VivadoClose
#
#     procs specific to the Embedded ULD 
#      VIOadd
#      LEDsLinearAdd
#      buttonsRosettaAdd
#      LEDsRosettaAdd
#      switchesLinearAdd
#      UARTadd
#
# *** assistance routines:
#    makeStep # - builds only step #
#    make # | all - builds everything upto and including #. "all" will build everything
#
# **************** "global" variables ******************
#    platform
#    tcName
#    language
#    processor
#    labOrDemo  (--> isLab?)
#
#
# History:
#    2019.1    - WK - 2019/05/06 - added support for ZCU111 and ZCU102. minor code cleanup
#    2019.1    - OB,NK,WK - 2019/03/?? - documenting and general cleanup
#    2018.3    - LR - 2019/02/06 - fixed Xparernt cell gneration and unused interrupt input
#    2018.3    - WK - 2019/01/22 - cleaned up problems associated with MicroBlaze processor selection
#    2018.3    - AM - 2019/01/16 - Added Linux paths 
#    2018.1a   - WK - 2018/05/02 - added RFSoC support in USE
#    2018.1    - LR - 2018/04/16 - Fixed blockDesignWrap for proper operation
#    2017.3    - WK - 2017/10/16 - "make" now works with comma separated list of arguments within parenthesis constraintFilesAdd(file1,file2,...); got constraintFilesAdd working
#    2017.3    - WK - 2017/09/14 - deprecation of "makeTo" and "makeToEndOfStep"
#    2016.3    - WK - 2017/01/13 - addition of new procs, further testing of existing procs, includsion of UED similar capabilities
#    initial   - WK - 2016/11/10 - based on many other completer scripts
#
# ***********************************************************************
#

set suppressLogErrors 1

if ($debug) {
   puts "Starting load of completer_helper.tcl";
}

set hostOS [lindex $tcl_platform(os) 0]
if { $hostOS == "Windows" } {
    set trainingPath "c:"
    set xilinxPath "c:/Xilinx"
} else {
    set trainingPath "/home/xilinx"
    set xilinxPath "/opt/Xilinx/Vivado_SDK"
}
puts "set training directory as $trainingPath/training and Xilinx tool path as $xilinxPath"

# 
# data set to turn everything in the Zynq device off (except clock and reset which may be needed by the microBlaze)
variable ZynqAllOff {CONFIG.PCW_USE_M_AXI_GP0                     0
                     CONFIG.PCW_USE_M_AXI_GP1                     0
                     CONFIG.PCW_USE_S_AXI_GP0                     0
                     CONFIG.PCW_USE_S_AXI_GP1                     0
                     CONFIG.PCW_USE_S_AXI_ACP                     0
                     CONFIG.PCW_USE_S_AXI_HP0                     0
                     CONFIG.PCW_USE_S_AXI_HP1                     0
                     CONFIG.PCW_USE_S_AXI_HP2                     0
                     CONFIG.PCW_USE_S_AXI_HP3                     0
                     CONFIG.PCW_EN_CLK0_PORT                      0
                     CONFIG.PCW_EN_CLK1_PORT                      0
                     CONFIG.PCW_EN_CLK2_PORT                      0
                     CONFIG.PCW_EN_CLK3_PORT                      0
                     CONFIG.PCW_EN_RST0_PORT                      0
                     CONFIG.PCW_EN_RST1_PORT                      0
                     CONFIG.PCW_EN_RST2_PORT                      0
                     CONFIG.PCW_EN_RST3_PORT                      0
                     CONFIG.PCW_QSPI_PERIPHERAL_ENABLE            0
                     CONFIG.PCW_NAND_PERIPHERAL_ENABLE            0
                     CONFIG.PCW_NOR_PERIPHERAL_ENABLE             0
                     CONFIG.PCW_ENET0_PERIPHERAL_ENABLE           0
                     CONFIG.PCW_ENET1_PERIPHERAL_ENABLE           0
                     CONFIG.PCW_SD0_PERIPHERAL_ENABLE             0
                     CONFIG.PCW_SD1_PERIPHERAL_ENABLE             0
                     CONFIG.PCW_USB0_PERIPHERAL_ENABLE            0
                     CONFIG.PCW_USB1_PERIPHERAL_ENABLE            0
                     CONFIG.PCW_UART0_PERIPHERAL_ENABLE           0
                     CONFIG.PCW_UART1_PERIPHERAL_ENABLE           0
                     CONFIG.PCW_SPI0_PERIPHERAL_ENABLE              0
                     CONFIG.PCW_SPI1_PERIPHERAL_ENABLE              0
                     CONFIG.PCW_CAN0_PERIPHERAL_ENABLE            0
                     CONFIG.PCW_CAN1_PERIPHERAL_ENABLE            0
                     CONFIG.PCW_WDT_PERIPHERAL_ENABLE             0
                     CONFIG.PCW_TTC0_PERIPHERAL_ENABLE             0
                     CONFIG.PCW_TTC1_PERIPHERAL_ENABLE             0
                     CONFIG.PCW_USB0_PERIPHERAL_ENABLE            0
                     CONFIG.PCW_USB1_PERIPHERAL_ENABLE            0
                     CONFIG.PCW_I2C0_PERIPHERAL_ENABLE              0
                     CONFIG.PCW_I2C1_PERIPHERAL_ENABLE              0
                     CONFIG.PCW_GPIO_MIO_GPIO_ENABLE                  0
                     CONFIG.PCW_GPIO_EMIO_GPIO_ENABLE               0        
                    }
#
# data set for the MPSoC ZUS+ device - turns off all of the options
#CONFIG.preset                             ZCU102
variable MPSoCallOff { CONFIG.PSU__DISPLAYPORT__PERIPHERAL__ENABLE  0   
                       CONFIG.PSU__ENET1__PERIPHERAL__ENABLE        0
                       CONFIG.PSU__ENET2__PERIPHERAL__ENABLE        0
                       CONFIG.PSU__ENET3__PERIPHERAL__ENABLE        0
                       CONFIG.PSU__GPIO_EMIO__PERIPHERAL__ENABLE    0
                       CONFIG.PSU__GPIO0_MIO__PERIPHERAL__ENABLE    0 
                       CONFIG.PSU__GPIO1_MIO__PERIPHERAL__ENABLE    0
                       CONFIG.PSU__GPIO2_MIO__PERIPHERAL__ENABLE    0
                       CONFIG.PSU__PCIE__PERIPHERAL__ENABLE         0
                       CONFIG.PSU__PJTAG__PERIPHERAL__ENABLE        0
                       CONFIG.PSU__PMU__PERIPHERAL__ENABLE          0
                       CONFIG.PSU__QSPI__PERIPHERAL__ENABLE         0
                       CONFIG.PSU__SATA__PERIPHERAL__ENABLE         0
                       CONFIG.PSU__SD1__PERIPHERAL__ENABLE          0
                       CONFIG.PSU__SWDT0__PERIPHERAL__ENABLE        0
                       CONFIG.PSU__SWDT1__PERIPHERAL__ENABLE        0
                       CONFIG.PSU__TTC0__PERIPHERAL__ENABLE         0
                       CONFIG.PSU__TTC1__PERIPHERAL__ENABLE         0
                       CONFIG.PSU__TTC2__PERIPHERAL__ENABLE         0
                       CONFIG.PSU__TTC3__PERIPHERAL__ENABLE         0
                       CONFIG.PSU__UART0__PERIPHERAL__ENABLE        0
                       CONFIG.PSU__UART1__PERIPHERAL__ENABLE        0                  
                       CONFIG.PSU__USB0__PERIPHERAL__ENABLE         0
                       CONFIG.PSU__USB1__PERIPHERAL__ENABLE         0
                       CONFIG.PSU__FPGA_PL0_ENABLE                  0
                       CONFIG.PSU__USE__M_AXI_GP1                   0
                       CONFIG.PSU__USE__M_AXI_GP2                   0 
                       CONFIG.PSU__USE__S_AXI_GP0                   0
                       CONFIG.PSU__USE__S_AXI_GP1                   0
                       CONFIG.PSU__USE__S_AXI_GP2                   0
                       CONFIG.PSU__USE__S_AXI_GP3                   0
                       CONFIG.PSU__USE__S_AXI_GP4               0
                       CONFIG.PSU__USE__FABRIC__RST                 0
               }
            
#
# ********** Create the New Project
#

#/**
# * proc:  projectCreate
# * descr: 
# * @meta <list of searchable terms> 
# */
proc projectCreate {} {
   # get the variablely defined variables
   variable tcName
   variable labName
   variable language
   variable verbose
   variable platform
   variable demoOrLab
   variable trainingPath
   variable projName
   
   if {$verbose} { puts "completer_helper.projectCreate"; }   
   
   # close the project if one is open
   if { [catch { set nProjects [llength [get_projects -quiet -verbose *]]} fid] } {
      puts stderr "error caught!"
      puts $fid
   } else {
      if {$nProjects > 0} {
        if {$verbose} { puts "project is open and will try to close it" }
           close_project
      } else {
       #if {$verbose} { puts "no projects to close. Continuing with creation of new project" }
     }
   }   
   
   # check if both a language and platform has been selected
   set isLangNotSelected [strsame $language "undefined"]
   set isPlatNotSelected [strsame $platform "undefined"]
   
   set isverilog    [string compare -nocase $language "verilog"]
   set isvhdl       [string compare -nocase $language "vhdl"]
   
   set isZed             [strsame $platform "ZED"]
   set isZC702           [strsame $platform "ZC702"]
   #set isUBlaze          [strsame $processor "MicroBlaze"]   -- processor not carried into this proc
   set isZCU102          [strsame $platform "ZCU102"]
   set isZCU104          [strsame $platform "ZCU104"]
   set isZCU111          [strsame $platform "ZCU111"]
   set isRFSoC           [strsame $platform "RFSoC_board"]
   
   set isKCU105          [strsame $platform "KCU105"]
   set isKC705           [strsame $platform "KC705"]
   set isKC7xx           [strsame $platform "KC7xx"]
      
   # ensure that the language has been selected
   if {[logicValue $isLangNotSelected]} {
      puts "Please type: use VHDL | Verilog"
      puts "   then rerun the projectCreate"
   } elseif {[logicValue $isPlatNotSelected]} {
      puts "Please type: use ZCU102 | ZCU111 | ZC702 | Zed | ZCU104 | RFSoC -- note: other boards exist, but have been deprecated";  
      puts "   then rerun the projectCreate"
   } else {
     # future - verify that "latestVersion" will work for the boards
     if {[logicValue $isZed]} {
         create_project -force $labName $trainingPath/training/$tcName/$demoOrLab -part xc7z020clg484-1
         set_property board_part em.avnet.com:zed:part0:1.3 [current_project]
     } elseif {[logicValue $isZC702]} {
         create_project -force $labName $trainingPath/training/$tcName/$demoOrLab -part xc7z020clg484-1
         set_property board_part xilinx.com:zc702:part0:1.2 [current_project] 
     } elseif {[logicValue $isZCU102]} {
         create_project -force $labName $trainingPath/training/$tcName/$demoOrLab -part xczu9eg-ffvb1156-2-e
         set_property board_part xilinx.com:zcu102:part0:3.2 [current_project]       
     } elseif {[logicValue $isZCU104]} {
         create_project -force $labName $trainingPath/training/$tcName/$demoOrLab -part xczu7ev-ffvc1156-2-e
         set_property board_part xilinx.com:zcu104:part0:1.1 [current_project]
	 } elseif {[logicValue $isRFSoC]} {
         create_project -force $labName $trainingPath/training/$tcName/$demoOrLab -part xczu25dr-ffve1156-1-i
         set_property target_language VHDL [current_project]     
     } elseif {[logicValue $isKCU105]} {
         create_project -force $projName $trainingPath/training/$tcName/$demoOrLab/$platform/$language -part xcku040-ffva1156-2-e
         set_property board_part xilinx.com:kcu105:part0:1.5 [current_project]
	 } elseif {[logicValue $isKC705]} {
         create_project -force $projName $trainingPath/training/$tcName/$demoOrLab/$platform/$language -part xc7k325tffg900-2
		 set_property board_part xilinx.com:kc705:part0:1.6 [current_project] 
	 } elseif {[logicValue $isKC7xx]} {
         create_project -force $projName $trainingPath/training/$tcName/$demoOrLab/$platform/$language -part xc7k70tfbg484-2 
	 }
	 
     # with the project now open, set the default language
      set_property target_language $language [current_project]
   }

   markLastStep projectCreate
}
#
# ********** Create a Block Design
#
#/**
# * proc:  blockDesignCreate
# * descr: 
# * @meta <list of searchable terms> 
# */
proc blockDesignCreate {} {
   variable verbose
   if {$verbose} { puts "completer_helper.blockDesignCreate"; } 
   variable blockDesignName
   
   # create Block Design - test to see if "blkDsgn" exists and skip if it does
   # note: this only tests to see if a block design exists - it doesn't test for the specific block design name
   set blkDsgns [get_bd_designs -quiet]
   if {[llength $blkDsgns] == 0} {
      create_bd_design $blockDesignName 
      update_compile_order -fileset sources_1     
   }
  
   markLastStep blockDesignCreate
}
#
# *********** save the block design
#
#/**
# * proc:  blockDesignSave
# * descr: 
# * @meta <list of searchable terms> 
# */
proc blockDesignSave {} {
   variable verbose
   if {$verbose} { puts "completer_helper.blockDesignSave"; } 
   save_bd_design
   markLastStep save_bd_design;
}
#
# ********** add source files
#   source files in list may include extensions or not
#   if no extensions are found, then the language is used to identify what the extension should be and this extension is appended to the file name
#/**
# * proc:  sourcesAdd
# * descr: 
# * @meta <list of searchable terms> 
# * @param sourceList  
# */
proc sourcesAdd { sourceList } {
   variable trainingPath
   variable verbose 
   if {$verbose} { puts "completer_helper.sourcesAdd $sourceList"; } 
   variable language
   variable tcName
   
   # set selected language
   set isVHDL [strcmp $language vhdl]
   set isVerilog [strcmp $language verilog]
   
   # load all the files from the source list from the support directory unless a full path is specified
   foreach fileName $sourceList { 
      # is there a full path provided? - Does not make corrections for langauage - assumes user knows what he/she's doing
     set hierarchyList [hierarchyToList $fileName]
     if {[llength $hierarchyList] > 1} {        # a hierarchy has been presented so use it instead of the support directory 
        set useThisFile $ 
     } else {  
        # no, so assume that we are pulling from the support directory
        set fullFileName ""
        append fullFileName $trainingPath/training/$tcName/support/ $fileName
        #if there isn't an extension, then add one based on the selected language    
         set isVHDLsource [strEndsWith $fileName .vhd]
         set isVerilogSource [strEndsWith $fileName .v]
         set isTextSource [strEndsWith $fileName .txt]
         
        if {$isVHDLsource == 0 && $isVerilogSource == 0 && $isTextSource == 0} {    
           if {$isVHDL == 1} { append fullFileName .vhd }
          if {$isVerilog == 1} { append fullFileName .v }
        }
         
        # this line copies the file to the local working directory keeping the original file unchanged     
        set useThisFile $fullFileName
      }
     import_files -norecurse $useThisFile
   }   
}
#
# ********** add simulation files
#   simulation source files in list may include extensions or not
#   if no extensions are found, then the language is used to identify what the extension should be and this extension is appended to the file name
#/**
# * proc:  simSourceListAdd
# * descr: 
# * @meta <list of searchable terms> 
# * @param sourceList  
# */
proc simSourceListAdd { sourceList } {
   variable verbose 
   if {$verbose} { puts "completer_helper.simSourceListAdd $sourceList"; } 
   variable language
   variable tcName
   variable trainingPath                            
   
   # set selected language
   set isVHDL [strsame $language vhdl]
   set isVerilog [strsame $language verilog]
   
   # load all the files from the source list from the support directory unless a full path is specified
   foreach fileName $sourceList { 
      # is there a full path provided? - Does not make corrections for langauage - assumes user knows what he/she's doing
     set hierarchyList [hierarchyToList $fileName]
     if {[llength $hierarchyList] > 1} {        # a hierarchy has been presented so use it instead of the support directory 
        set useThisFile $ 
     } else {  
        # no, so assume that we are pulling from the support directory
        set fullFileName ""
        append fullFileName $trainingPath/training/$tcName/support/ $fileName
        #if there isn't an extension, then add one based on the selected language    
         set isVHDLsource    [strEndsWith $fileName .vhd]
         set isVerilogSource [strEndsWith $fileName .v]
         set isTextSource [strEndsWith $fileName .txt]                                      
        if {!($isVHDLsource) && !($isVerilogSource) && !($isTextSource)} {     
           if {$isVHDL}    { append fullFileName .vhd }
          if {$isVerilog} { append fullFileName .v }
        }
        # the following line uses the source from where it is
        #add_files -norecurse $fullFileName
        # this line copies the file to the local working directory keeping the original file unchanged     
        set useThisFile $fullFileName
      }
     import_files -fileset sim_1 -norecurse $useThisFile
     update_compile_order -fileset sim_1
   }   
   markLastStep simSourceListAdd
}
#/**
# * proc:  constraintFilesDefaultAdd
# * descr: 
# * @meta <list of searchable terms> 
# */
proc constraintFilesDefaultAdd {} {
   variable tcName
   variable trainingPath
   variable processor
   variable platform
   variable verbose
   if {$verbose} { puts "completer_helper.constraintFilesDefaultAdd"}
   
   # default constraint files
   set isZed        [strsame $platform "ZED"]
   set isZC702      [strsame $platform "ZC702"]
   
   if {$isZC702} {
     #add_files -fileset constrs_1 -norecurse $trainingPath/training/$tcName/support/ZC702_base.xdc
     add_files -fileset constrs_1 -norecurse $trainingPath/training/CustEdIP/ZC702_base.xdc
   } elseif {$isZed} {
     #add_files -fileset constrs_1 -norecurse $trainingPath/training/$tcName/support/Zed_base.xdc
     add_files -fileset constrs_1 -norecurse $trainingPath/training/CustEdIP/Zed_base.xdc
   }
   
   # if it's a microblaze, then we have to connect the sys_diff_clk
   set isUBlaze [strsame $processor MicroBlaze]
   
   if {$isUBlaze} {
     if {$isZC702} {
       set clkConstraintFile $trainingPath/training/$tcName/support/ZC702_sys_clk.xdc
       if {[fileExists $clkConstraintFile]} {
         add_files -fileset constrs_1 -norecurse $clkConstraintFile
       }
     } elseif {$isZed == 0} {
       set clkConstraintFile $trainingPath/training/$tcName/support/zed_sys_clk.xdc
       if {[fileExists $clkConstraintFile]} {
         add_files -fileset constrs_1 -norecurse $clkConstraintFile
       }
     }
   } else {
      # it is not a MicroBlaze processor, no need to do anything.
     # puts "***** Unsupported platform! $platform in constraintFilesAdd"
   }
      
   markLastStep constraintFilesDefaultAdd;      
}
#/**
# * proc:  constraintFilesAdd
# * descr: 
# * @meta <list of searchable terms> 
# * @param constraintFileList  
# */
proc constraintFilesAdd { constraintFileList } {
   variable tcName
   variable trainingPath
   variable verbose
   if {$verbose} { puts "completer_helper.constraintFilesAdd - $constraintFileList"}
   
   # if a list is provided, use it and ignore the embedded defaults
   if {[llength $constraintFileList] > 0 } {      
      foreach fileName $constraintFileList {   
        # is this a full path or just the name - if it's just the name assume that it's coming from the support directory
       # is there a full path provided? - Does not make corrections for langauage - assumes user knows what he/she's doing
        set hierarchyList [hierarchyToList $fileName]
        if {[llength $hierarchyList] > 1} {        # a hierarchy has been presented so use it instead of the support directory 
           set fullFileName $fileName
        } else {  
          # just the file name - assume it's coming from the source directory
           set fullFileName ""
          append fullFileName $trainingPath/training/$tcName/support/ $fileName
       }
        import_files -fileset constrs_1 -norecurse $fullFileName
      }   
   } else {
      puts "Expected a {list} of constraint files!"
   }
   
   markLastStep constraintFilesAdd;
}

#/**
# * proc:  ipFilesAdd
# * descr: 
# * @meta <list of searchable terms> 
# */
proc ipFilesAdd {} {
 variable tcName
 variable platform
 variable demoOrLab
 variable language
 variable verbose
 variable trainingPath
 
 if {$verbose == 1} { puts "adding IP files"}
 #Adds the ip files based on board choosen
 if {$platform == "KC705"} {
  import_files -norecurse $trainingPath/training/$tcName/support/clk_core.xci
 } elseif {$platform == "KCU105"} {
  import_files -norecurse $trainingPath/training/$tcName/support/clk_core.xci  
  import_files -norecurse $trainingPath/training/$tcName/support/char_fifo.xci
 }
markLastStep ipFilesAdded
}

#
#/**
# * proc:  copySourcestoTraining
# * descr: Copies SVN sources to training directory
# * @meta <list of searchable terms> 
# */
proc copySourcestoTraining {} {
variable tcName
variable trainingPath

file copy /media/sf_trunk/FPGA/TopicClusters/$tcName $trainingPath/training
}

#
# ***** Processor/Processing System
#/**
# * proc:  applyZynqProcessorPreset
# * descr: 
# * @meta <list of searchable terms> 
# */
proc applyZynqProcessorPreset {} {
   variable processor
   variable platform
   variable verbose
   
   if {$verbose} { puts "in completer_helper.applyZynqProcessorPreset"; }
   
   # what is it? makes comparisons below easier
   set isZed    [strcmp $platform Zed]
   set isZC702  [strcmp $platform ZC702]
   set isZCU102 [strcmp $platform ZCU102]
   set isZCU104 [strcmp $platform ZCU104]
   set isUBlaze [strcmp $processor MicroBlaze]
   
   if {$isUBlaze == 0} {
      # If using ublaze, no need to do anything with presets.
   } else {
      if {$isZCU104 == 0} {
      # todo: probably wrong - validate
         set_property -dict [list CONFIG.preset {ZCU104}] [get_bd_cells processing_system7_0]
      } elseif {$isZC702 == 0} {
         set_property -dict [list CONFIG.preset {ZC702}] [get_bd_cells processing_system7_0]
      } elseif {$isZed ==0} {
         set_property -dict [list CONFIG.preset {ZedBoard}] [get_bd_cells processing_system7_0]
      } else {
         puts "****** Zynq MP Needs to be implemented"
      }
   }
   
   markLastStep applyZynqProcessorPreset;
}

#
# ********** Processor/Processing System
#/**
# * proc:  processorAdd
# * descr: 
# * @meta <list of searchable terms> 
# */
proc processorAdd {} {
   variable platform
   variable trainingPath
   variable processor
   variable tcName
   variable verbose
   if {$verbose} { puts "in completer_helper.processorAdd - adding processor: $processor" }

   # clear the processors if they exist
   set processors [get_bd_cells -quiet {micro* proc* zynq_ultra* noInterrupts PS_access}]
   delete_bd_objs -quiet $processors
   
   # PS (if part supports it)
   set isZed    [strsame $platform Zed]
   set isZC702  [strsame $platform ZC702]
   set isZCU102 [strsame $platform ZCU102]
   set isRFSoC  [strsame $platform RFSoC_board]
   set isUBlaze [strsame $processor MicroBlaze]
   
   if {$isUBlaze} {
      if {$verbose} { puts "adding the MicroBlaze"}
      create_bd_cell -type ip -vlnv [latestVersion xilinx.com:ip:microblaze:10.0] microblaze_0
     
     # when the uB is running in a Zynq-7000 or MPSoC/RFSoC device, we have to use the special IP to access the rx, tx, and hp0 ports of the PS
     # [2018.1] mcheck if ip_repo_paths contains CustEdIP - if not, add it to the repository
     # todo: make sure this ADDs it to the repository not replacing anything that is already there
     set availableIPs [get_ipdefs]
     set targetIPname XparentPS:1.0
     if {![containedIn $targetIPname $availableIPs]} {
        set_property  ip_repo_paths  $trainingPath/training/CustEdIP/XparentPS [current_project]
        update_ip_catalog    
     }
     
     # todo: this is what it should be: create_bd_cell -type ip -vlnv [latestVersion xilinx.com:user:xparentPS:1.0] PS_access
     #create_bd_cell -type ip -vlnv [latestVersion xilinx.com:user:XarentPS:1.0] PS_access
     create_bd_cell -type ip -vlnv xilinx.com:user:$targetIPname PS_access
     set_property -dict [list CONFIG.CLK_100MHz_EN {true} CONFIG.Rx_EN {true} CONFIG.Tx_EN {true} CONFIG.CLK_reset_EN {true} CONFIG.S_AXI_HP0_EN {true}] [get_bd_cells PS_access]  
     ##set_property range 512M [get_bd_addr_segs {microblaze_0/Data/SEG_PS_access_reg0}]     
   } else {
      # if not specifically targeting the uB, the PS will be instantiated
      if {$isZed || $isZC702} {                 # add in the Zynq7000 PS
         if {$verbose} { puts "is a Zed or ZC702 - adding the PS" }
         create_bd_cell -type ip -vlnv [latestVersion xilinx.com:ip:processing_system7:5.5] processing_system7_0
      } elseif {$isZCU102} {                          # add in the US+ PS
         if {$verbose} { puts "is a ZCU102 - adding the PS"}
         create_bd_cell -type ip -vlnv [latestVersion xilinx.com:ip:zynq_ultra_ps_e:3.0] zynq_ultra_ps_e_0
      } elseif {$isRFSoC} {
         if {$verbose} { puts "is an RFSoC device - adding the PS"}
         create_bd_cell -type ip -vlnv [latestVersion xilinx.com:ip:zynq_ultra_ps_e:3.0] zynq_ultra_ps_e_0      
      }
   }
  
   regenerate_bd_layout
   save_bd_design
   
   markLastStep processorAdd
}
#
# ********** processorConfigure
#
# - ensures that processor is configured for the board and includes an M_AXI_GP0
#
#/**
# * proc:  processorConfigure
# * descr: 
# * @meta <list of searchable terms> 
# */
proc processorConfigure {} {
   variable platform
   variable processor
   variable ZynqAllOff
   variable MPSoCallOff
   variable activePeripheralList
   variable debug
   
   variable verbose   
   if {$verbose} { puts "in completer_helper.processorConfigure"; }
   
   variable suppressInterrupts
   if (![info exists suppressInterrupts]) { set suppressInterrupts 0 }
   
   # what is it? makes comparisons below easier
   set isRFSoC  [strsame $platform RFSoC_board]
   set isZed    [strsame $platform Zed]
   set isZC702  [strsame $platform ZC702]
   set isZCU102 [strsame $platform ZCU102]
   set isAPSoC  [expr $isZed || $isZC702]
   set isMPSoC  [expr $isZCU102 || $isRFSoC]
   set isUBlaze [strsame $processor MicroBlaze]
   set isZynqPS [strsame $processor ps7_cortexa9_0]
   set isA53    [strsame $processor A53]
   set isR5     [strsame $processor R5]
   
   # clear the PS's configuration
   if {$isAPSoC} {
      set targetDevice processing_system7_0
      set list $ZynqAllOff
   } elseif {$isMPSoC || $isRFSoC} {
      set targetDevice zynq_ultra_ps_e_0
#      set_property -dict [list CONFIG.PSU__FPGA_PL0_ENABLE {1} CONFIG.PSU__USE__M_AXI_GP2 {1}] [get_bd_cells zynq_ultra_ps_e_0]
     set list $MPSoCallOff
   } elseif {$isUBlaze} {
      # no action required
   } else {
      boxedMsg "undefined processor!"
      return;
   }

   # is there a microblaze in this design?     
   if {$isUBlaze} {
      # ignore the PS in this device as it is being managed by the PS_access IP
     
      if ($suppressInterrupts) { 
         if {$verbose} { puts "configuring uB without interrupts"; }
         apply_bd_automation -rule xilinx.com:bd_rule:microblaze -config {preset "Microcontroller" local_mem "32KB" ecc "None" cache "None" debug_module "Debug Only" axi_periph "Enabled" axi_intc "0" clk "/PS_access/CLK_100MHz (100 MHz)" }  [get_bd_cells microblaze_0]
      } else { 
         if {$verbose} { puts "configuring uB with interrupts"; }
         apply_bd_automation -rule xilinx.com:bd_rule:microblaze -config {preset "Microcontroller" local_mem "32KB" ecc "None" cache "None" debug_module "Debug Only" axi_periph "Enabled" axi_intc "1" clk "/PS_access/CLK_100MHz (100 MHz)" }  [get_bd_cells microblaze_0]
         puts "Grounding unused pin on Concat block to Intertupt controller"; 
         create_bd_cell -type ip -vlnv [latestVersion xilinx.com:ip:xlconstant:1.1] UNUSEDintr_gnd
         set_property -dict [list CONFIG.CONST_VAL {0}] [get_bd_cells UNUSEDintr_gnd]
         connect_bd_net [get_bd_pins microblaze_0_xlconcat/In1] [get_bd_pins UNUSEDintr_gnd/dout];                          
      }
      connect_bd_net [get_bd_pins PS_access/CLK_reset_n] [get_bd_pins rst_PS_access_100M/ext_reset_in]      
           
     # connect the uB design to the HP0 for data access to DDR
     apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/microblaze_0 (Periph)" intc_ip "/microblaze_0_axi_periph" Clk_xbar "Auto" Clk_master "Auto" Clk_slave "Auto" }  [get_bd_intf_pins PS_access/S_AXI_HP0]

   } else {
      # set the board specific preset
      if {$verbose} { puts "configuring PS - no MicroBlaze present" }
      if {$isZCU102} {
         puts "   configuring ZCU102's PS with no preset ($targetDevice)";
         apply_bd_automation -rule xilinx.com:bd_rule:zynq_ultra_ps_e -config {apply_board_preset "0" }  [get_bd_cells zynq_ultra_ps_e_0]
      } elseif {$isZC702} {
         if {$verbose} { puts "applying preset for ZC702" }
         set_property -dict [list CONFIG.preset {ZC702}] [get_bd_cells processing_system7_0]
         apply_bd_automation -rule xilinx.com:bd_rule:processing_system7 -config {make_external "FIXED_IO, DDR" apply_board_preset "1" Master "Disable" Slave "Disable" }  [get_bd_cells processing_system7_0]   
      } elseif {$isZed} {
         if {$verbose} { puts "applying preset for ZedBoard" }
         set_property -dict [list CONFIG.preset {ZedBoard}] [get_bd_cells processing_system7_0]
         apply_bd_automation -rule xilinx.com:bd_rule:processing_system7 -config {make_external "FIXED_IO, DDR" apply_board_preset "1" Master "Disable" Slave "Disable" }  [get_bd_cells processing_system7_0]        
      } else {
        if {$verbose} { puts "no presets for MPSoC or RFSoC" }
      }
     
      # todo: can we skip this if we're targeting the MicroBlaze?
      # clear the PS's configuration
      set nConfigItems [llength $list]
      for {set index 0} {$index < $nConfigItems} {incr index 2} {
         set itemNameIndex  $index
         set itemValueIndex [expr $index + 1 ]
         set itemName       [lindex $list $itemNameIndex ]
         set itemValue      [lindex $list $itemValueIndex]
         set_property $itemName $itemValue [get_bd_cells $targetDevice]    
      }
     
     
      # dump the parameters that need to be configured...
      # if { $debug } {
         # for {set debugIndex 0} {$debugIndex < [llength $activePeripheralList]} {incr debugIndex 2} {
            # set itemNameIndex $debugIndex   
            # set itemValueIndex [expr $debugIndex + 1 ]
            # set itemName       [lindex $activePeripheralList $itemNameIndex ]  
            # set itemValue      [lindex $activePeripheralList $itemValueIndex]
            # if {$verbose} { puts "configuring PS's option: $itemName to value: $itemValue"; }         
         # }
      # }
            
      
      # add in user's specific configuration
      set nConfigItems [llength $activePeripheralList]
      for {set index 0} {$index < $nConfigItems} {incr index 2} {
         set itemNameIndex $index   
         set itemValueIndex [expr $index + 1 ]
         set itemName       [lindex $activePeripheralList $itemNameIndex ]  
         set itemValue      [lindex $activePeripheralList $itemValueIndex]
         if {$verbose} { puts "configuring PS's option: $itemName to value: $itemValue"; }
         set_property $itemName $itemValue [get_bd_cells $targetDevice]
      }
   }
       
   save_bd_design  
   
   markLastStep processorConfigure
}
#
# *** processorDefaultConnect
#
#/**
# * proc:  processorDefaultConnect
# * descr: 
# * @meta <list of searchable terms> 
# */
proc processorDefaultConnect {} {
   variable platform
   variable processor
   variable verbose
   variable ZynqAllOff
   variable MPSoCallOff
   variable activePeripheralsList
   
   if {$verbose} { puts "in completer_helper.processorDefaultConnect"; }
   
   # what is it? makes comparisons below easier
   set isZed    [strcmp $platform Zed]
   set isZC702  [strcmp $platform ZC702]
   set isZCU102 [strcmp $platform ZCU102]
   set isUBlaze [strcmp $processor MicroBlaze]  

   if { $isUBlaze == 0 } {
      # if the transparent PS peripheral is available, then get rid of the clock wizard and use the XparentPS instead
      set XparentPSpresent [get_bd_cells -quiet PS_access]  
      if {[llength $XparentPSpresent]} {
         # clock connection
         disconnect_bd_net /microblaze_0_Clk [get_bd_pins clk_wiz_1/clk_out1]
         connect_bd_net [get_bd_pins PS_access/CLK_100MHz] [get_bd_pins microblaze_0/Clk]
         # and the locked nReset signals
         delete_bd_objs [get_bd_nets clk_wiz_1_locked]
         connect_bd_net [get_bd_pins PS_access/CLK_reset_n] [get_bd_pins rst_clk_wiz_1_100M/dcm_locked]
         # remove the IP and port
         delete_bd_objs [get_bd_intf_nets CLK_IN1_D_1] [get_bd_intf_ports CLK_IN1_D]
         delete_bd_objs [get_bd_nets noReset_dout] [get_bd_cells clk_wiz_1] [get_bd_cells noReset]
         # remove the rtl reset port and associated connection with the clk_wiz_1
         delete_bd_objs [get_bd_nets reset_rtl_1] [get_bd_ports reset_rtl]
         # connect the ext_reset_in to the XParentPS
         connect_bd_net [get_bd_pins rst_clk_wiz_1_100M/ext_reset_in] [get_bd_pins PS_access/CLK_reset_n]
      }
   }
  
   set PS7inUse [get_bd_cells -quiet processing_system7*]
   if {[llength $PS7inUse] > 0} {
      if { $isZed == 0 || $isZC702 == 0} {
         apply_bd_automation -rule xilinx.com:bd_rule:processing_system7 -config {make_external "FIXED_IO, DDR" apply_board_preset "0" Master "Disable" Slave "Disable" }  [get_bd_cells processing_system7_0]
      }
   }
  
   markLastStep processorDefaultConnect
}
#
# *** VIOadd
#    - requires that a clock source exist before making this call - in the case of the uB, the clock should be from the PS_access IP
#
#/**
# * proc:  VIOadd
# * descr: 
# * @meta <list of searchable terms> 
# */
proc VIOadd {} {
   variable platform
   variable processor
   variable tcName
   variable verbose
   if {$verbose} { puts "completer_helper.VIOadd"; }
   
   # remove the VIO if it already exists
   set VIOs [get_bd_cells -quiet {vio_fmcce LCD_*} ]
   delete_bd_objs -quiet $VIOs
   
   # determine the platform   
   set isZed    [strsame $platform Zed]
   set isZC702  [strsame $platform ZC702]
   set isZCU102 [strsame $platform ZCU102]
   # todo: PS could also be A53
   set isPS     [strsame $processor ps7_cortexa9_0]
   set isUBlaze [strsame $processor microblaze]
   
   # instantiate and configure the VIO
   set vioName vio_fmcce
   set VIO_nInputs 3
   set VIO_nOutputs 3
   create_bd_cell -type ip -vlnv [latestVersion  xilinx.com:ip:vio:3.0] $vioName
   set_property -dict [list CONFIG.C_NUM_PROBE_IN $VIO_nInputs  CONFIG.C_NUM_PROBE_OUT $VIO_nOutputs] [get_bd_cells $vioName]
   set_property -dict [list CONFIG.C_PROBE_IN0_WIDTH {7}] [get_bd_cells $vioName];     # LCD
   set_property -dict [list CONFIG.C_PROBE_IN1_WIDTH {8}] [get_bd_cells $vioName];     # LEDs_linear
   set_property -dict [list CONFIG.C_PROBE_IN2_WIDTH {5}] [get_bd_cells $vioName];     # LEDs_rosetta
   set_property -dict [list CONFIG.C_PROBE_OUT0_WIDTH {1}] [get_bd_cells $vioName];    # LCD data catcher next datum request
   set_property -dict [list CONFIG.C_PROBE_OUT1_WIDTH {5}] [get_bd_cells $vioName];    # Buttons_Rosetta
   set_property -dict [list CONFIG.C_PROBE_OUT2_WIDTH {8}] [get_bd_cells $vioName];    # Switches_Linear
   
   # connect the clock
   if {$isUBlaze} { 
     #connect_bd_net [get_bd_pins vio_fmcce/clk] [get_bd_pins clk_wiz_1/clk_out1]; 
     apply_bd_automation -rule xilinx.com:bd_rule:clkrst -config {Clk "/PS_access/CLK_100MHz (100 MHz)" }  [get_bd_pins vio_fmcce/clk]
   } 
   # future - will also have to check for R5 and A53
   if {$isPS} { connect_bd_net [get_bd_pins vio_fmcce/clk] [get_bd_pins processing_system7_0/FCLK_CLK0]; } 
   
   # tie off the LCDs as they are no longer being used, let the LED outputs hang open
   create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 LCD_const_data
   set_property -dict [list CONFIG.CONST_WIDTH {7} CONFIG.CONST_VAL {0}] [get_bd_cells LCD_const_data]
   connect_bd_net [get_bd_pins LCD_const_data/dout] [get_bd_pins vio_fmcce/probe_in0]
   
   # the remainingVIO connections will be made by their respective GPIO elements
}
#
# *** Linear LEDs
#
#/**
# * proc:  LEDsLinearAdd
# * descr: 
# * @meta <list of searchable terms> 
# */
proc LEDsLinearAdd { } {
   variable platform
   variable processor
   variable tcName
   variable verbose
   if {$verbose} { 
      puts "completer_helper.LEDsLinearAdd (Adding Linear LED to PS)";  
   }
   
   set ipName GPIO_LEDs_linear
   set ipCore "xilinx.com:ip:axi_gpio"
   set ipPort LEDs_linear
   
   # remove the VIO if it already exists
   set objects [get_bd_cells -quiet {GPIO_LEDs_linear} ]
   delete_bd_objs -quiet $objects
   set objects [get_bd_ports -quiet $ipPort ]
   delete_bd_objs -quiet $objects
   
   # add GPIO Linear LEDs, configure, and connect
   create_bd_cell -type ip -vlnv [latestVersion xilinx.com:ip:axi_gpio:2.0] $ipName
   set_property -dict [list CONFIG.C_GPIO_WIDTH {8} CONFIG.C_ALL_OUTPUTS {1}] [get_bd_cells $ipName]
   
   # connect to the appropraite processor
   set isUBlaze [strsame $processor MicroBlaze]
   
   if {$isUBlaze} {
      apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/microblaze_0 (Periph)" Clk "Auto" }  [get_bd_intf_pins GPIO_LEDs_linear/S_AXI]
   } elseif {[strsame $processor A53]} {
      apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config { Clk_master {/zynq_ultra_ps_e_0/pl_clk0 (96 MHz)} Clk_slave {Auto} Clk_xbar {/zynq_ultra_ps_e_0/pl_clk0 (96 MHz)} Master {/zynq_ultra_ps_e_0/M_AXI_HPM0_LPD} Slave {/GPIO_LEDs_linear/S_AXI} intc_ip {/ps8_0_axi_periph} master_apm {0}}  [get_bd_intf_pins GPIO_LEDs_linear/S_AXI]
   } else {                      
      apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/processing_system7_0/M_AXI_GP0" Clk "Auto" }  [get_bd_intf_pins $ipName/S_AXI]
   }
   
   # connect to the devices on the board
   set isZed        [strsame $platform ZED]
   set isZC702      [strsame $platform ZC702]
   set isZCU102     [strsame $platform ZCU102]
   
   #  Connect signals to board wherever possible - ZC702 and Zed have all 8 LEDs available
   if {$isZCU102} {
      apply_bd_automation -rule xilinx.com:bd_rule:board -config { Board_Interface {led_8bits ( LED ) } Manual_Source {Auto}}  [get_bd_intf_pins GPIO_LEDs_linear/GPIO]   
   } elseif {$isZC702 == 0} {
      create_bd_port -dir O -from 7 -to 0 $ipPort
      connect_bd_net [get_bd_pins /$ipName/gpio_io_o] [get_bd_ports $ipPort]
   } elseif {$isZed == 0} {
      create_bd_port -dir O -from 7 -to 0 $ipPort
      connect_bd_net [get_bd_pins /$ipName/gpio_io_o] [get_bd_ports $ipPort]
   }
   
   # connect to the VIO which should already have been instantiated
   
   set objects [get_bd_cells -quiet vio_fmcce ]
   if {[llength $objects] > 0} {
      puts "connecting to VIO"
      connect_bd_net [get_bd_pins GPIO_LEDs_linear/gpio_io_o] [get_bd_pins vio_fmcce/probe_in1]
   } 
}
#
# *** Buttons Rosetta
#
#/**
# * proc:  buttonsRosettaAdd
# * descr: 
# * @meta <list of searchable terms> 
# */
proc buttonsRosettaAdd { } {
   variable platform
   variable processor
   variable tcName
   variable verbose
   
   set isZed       [strsame $platform ZED]
   set isZC702  [strsame $platform ZC702]
   set isUBlaze [strsame $processor microblaze]   
   set ipName "GPIO_buttons_rosetta"
   set ipPort buttons_rosetta
   
   if {$verbose} { puts "completer_helper.buttonsRosettaAdd"; }
   
   # remove the device if it already exists
   set objects [get_bd_cells -quiet {$ipName GPIO_buttons_rosetta Buttons_ORed ground_3_bits adjust_Rosetta_button_width} ]
   delete_bd_objs -quiet $objects
   set objects [get_bd_ports -quiet $ipPort ]
   delete_bd_objs -quiet $objects
   
   # add GPIO Rosetta buttons and configure
   create_bd_cell -type ip -vlnv [latestVersion xilinx.com:ip:axi_gpio:2.0] $ipName
   set_property -dict [list CONFIG.C_GPIO_WIDTH {5} CONFIG.C_ALL_INPUTS {1}] [get_bd_cells $ipName]
   
   # connect to the appropriate processor
   if {$isUBlaze} {
      if {$verbose} { puts "running automation for $ipName - slave AXI connection in MicroBlaze context" }
      apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/microblaze_0 (Periph)" Clk "Auto" }  [get_bd_intf_pins $ipName/S_AXI]  
      #apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/microblaze_0 (Periph)" Clk "Auto" }  [get_bd_intf_pins GPIO_buttons_rosetta/S_AXI]
   } else {
      if {$verbose} { puts "running automation for $ipName - slave AXI connection in PS context" }
      apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/processing_system7_0/M_AXI_GP0" Clk "Auto" }  [get_bd_intf_pins $ipName/S_AXI]
   }

   # Connect signals to board wherever possible - ZC702 only has north and south, Zed has all 5 buttons available
   if {$isZC702} {
      # since input is available from the VIO and the board, an OR is required 
      create_bd_cell -type ip -vlnv [latestVersion xilinx.com:ip:util_vector_logic:2.0] Buttons_ORed
      set_property -dict [list CONFIG.C_OPERATION {or} CONFIG.LOGO_FILE {data/sym_orgate.png} CONFIG.C_SIZE {5}] [get_bd_cells Buttons_ORed]

     # since this board lacks a number of buttons,  the existing buttons have to be buffered to properly match the input of the OR gate
     create_bd_cell -type ip -vlnv [latestVersion xilinx.com:ip:xlconcat:2.1] adjust_Rosetta_button_width
     create_bd_cell -type ip -vlnv [latestVersion xilinx.com:ip:xlconstant:1.1] ground_3_bits
     set_property -dict [list CONFIG.CONST_WIDTH {3} CONFIG.CONST_VAL {0}] [get_bd_cells ground_3_bits]

     # create a board port and connect to the concatonation block and then on to the OR block
     create_bd_port -dir I -from 1 -to 0 $ipPort
      connect_bd_net [get_bd_pins /adjust_Rosetta_button_width/In0] [get_bd_ports $ipPort]
     connect_bd_net [get_bd_pins ground_3_bits/dout] [get_bd_pins adjust_Rosetta_button_width/In1]
     connect_bd_net [get_bd_pins adjust_Rosetta_button_width/dout] [get_bd_pins Buttons_ORed/Op1]

     # connect the VIO to the other input to the OR logic cell
     connect_bd_net [get_bd_pins vio_fmcce/probe_out1] [get_bd_pins Buttons_ORed/Op2]
     
     # connect the output of the OR to the GPIO
     connect_bd_net [get_bd_pins $ipName/gpio_io_i] [get_bd_pins Buttons_ORed/Res]

   } elseif {$isZed} {
      # since input is available from the VIO and the board, an OR is required 
      create_bd_cell -type ip -vlnv [latestVersion xilinx.com:ip:util_vector_logic:2.0] Buttons_ORed
      set_property -dict [list CONFIG.C_OPERATION {or} CONFIG.LOGO_FILE {data/sym_orgate.png} CONFIG.C_SIZE {5}] [get_bd_cells Buttons_ORed]
                 
     # create a board port and connect to the concatonation block and then on to the OR block
     create_bd_port -dir I -from 4 -to 0 $ipPort
     connect_bd_net [get_bd_pins $ipPort] [get_bd_pins Buttons_ORed/Op1]        
     
     # connect the VIO to the OR logic cell
     connect_bd_net [get_bd_pins vio_fmcce/probe_out1] [get_bd_pins Buttons_ORed/Op2]
     
     # connect the output of the OR to the GPIO
     connect_bd_net [get_bd_pins $ipName/gpio_io_i] [get_bd_pins Buttons_ORed/Res]

   } else {
      # future - if a board completely lacks these buttons then it can be routed directly to the VIO and GPIO
   }
   
}
#
# *** LEDs Rosetta
#
#/**
# * proc:  LEDsRosettaAdd
# * descr: 
# * @meta <list of searchable terms> 
# */
proc LEDsRosettaAdd { } {
   variable platform
   variable processor
   variable tcName
   variable verbose
   
   set isZed        [string compare -nocase $platform "ZED"]
   set isZC702      [string compare -nocase $platform "ZC702"]
   set ipName "GPIO_LEDs_rosetta"
   set ipPort LEDs_rosetta
   
   if {$verbose} { 
      puts "completer_helper.LEDsRosettaAdd";  
   }
   
   # remove the device if it already exists
   set objects [get_bd_cells -quiet {$ipName} ]
   delete_bd_objs -quiet $objects
   set objects [get_bd_ports -quiet $ipPort ]
   delete_bd_objs -quiet $objects
   
   # add GPIO Rosetta LEDs and configure
   create_bd_cell -type ip -vlnv [latestVersion xilinx.com:ip:axi_gpio:2.0] $ipName
   set_property -dict [list CONFIG.C_GPIO_WIDTH {5} CONFIG.C_ALL_OUTPUTS {1}] [get_bd_cells $ipName]
   
   # connect to the appropraite processor
   set isUBlaze [strcmp $processor MicroBlaze]
   if {$isUBlaze == 0} {
      apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/microblaze_0 (Periph)" Clk "Auto" }  [get_bd_intf_pins $ipName/S_AXI]
   } else {
     apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/processing_system7_0/M_AXI_GP0" Clk "Auto" }  [get_bd_intf_pins $ipName/S_AXI] 
   }
   
   #
   #  Connect signals to board wherever possible - both the ZC702 and Zed boards completely lack the rosetta LEDs therefore there is no port and connects directly to the VIO
   if {$isZC702 == 0} {
      connect_bd_net [get_bd_pins vio_fmcce/probe_in2] [get_bd_pins $ipName/gpio_io_o]
   } elseif {$isZed == 0} {
      connect_bd_net [get_bd_pins vio_fmcce/probe_in2] [get_bd_pins $ipName/gpio_io_o]
   }   
}
#
# *** Switches Linear
#
#/**
# * proc:  switchesLinearAdd
# * descr: 
# * @meta <list of searchable terms> 
# */
proc switchesLinearAdd { } {
   variable platform
   variable processor
   variable tcName
   variable verbose
   
   set isZed        [string compare -nocase $platform "ZED"]
   set isZC702      [string compare -nocase $platform "ZC702"]
   set ipName GPIO_switches_linear
   set ipPort switches_linear
   
   if {$verbose} { 
      puts "completer_helper.switchesLinearAdd";  
   }
   
   # remove the device if it already exists
   set objects [get_bd_cells -quiet {*switches*} ]
   delete_bd_objs -quiet $objects
   set objects [get_bd_ports -quiet $ipPort ]
   delete_bd_objs -quiet $objects
   
   # add GPIO Linear Switches and configure
   create_bd_cell -type ip -vlnv [latestVersion xilinx.com:ip:axi_gpio:2.0] $ipName
   set_property -dict [list CONFIG.C_GPIO_WIDTH {8} CONFIG.C_ALL_INPUTS {1}] [get_bd_cells $ipName]
   
   # connect to the appropraite processor
   set isUBlaze [strcmp $processor MicroBlaze]
   if {$isUBlaze == 0} {
      apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/microblaze_0 (Periph)" Clk "Auto" }  [get_bd_intf_pins $ipName/S_AXI]  
   } else {
     apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/processing_system7_0/M_AXI_GP0" Clk "Auto" }  [get_bd_intf_pins $ipName/S_AXI]
   }
   
   #
   # Connect signals to board wherever possible - ZC702 lacks the linear switches; Zed boards has the full set of 8 switches
   if {$isZC702 == 0} {
      # no board connection
     puts "ZC702 does not have any linear switches, therefore, no ports will be created and the GPIO will be connected directly to the VIO"
      connect_bd_net [get_bd_pins vio_fmcce/probe_out2] [get_bd_pins $ipName/gpio_io_i]
   } elseif {$isZed == 0} {
      puts "Zed board has full complement of switches and will be combined via an OR with the VIO's inputs"
      create_bd_port -dir I -from 7 -to 0 $ipPort
      create_bd_cell -type ip -vlnv [latestVersion xilinx.com:ip:util_vector_logic:2.0] Switches_ORed
      set_property -dict [list CONFIG.C_OPERATION {or} CONFIG.LOGO_FILE {data/sym_orgate.png}] [get_bd_cells Switches_ORed]
     
     # connect the OR gate to the port and to the VIO (which already have been instantiated)
     connect_bd_net [get_bd_ports switches_linear] [get_bd_pins Switches_ORed/Op1]
     connect_bd_net [get_bd_pins vio_fmcce/probe_out2] [get_bd_pins Switches_ORed/Op2]
     
     # connect the OR to the input of the GPIO      
      connect_bd_net [get_bd_pins Switches_ORed/Res] [get_bd_pins $ipName/gpio_io_i]
   }   
}
#
# *** UARTaddConditional
#   adds the UART only if the processor is a MicroBlaze
#/**
# * proc:  UARTaddConditional
# * descr: 
# * @meta <list of searchable terms> 
# */
proc UARTaddConditional {} {
   variable verbose
   if {$verbose} { puts "completer_helper.UARTaddConditional"; }
   variable processor
   if {[strsame $processor MicroBlaze]} {
      UARTadd
   }
}
#
# *** UART
#/**
# * proc:  UARTadd
# * descr: 
# * @meta <list of searchable terms> 
# */
proc UARTadd {} {
   variable platform
   variable processor
   variable tcName
   variable verbose
   variable suppressUARTinterrupt;     # there might be interrupts in the system, but the UART should connect to one
   variable suppressInterrupts;        # no interrupts in the system therefore the UART shouldn't generate one
   if {![info exists suppressUARTinterrupt]} { set suppressUARTinterrupt 0; }
   if {![info exists suppressInterrupts]}    { set suppressInterrupts 0; }  
   variable UARTdebug;                 # generates an ILA for monitoring the Rx/Tx lines of the UART
   if {![info exists UARTdebug]}    { set UARTdebug 0; }  
   
   set ipName UART
   
   if {$verbose} { puts "completer_helper.UARTadd"; }
   
   # remove the device if it already exists
   set objects [get_bd_cells -quiet *UART*]
   delete_bd_objs -quiet $objects
   delete_bd_objs [get_bd_nets -quiet {*UART* *Rx*}]
   
   if {[strsame $processor MicroBlaze]} {
      # add the UART itself
      create_bd_cell -type ip -vlnv [latestVersion xilinx.com:ip:axi_uartlite:2.0] $ipName
      set_property -dict [list CONFIG.C_BAUDRATE {115200}] [get_bd_cells $ipName]
      if {$suppressUARTinterrupt || $suppressInterrupts} { 
         puts "Microblaze processor found - adding UART without interrupt"; 
         # UART interrupt pin left hanging, input to interrupt controller is tied to ground - but only if there are system interrupts
         if {!$suppressInterrupts} {   
           # LR moved the constant creation to processorConfig
           # create_bd_cell -type ip -vlnv [latestVersion xilinx.com:ip:xlconstant:1.1] UARTintr_gnd
           # set_property -dict [list CONFIG.CONST_VAL {0}] [get_bd_cells UARTintr_gnd]
            connect_bd_net [get_bd_pins microblaze_0_xlconcat/In0] [get_bd_pins UARTintr_gnd/dout];            
         }
      } else {
         puts "Microblaze processor found - adding UART with interrupt";          
         connect_bd_net [get_bd_pins microblaze_0_xlconcat/In0] [get_bd_pins UART/interrupt];   # Added by LR 2/24/2017  
      }
      
      # if in debug mode, add an ILA to the Rx/Tx
      if {$UARTdebug} {
         if {$verbose} { puts "completer_helper.UARTadd - adding debug ILA for the UART"; }
         
         # add and configure the System ILA for the UART
         create_bd_cell -type ip -vlnv [latestVersion xilinx.com:ip:system_ila:1.1] UART_ILA
         set_property -dict [list CONFIG.C_BRAM_CNT {7.5} CONFIG.C_DATA_DEPTH {131072} CONFIG.C_NUM_OF_PROBES {2} CONFIG.C_ADV_TRIGGER {true} CONFIG.C_MON_TYPE {NATIVE}] [get_bd_cells UART_ILA]
         
         # remove the interface connection and replace with individual wires
         connect_bd_net [get_bd_pins PS_access/Rx] [get_bd_pins UART/rx]
         connect_bd_net [get_bd_pins UART_ILA/probe0] [get_bd_pins PS_access/Rx]
         connect_bd_net [get_bd_pins PS_access/Tx] [get_bd_pins UART/tx]
         connect_bd_net [get_bd_pins UART_ILA/probe1] [get_bd_pins UART/tx]
         
         # connect the clock
         apply_bd_automation -rule xilinx.com:bd_rule:clkrst -config {Clk "/PS_access/CLK_100MHz (100 MHz)" }  [get_bd_pins UART_ILA/clk]
      } else {
         connect_bd_intf_net [get_bd_intf_pins PS_access/UART_pins] [get_bd_intf_pins UART/UART]
      }
      
      # finally connect the UART's clock
      apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/microblaze_0 (Periph)" intc_ip "/microblaze_0_axi_periph" Clk_xbar "Auto" Clk_master "Auto" Clk_slave "Auto" }  [get_bd_intf_pins UART/S_AXI]
   }
}
#
# *** DDR Memory Controller (MIG) - not tested!
#
#/**
# * proc:  MIGadd
# * descr: 
# * @meta <list of searchable terms> 
# */
proc MIGadd { } {
   variable verbose;
   if {$verbose} { puts "completer_helper.MIGadd"; } 
   variable blockDesignName;
     
   # add MIG only if there is a MicroBlaze processor
   if {[strsame $processor MicroBlaze]} {
      # remove default clocking wizard
      # need to remove clock port as well because board automation for MIG automatically adds another one
      # maybe in the future this will get fixed
      delete_bd_objs [get_bd_intf_nets sys_diff_clock_1] [get_bd_nets clk_wiz_1_locked] [get_bd_cells clk_wiz_1]
      delete_bd_objs [get_bd_nets reset_1]
      delete_bd_objs [get_bd_intf_ports sys_diff_clock] 
      
      # Add MIG using board interface
      create_bd_cell -type ip -vlnv [latestVersion xilinx.com:ip:mig_7series:4.0] mig_7series_0
      apply_board_connection -board_interface "ddr3_sdram" -ip_intf "mig_7series_0/mig_ddr_interface" -diagram $blockDesignName
      
      # Connect reset
      connect_bd_net [get_bd_ports reset] [get_bd_pins mig_7series_0/sys_rst]
      connect_bd_net [get_bd_pins mig_7series_0/ui_clk_sync_rst] [get_bd_pins rst_clk_wiz_1_100M/ext_reset_in] 
      
      # Connect clock signals
      connect_bd_net -net [get_bd_nets microblaze_0_Clk] [get_bd_pins mig_7series_0/ui_clk]
      connect_bd_net [get_bd_pins mig_7series_0/mmcm_locked] [get_bd_pins rst_clk_wiz_1_100M/dcm_locked]   
      connect_bd_net -net [get_bd_nets rst_clk_wiz_1_100M_peripheral_aresetn] [get_bd_pins mig_7series_0/aresetn] [get_bd_pins rst_clk_wiz_1_100M/peripheral_aresetn]
      
      # Re-customize uB to support DDR connection
      set_property -dict [list CONFIG.C_USE_ICACHE {1} CONFIG.C_USE_DCACHE {1}] [get_bd_cells microblaze_0]
      apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/microblaze_0 (Cached)" Clk "Auto" }  [get_bd_intf_pins mig_7series_0/S_AXI]      
   } 
   markLastStep MIGadd;
}
#
# *** regenerate board layout
#
#/**
# * proc:  reGenLayout
# * descr: 
# * @meta <list of searchable terms> 
# */
proc reGenLayout {} {
  variable verbose      
  if {$verbose} { puts "completer_helper.reGenLayout" }
  regenerate_bd_layout
  save_bd_design
  
  markLastStep reGenLayout
}

#
# ********** processorBlockAutomationRun
#
# - connects processor to I/O
#
#/**
# * proc:  processorBlockAutomationRun
# * descr: 
# * @meta <list of searchable terms> 
# */
proc processorBlockAutomationRun {} {
   variable processor
   variable platform
   variable verbose   
   if {$verbose} { puts "in processorBlockAutomationRun"; }
   
   # what is it? makes comparisons below easier
   set isRFSoC  [strsame $platform RFSoC_board]
   set isZed    [strsame $platform Zed]
   set isZC702  [strsame $platform ZC702]
   set isZCU102 [strsame $platform ZCU102]
   set isAPSoC  [expr $isZed || $isZC702]
   set isMPSoC  [expr $isZCU102 || $isRFSoC]
   set isUBlaze [strsame $processor MicroBlaze]
   set isZynqPS [strsame $processor ps7_cortexa9_0]
   set isA53    [strsame $processor A53]
   set isR5     [strsame $processor R5]
   
   if {$isUBlaze} {
      puts "no automation needs to be run on a microblaze only configuration"
   } elseif {$isAPSoC} {
      puts "running automation on a Zynq-7000"
      apply_bd_automation -rule xilinx.com:bd_rule:processing_system7 -config {make_external "FIXED_IO, DDR" apply_board_preset "0" Master "Disable" Slave "Disable" }  [get_bd_cells processing_system7_0]
   } elseif {$isMPSoC} {
      # no action at this point because this appears to be taking place with the processorConfigure proc
   } else {
      puts "Undefined or unsupported processor for blockAutomation"
   }
#**LR** (2018.3)
   puts "Set PS DDR RAM access to 512MB Starting at 0x20000000"
   set_property range 512M [get_bd_addr_segs {microblaze_0/Data/SEG_PS_access_reg0}]
   set_property offset 0x20000000 [get_bd_addr_segs {microblaze_0/Data/SEG_PS_access_reg0}]
   
   markLastStep processorBlockAutomationRun
}
#/**
# * proc:  blockDesignWrap
# * descr: 
# * @meta <list of searchable terms> 
# */
proc blockDesignWrap {} {
   variable tcName
   variable trainingPath
   variable labName
   variable blockDesignName
   variable demoOrLab
   variable verbose
   if {$verbose} { puts "completer_helper.blockDesignWrap" }
   
   save_bd_design
   close_bd_design [get_bd_designs $blockDesignName]

   if {[string compare -nocase [getLanguage] undefined] == 0} {
      puts "Please select VHDL or Verilog with the \"use\" proc"
      return
   }
    
   set fullPath ""
   append fullPath $trainingPath/training/$tcName/$demoOrLab/$labName.srcs/sources_1/bd/$blockDesignName/$blockDesignName.bd
   make_wrapper -files [get_files $fullPath] -top
   
   set fullPath ""
   if {[string compare -nocase [getLanguage] verilog] == 0} {
      append fullPath $trainingPath/training/$tcName/$demoOrLab/$tcName.srcs/sources_1/bd/$blockDesignName/hdl/$blockDesignName\_wrapper.v    
   } else {
      append fullPath $trainingPath/training/$tcName/$demoOrLab/$labName.srcs/sources_1/bd/$blockDesignName/hdl/$blockDesignName\_wrapper.vhd  
   }
   add_files -norecurse $fullPath
   update_compile_order -fileset sources_1 
   update_compile_order -fileset sim_1
   
   markLastStep wrapBlockDesign
}
#/**
# * proc:  simulationRun
# * descr: 
# * @meta <list of searchable terms> 
# */
proc simulationRun {} {
   variable verbose
   if {$verbose} { puts "completer_helper.simulationRun" }
   
   launch_simulation
   
   markLastStep simulationRun
}
#/**
# * proc:  synthesisRun
# * descr: 
# * @meta <list of searchable terms> 
# */
proc synthesisRun {} {
   variable verbose   
   if {$verbose} { puts "completer_helper.synthesisRun"; }
   
   reset_run synth_1
   launch_runs synth_1 -jobs 4
   if {$verbose} { puts "\twaiting for synthesis to complete"; }
   wait_on_run synth_1
   open_run synth_1 -name synth_1
   
   markLastStep synthesisRun
}
#/**
# * proc:  implementationRun
# * descr: 
# * @meta <list of searchable terms> 
# */
proc implementationRun {} {
   variable verbose   
   if {$verbose} { puts "completer_helper.implementationRun"; }
   
   #reset_run synth_1
   launch_runs impl_1 -jobs 4
   if {$verbose} { puts "\twaiting for bitstream generation to complete"; }
   wait_on_run impl_1
   open_run impl_1
   
   markLastStep implementationRun
}
#/**
# * proc:  bitstreamRun
# * descr: 
# * @meta <list of searchable terms> 
# */
proc bitstreamRun {} {
   variable verbose   
   if {$verbose} { puts "completer_helper.bitstreamRun"; }
   
   # test if there is already a bitstream
   set status [get_property status [current_run]]
   set implementationCompleteMessage "route_design Complete!"
   set bitstreamCompleteMessage      "write_bitstream Complete!"     
   set bitstreamErrorMessage         "write_bitstream ERROR"   

   if {[strsame $status $bitstreamErrorMessage]} { }   
    
   if {[strcmp $status $bitstreamCompleteMessage] != 0} {      
     launch_runs impl_1 -to_step write_bitstream -jobs 4
      if {$verbose} { puts "\twaiting for bitstream generation to complete"; }
      wait_on_run impl_1
   } else {
     puts "Bitstream has already been run!"
   }
      
   markLastStep bitstreamRun
}
# current limitations: only works for ZC702 and Zed boards due to part selection
#/**
# * proc:  hardwareManagerOpen
# * descr: 
# * @meta <list of searchable terms> 
# */
proc hardwareManagerOpen {} {
   variable tcName
   variable trainingPath
   variable blockDesignName
   variable verbose   
   if {$verbose} { puts "completer_helper.hardwareManagerOpen"; }
   
   open_hw;             # open the hardware manager
   connect_hw_server;   #
   open_hw_target;      #
   set_property PROGRAM.FILE {$trainingPath/training/$tcName/lab/$tcName.runs/impl_1/$blockDesignName.bit} [get_hw_devices xc7z020_1]
   set_property PROBES.FILE {$trainingPath/training/$tcName/lab/$tcName.runs/impl_1/$blockDesignName.ltx} [get_hw_devices xc7z020_1]
   set_property FULL_PROBES.FILE {$trainingPath/training/$tcName/lab/$tcName.runs/impl_1/$blockDesignName.ltx} [get_hw_devices xc7z020_1]
   current_hw_device [get_hw_devices xc7z020_1]
   refresh_hw_device [lindex [get_hw_devices xc7z020_1] 0]
   display_hw_ila_data [ get_hw_ila_data hw_ila_data_1 -of_objects [get_hw_ilas -of_objects [get_hw_devices xc7z020_1] -filter {CELL_NAME=~"embd_dsgn_i/ila_0"}]]
   
   markLastStep hardwareManagerOpen
}
#
# ***** export design (local to project)
#
#/**
# * proc:  designExport
# * descr: 
# * @meta <list of searchable terms> 
# */
proc designExport {} {
   variable tcName
   variable trainingPath
   variable blockDesignName
   variable verbose   
   if {$verbose} { puts "completer_helper.designExport"; }
   
   # create the directory to share with SDK
   file mkdir $trainingPath/training/$tcName/lab/$tcName.sdk
   
   # copy the system definition over to the SDK workspace
   set sysDefPath ""
   append sysDefPath $trainingPath/training/$tcName/lab/$tcName.runs/impl_1/$blockDesignName _wrapper.sysdef
   set hdfPath ""
   append hdfPath $trainingPath/training/$tcName/lab/$tcName.sdk/$blockDesignName _wrapper.hdf
   file copy -force $sysDefPath $hdfPath 

   markLastStep designExport
   
#file copy -force $trainingPath/training/HWSW_Xdebug/lab/HWSW_Xdebug.runs/impl_1/embd_dsgn_wrapper.sysdef $trainingPath/training/HWSW_Xdebug/lab/HWSW_Xdebug.sdk/embd_dsgn_wrapper.hdf
#launch_sdk -workspace $trainingPath/training/HWSW_Xdebug/lab/HWSW_Xdebug.sdk -hwspec $trainingPath/training/HWSW_Xdebug/lab/HWSW_Xdebug.sdk/embd_dsgn_wrapper.hdf
}
#
# ***** launch SDK
#
#/**
# * proc:  SDKlaunch
# * descr: 
# * @meta <list of searchable terms> 
# */
proc SDKlaunch {} {
   variable tcName
   variable trainingPath
   variable blockDesignName
   variable verbose   
   if {$verbose} { puts "in launchSDK"; }

   set hdfPath ""
   append hdfPath $trainingPath/training/$tcName/lab/$tcName.sdk/$blockDesignName _wrapper.hdf
   launch_sdk -workspace $trainingPath/training/$tcName/lab/$tcName.sdk -hwspec $hdfPath
   
   markLastStep SDKlaunch
}
#
# ***** close vivado project
#
#/**
# * proc:  VivadoCloseProject
# * descr: 
# * @meta <list of searchable terms> 
# */
proc VivadoCloseProject {} {
   variable verbose
   if {$verbose} { puts "in VivadoCloseProject"; }
   
   close_project;
   
   markLastStep VivadoCloseProject
}
#
# ***** closeVivado
#
#/**
# * proc:  VivadoClose
# * descr: 
# * @meta <list of searchable terms> 
# */
proc VivadoClose {} { exit; }
#
# assumes that make contains the buildStartingPoint state
#/**
# * proc:  buildStartingPoint
# * descr: 
# * @meta <list of searchable terms> 
# */
proc buildStartingPoint {} { make buildStartingPoint }
#
# future: 2017.1
# make stopAfterStep
#    requires a list of list named "stepList"
#       structure is as follows: each list within stepList is a list of procs to be called
#    example of a lab which is comprised of 3 steps
#    
# 
# set stepList {{step1_instruction1 step1_instruction2 step1_instruction3}\
              # {step2_instruction1}\
              # {step3_instruction1 step3_instruction2 step3_instruction3 step3_instruction4 step3_instruction5 step3_instruction6}
          # }
set debug 1        
#deprecated for 2017.3 proc make {stopAfterStep} { makeTo $stopAfterStep; }
#deprecated for 2017.3 proc makeToEndOfStep {stopAfterStep} { makeTo $stopAfterStep; }
#deprecated for 2017.3 proc makeTo {stopAfterStep} {
#
# makeStep only builds the specified step (unlike make which builds upto and including that step)
#/**
# * proc:  makeStep
# * descr: 
# * @meta <list of searchable terms> 
# * @param stepToDo  
# */
proc makeStep {stepToDo} {
   variable verbose;
   if { $verbose } { puts "completer_helper.makeStep $stepToDo" }
   variable stepList;
   variable debug;
   
   # subtract one as the list begins at 0 and users will start at 10
   set stepToDo [expr $stepToDo - 1]
   # is it a legal step?
   set nSteps [llength $stepList]
   puts "nSteps = $nSteps"
   if {[llength $stepList] >= $stepToDo} {
     # extract the instruction list from the stepList
    set theseInstructions [lindex $stepList $stepToDo]
    if {$debug} { puts "iterating step $stepToDo which consists of the following instructions: $theseInstructions"; }
       
    # loop through the instructions included in this step
    for {set j 0} {$j < [llength $theseInstructions]} {incr j} {
       set hasArguments 0
       set thisInstruction [lindex $theseInstructions $j]
      puts "running this instruction: Step $theseInstructions.$thisInstruction"
      # separate out the arguments if present
      if {[strContains $theseInstructions (]} {
         set hasArguments 1
         # extract just the instruction
         set instructionEndPos [string first ( $thisInstruction]
         set instruction [string range $thisInstruction 0 [expr $instructionEndPos - 1]]
         if {$debug} { puts "the instruction itself is just $instruction"; }
         # loop until closing parenthesis is found
         set remainingArgList [string range $thisInstruction [expr $instructionEndPos + 1] [string length $thisInstruction]]
         set thisInstruction $instruction
         while {[string length $remainingArgList] > 0} {
            set next [nextTerminator $remainingArgList]
           set thisArg [string range $remainingArgList 0 [expr $next - 1]]
           if {$debug} { puts "just extracted the following argument: $thisArg"; }
           append thisInstruction " " $thisArg
           if {$debug} { puts "building the string to run: $thisInstruction"; }
           set remainingArgList [string range $remainingArgList [expr $next + 1] [string length $remainingArgList]]
         }           
      }
      # debug: may need to handle instructions with arguments differently...
      if {$debug} { puts "Attempting to launch the following instruction: $thisInstruction"; }
      if {$hasArguments} {
         eval $thisInstruction
      } else {
         $thisInstruction
      }
      if {$debug} { puts "done running the instruction, on to the next..."; }
    }      
   } else {
      puts "Invalid step number: $stepToDo"
   }
   
  markLastStep makeStep;
}
#/**
# * proc:  make
# * descr: 
# * @meta <list of searchable terms> 
# * @param stopAfterStep  
# */
proc make {stopAfterStep} {
   variable verbose;
   if { $verbose } { puts "completer_helper.make $stopAfterStep" }
   variable stepList;
   variable debug;
            
   if {[strsame $stopAfterStep all]} {
      set stopAtStepN [llength $stepList]
      if {$debug} { 
         puts "All detected. Changed to stop after step number $stopAtStepN. This includes all instructions within each step."
      }
   } else {
      # what is the number of the step to stop after?
      set stopAtStepN [extractIntegerFromString $stopAfterStep]
      if {$debug} { puts "stopping after $stopAtStepN";}
   }
   
   # is stopAfterStep within the total number of available taskLists?
   if {[llength $stepList] >= $stopAtStepN} {                          
      # process all tasks for all the lists below and including this stepList (that is, loop through all selected steps)
      for {set i 0} {$i < $stopAtStepN} {incr i} {
             
         # extract the instruction list from the stepList
         set theseInstructions [lindex $stepList $i]
         if {$debug} { puts "iterating step [expr $i + 1] which consists of the following instructions: $theseInstructions"; }
                         
         # loop through the instructions included in this step
         for {set j 0} {$j < [llength $theseInstructions]} {incr j} {
            set hasArguments 0
            set thisInstruction [lindex $theseInstructions $j]
            puts "running this instruction: Step [expr $i+1].[expr $j+1]:$thisInstruction"
         set commandAndArgumentString ""
         
            # separate out the arguments if present
            if {[strContains $theseInstructions (]} {
              set hasArguments 1
               # extract just the instruction
               set instructionEndPos [string first ( $thisInstruction]
               set instruction [string range $thisInstruction 0 [expr $instructionEndPos - 1]]
            append commandAndArgumentString $instruction " {"; # start building the special command and argument string 
               if {$debug} { puts "the instruction itself is just $instruction and the under-construction cmd and arg is $commandAndArgumentString"; }
               # loop until closing parenthesis is found
               set remainingArgList [string range $thisInstruction [expr $instructionEndPos + 1] [string length $thisInstruction]]
               while {[string length $remainingArgList] > 0} {
                  set next [nextTerminator $remainingArgList]
                  set thisArg [string range $remainingArgList 0 [expr $next - 1]]
                  if {$debug} { puts "just extracted the following argument: $thisArg"; }
              append commandAndArgumentString " " $thisArg; # append this argument to the string under construction
                  if {$debug} { puts "building the string to run: $thisInstruction"; }
                  set remainingArgList [string range $remainingArgList [expr $next + 1] [string length $remainingArgList]]
                }    
               append commandAndArgumentString " }";     # close the list           
            }
            # debug: may need to handle instructions with arguments differently...
            if {$debug} { puts "Attempting to launch the following instruction: $thisInstruction"; }
         if {$debug} { puts "Attempting to launch the following command and argument: $commandAndArgumentString"; }
            if {$hasArguments} {
            eval $commandAndArgumentString
            } else {
               $thisInstruction
            }
            if {$debug} { puts "done running the instruction, on to the next..."; }
          }
                            
          doneWithStep [expr $i + 1]
        }
    } else {
       puts "Specify the level to which you want the lab re-built to:";
       puts "   n | Sn | Stepn - builds to the end of Step n (<[llength $stepList])"
       puts "   All - builds all steps"
    }
}
#/**
# * proc:  nextTerminator
# * descr: 
# * @meta <list of searchable terms> 
# * @param str  
# */
proc nextTerminator {str} {
   set nextCommaPos    [string first , $str]
   set closingParenPos [string first ) $str]
   
   # if there is no comma or closing parenthesis, then we have a problem!
   if {$nextCommaPos < 0 && $closingParenPos < 0} {
      puts "missing closing parenthesis!"
   } else {
   
      # is there a comma?
      if {$nextCommaPos > -1} {
         #set rtnStr [string range $str 0 $nextCommaPos]
       return $nextCommaPos
      } else {
         # no commas remain therefore this must close with a parenthesis
        #set rtnStr [string range 0 $closingParenPos]
       return $closingParenPos
      }
   }
   return -1;
}
#
# *** Clear everything from the canvas
#
#/**
# * proc:  clearAll
# * descr: 
# * @meta <list of searchable terms> 
# */
proc clearAll {} {
   delete_bd_objs [get_bd_nets *]
   delete_bd_objs [get_bd_intf_ports *]
   delete_bd_objs [get_bd_ports *]
   delete_bd_objs [get_bd_cells *]
}


if ($debug) {
   puts "Done with load of completer_helper.tcl";
}
