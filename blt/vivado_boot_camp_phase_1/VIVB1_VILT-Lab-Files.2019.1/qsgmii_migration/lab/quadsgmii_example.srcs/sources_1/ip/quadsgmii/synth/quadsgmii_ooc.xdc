# This constraints file contains default clock frequencies to be used during 
# out-of-context flows such as OOC Synthesis and Hierarchical Designs. 
# For best results the frequencies should be modified to match the target 
# frequencies. 
# This constraints file is not used in normal top-down synthesis (the 
# default flow of Vivado)

#################
#DEFAULT CLOCK CONSTRAINTS

############################################################
# Clock Period Constraints                                 #
############################################################

#-----------------------------------------------------------
# Clock source used for the IDELAY Controller (if present) -
# and for the transceiver reset circuitry                  -
#-----------------------------------------------------------

create_clock -name independent_clock_bufg -period 5.000 [get_ports independent_clock_bufg]

create_clock -name gt0_drpclk_in -period 8.000 [get_ports gt*drpclk*]


#-----------------------------------------------------------
# PCS/PMA Clock period Constraints: please do not relax    -
#-----------------------------------------------------------

create_clock -name gtrefclk -period 8.000 [get_ports gtrefclk]
#-----------------------------------------------------------
# PCS/PMA Clock period Constraints: please do not relax    -
#-----------------------------------------------------------

create_clock -name userclk -period 8.000 [get_ports userclk]
create_clock -name userclk2 -period 8.000 [get_ports userclk2]

#----------------------------------------------------------
# GT Common clock constraints 
#----------------------------------------------------------
 
create_clock -name gt0_qplloutclk_in -period 8.000 [get_ports gt0_qplloutclk_in]
create_clock -name gt0_qplloutrefclk_in -period 8.000 [get_ports gt0_qplloutrefclk_in]

