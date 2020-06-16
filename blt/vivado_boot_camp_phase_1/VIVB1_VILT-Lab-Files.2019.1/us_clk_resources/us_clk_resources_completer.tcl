###########################################################################
## Clocking Resources Completer Script
###########################################################################

# load the standard helper file
source /home/xilinx/training/completer_helper_script/helper.tcl
source /home/xilinx/training/completer_helper_script/completer_helper.tcl

# project constants
set verbose 	1
set tcName 	us_clk_resources
set demoOrLab 	completed
set projName 	wave_gen


 ## *********** Step 1 : Opening a project, Adding clk_core ***********

proc openProject {} {
variable platform
variable language
variable tcName
variable demoOrLab 
variable projName 
variable trainingPath

# Add the platform and language combination that you want 
set isLangNotSelected [string compare -nocase $language "undefined"]
set isPlatNotSelected [string compare -nocase $platform "undefined"]
   
if {$isLangNotSelected} {
      puts "Please type: use VHDL | Verilog"
      puts "   then rerun the projectCreate"
}
if {$isPlatNotSelected} {
      puts "Please type: use KCU105 | KC705 | KC7xx"
      puts "   then rerun the projectCreate"
}

# Open a project
set projName.xpr {append $projName .xpr}
open_project $trainingPath/training/$tcName/$demoOrLab/$platform/$language/$projName.xpr

set projName.srcs {append $projName .srcs}
create_ip -name clk_wiz -vendor xilinx.com -library ip -version 6.0 -module_name clk_core -dir $trainingPath/training/$tcName/$demoOrLab/$platform/$language/$projName.srcs/sources_1/ip

set_property -dict [list CONFIG.PRIM_SOURCE {Differential_clock_capable_pin} CONFIG.PRIM_IN_FREQ {300.000} CONFIG.CLKOUT2_USED {true} CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {200.000} CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {193.750} CONFIG.CLKOUT1_DRIVES {BUFG} CONFIG.CLKOUT2_DRIVES {No_buffer} CONFIG.CLKIN1_JITTER_PS {33.330000000000005} CONFIG.FEEDBACK_SOURCE {FDBK_AUTO} CONFIG.MMCM_DIVCLK_DIVIDE {3} CONFIG.MMCM_CLKFBOUT_MULT_F {7.750} CONFIG.MMCM_CLKIN1_PERIOD {3.333} CONFIG.MMCM_CLKIN2_PERIOD {10.0} CONFIG.MMCM_CLKOUT0_DIVIDE_F {3.875} CONFIG.MMCM_CLKOUT1_DIVIDE {4} CONFIG.NUM_OUT_CLKS {2} CONFIG.CLKOUT1_JITTER {121.978} CONFIG.CLKOUT1_PHASE_ERROR {113.618} CONFIG.CLKOUT2_JITTER {122.721} CONFIG.CLKOUT2_PHASE_ERROR {113.618}] [get_ips clk_core]
generate_target {instantiation_template} [get_files $trainingPath/training/$tcName/$demoOrLab/$platform/$language/$projName.srcs/sources_1/ip/clk_core/clk_core.xci]
generate_target all [get_files  $trainingPath/training/$tcName/$demoOrLab/$platform/$language/$projName.srcs/sources_1/ip/clk_core/clk_core.xci]

#launch_runs  clk_core_synth_1
}


 ## *********** Step 2 : Instantiate the clk_core or the buffer ***********

proc copyCompletedSourceCode {} {
	variable platform
	variable language
	variable tcName
	variable demoOrLab 
	variable projName 
	variable fileName
	variable trainingPath

	set completedfilePath $trainingPath/training/$tcName/support/completed_files
    	set projName.srcs {append $projName .srcs}
	set path $trainingPath/training/$tcName/$demoOrLab/$platform/$language/$projName.srcs/sources_1/imports/support
	
	# load all the completed file as the working file
	
	if {$language == "vhdl"} { 
		file copy -force $completedfilePath/clk_gen.vhd $path/clk_gen.vhd
	} elseif {$language == "verilog"} { 
		file copy -force $completedfilePath/clk_gen.v $path/clk_gen.v
	}
}


 ## *********** Step 3 : Implement and verify the design ***********
 ## *********** Step 4 : Examine the clocking resources ***********

proc impl_genReport {} {

# Calling the proc which runs implementation
implementationRun

report_utilization -name utilization_1
}


 ## ********** Running only the steps that are required with Make **************

proc make {stopAt} {

   puts "Running until the step $stopAt"
   set limit [string tolower $stopAt]
   switch $limit {
      step1  { openProject }
      step2  { make step1; copyCompletedSourceCode }
      step3  { make step2; impl_genReport }
      all    { make step3 }
      default { 
         puts "Call the make proc, Should be make step*" 
			  }	
	}	
}
