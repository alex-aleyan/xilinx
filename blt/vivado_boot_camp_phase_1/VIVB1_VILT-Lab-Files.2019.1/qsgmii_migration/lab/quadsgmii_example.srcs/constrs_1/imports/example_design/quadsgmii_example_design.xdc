
#***********************************************************
# The following constraints target the Transceiver Physical*
# Interface which is instantiated in the Example Design.   *
#***********************************************************

#-----------------------------------------------------------
# Transceiver I/O placement:                               -
#-----------------------------------------------------------

# Place the transceiver components, chosen for this example design
# *** These values should be modified according to your specific design ***
set_property LOC GTXE2_CHANNEL_X0Y10 [get_cells */*/*/transceiver_inst/gtwizard_inst/*/GTWIZARD_i/gt0_GTWIZARD_i/gtxe2_i]

#-----------------------------------------------------------
# Clock source used for the IDELAY Controller (if present) -
# and for the transceiver reset circuitry                  -
#-----------------------------------------------------------

create_clock -add -name independent_clock -period 5.000 [get_ports independent_clock]

#-----------------------------------------------------------
# PCS/PMA Clock period Constraints: please do not relax    -
#-----------------------------------------------------------

create_clock -add -name gtrefclk -period 8.000 [get_ports gtrefclk_p]


set_false_path -from [get_clocks independent_clock] -to [get_clocks [list gtrefclk]]
set_false_path -from [get_clocks gtrefclk] -to [get_clocks [list independent_clock]]



#-----------------------------------------------------------
# Transceiver I/O placement:                               -
#-----------------------------------------------------------

#set_property LOC H6 [get_ports gtrefclk_p]
#set_property LOC H5 [get_ports gtrefclk_n]


set_false_path -through [get_pins */*/pma_reset_pipe_reg[0]/Q] -to [get_pins */*/pma_reset_pipe_reg[1]/D]







#-----------------------------------------------------------
# GMII Receiver Constraints:  place flip-flops in IOB      -
#-----------------------------------------------------------

