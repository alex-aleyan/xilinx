# This script will form the basis of a repeatable, scripted build process
# that can be used to generate complete projects. 
#
# While completely scripted, the end result is an Vivado project that can be
# viewed and even manipulated by the Vivado IDE.
#
# This script will
#   - Create a new directory for the build
#      - the name will be build_YYMMDD_HHMMSS where YYMMDD_HHMMSS is the 
#        current time
#   - Change directory into that directory
#   - Create a new Vivado project
#   - Set the main project properties for the target device
#   - Load all the # source files
#   - Set appropriate process properties
#   - Implement the design   
#

# Get the current date/time. The result is a machine readable version of the 
# the date/time (number of seconds since the epoch started)
#set time_raw [clock seconds];
# Format the raw time to a date string
#set date_string [clock format $time_raw -format "%y%m%d_%H%M%S"]
set date_string [clock format [clock seconds] -format "%y%m%d_%H%M%S"]

# Set the directory name to be build_YYMMDD_HHMMSS
set proj_dir "build_$date_string"

# Create the new build directory
puts "Creating build directory $proj_dir"
file mkdir $proj_dir
#file delete REMOVEME_DIR

# The remaining TCL scripts live in this directory. Remember
# the path before we change directories
set script_dir [pwd]/tcl
set xdc_dir    [pwd]/constraints
set src_dir    [pwd]
set core_dir   [pwd]

set device xc7z020clg484-1
set project_name zedboard_base_proj

set constrs_name constrs_1
set xdc_filename zedboard_master_XDC_RevC_D_v3.xdc
set synth_name synth_1
set impl_name impl_1

# Change directories to the new build directory
puts "Changing directory to $proj_dir"
cd $proj_dir

start_gui

# Source the script that will create the new project
source $script_dir/create_proj.tcl

# Source the script that will imports all the files required for the build
source $script_dir/load_files.tcl

# Source the script that will set all the process properties necessary
source $script_dir/set_props.tcl

# Build the ZedBoard PS:
#source $script_dir/create_zedboard_ps.tcl

# Source the script that will regenerate the cores and run the implementation
# process
#source $script_dir/implement.tcl

#exit