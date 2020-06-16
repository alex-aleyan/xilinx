
#***********************************************************
# The following constraints target the Transceiver Physical*
# Interface which is instantiated in the Example Design.   *
#***********************************************************

#-----------------------------------------------------------
# PCS/PMA Clock period Constraints: please do not relax    -
#-----------------------------------------------------------

create_clock -period 8.000 [get_pins transceiver_inst/gtwizard_inst/*/GTWIZARD_i/gt0_GTWIZARD_i/gtxe2_i/TXOUTCLK]


set_false_path -to [get_pins -hier -filter { name =~ */gtwizard_inst/*/gt0_txresetfsm_i/sync_*/D } ]
set_false_path -to [get_pins -hier -filter { name =~ */gtwizard_inst/*/gt0_rxresetfsm_i/sync_*/D } ]

set_false_path -to [get_pins -hier -filter { name =~ */gtwizard_inst/*/sync_block_gtrxreset/*D } ]
set_false_path -to [get_pins -hier -filter { name =~ */gtwizard_inst/*/sync_block_gtrxreset/*PRE } ]


## Setting false path for Data Valid
set_false_path -from [get_pins -of [get_cells -hier -filter { name =~ *transceiver_inst/data_valid_reg_reg* } ] -filter { name =~ *C } ] -to [get_pins -of [get_cells -hier -filter { name =~ *transceiver_inst/sync_block_data_valid/data_sync* } ] -filter { name =~ *D } ]

## setting false path for RESET in gigpcspma
set_false_path -to [get_pins -hier -filter {name =~ *SYNC_*/data_sync*/D }]
set_false_path -to [get_pins -hier -filter {name =~ *GPCS_PMA_GEN_i*/MGT_RESET.RESET_INT_*/PRE }]

## timing for MDIO interface
set_max_delay 6.000 -datapath_only -from [get_pins -hier -filter { name =~ */MDIO_INTERFACE_*/MDIO_OUT_reg/C } ]

#-----------------------------------------------------------
# Fabric Rx Elastic Buffer Timing Constraints:             -
#-----------------------------------------------------------

# Clock period for the recovered Rx clock
create_clock -period 8.000 [get_pins transceiver_inst/gtwizard_inst/*/GTWIZARD_i/gt0_GTWIZARD_i/gtxe2_i/RXOUTCLK]


# setting false path for clock domain crossing from txoutclk to rxrecclkoutp
set_false_path -to [get_pins -of [get_cells -hier -filter { name =~ *reclock_rxreset*/RESET_SYNC*} ]  -filter { name =~ *PRE } ]
set_false_path -to [get_pins -of [get_cells -hier -filter { name =~ *rxrecclk_encommaalign/reset_sync*} ]  -filter { name =~ *PRE } ]

# Channel 0 Rx Elastic Buffer
#----------------------------------------------------------
# Identify clock domain crossing registers
# Control Gray Code delay and skew across clock boundary
set_max_delay 6.000 -datapath_only -from [get_pins -of [get_cells -hier -filter {name =~ *RX_ELASTIC_BUFFER_I0/WR_ADDR_GRAY_reg[*] }] -filter { name =~ *C } ] -to [all_registers -edge_triggered]
set_max_delay 6.000 -datapath_only -from [get_pins -of [get_cells -hier -filter {name =~ *RX_ELASTIC_BUFFER_I0/RD_ADDR_GRAY_reg[*] }] -filter { name =~ *C } ] -to [all_registers -edge_triggered]

# Constrain between Distributed Memory (output data) and the 1st set of flip-flops
set_false_path -to  [get_pins -of [get_cells -hier -filter {name =~ *RX_ELASTIC_BUFFER_I0/GEN_FIFO[*].RD_DATA_reg* } ] -filter { name =~ *D } ]

# Channel 1 Rx Elastic Buffer
#----------------------------------------------------------
# Identify clock domain crossing registers
# Control Gray Code delay and skew across clock boundary
set_max_delay 6.000 -datapath_only -from [get_pins -of [get_cells -hier -filter {name =~ *RX_ELASTIC_BUFFER_I1/WR_ADDR_GRAY_reg[*] }] -filter { name =~ *C } ] -to [all_registers -edge_triggered]
set_max_delay 6.000 -datapath_only -from [get_pins -of [get_cells -hier -filter {name =~ *RX_ELASTIC_BUFFER_I1/RD_ADDR_GRAY_reg[*] }] -filter { name =~ *C } ] -to [all_registers -edge_triggered]

# Constrain between Distributed Memory (output data) and the 1st set of flip-flops
set_false_path -to  [get_pins -of [get_cells -hier -filter {name =~ *RX_ELASTIC_BUFFER_I1/GEN_FIFO[*].RD_DATA_reg* } ] -filter { name =~ *D } ]

# Channel 2 Rx Elastic Buffer
#----------------------------------------------------------
# Identify clock domain crossing registers
# Control Gray Code delay and skew across clock boundary
set_max_delay 6.000 -datapath_only -from [get_pins -of [get_cells -hier -filter {name =~ *RX_ELASTIC_BUFFER_I2/WR_ADDR_GRAY_reg[*] }] -filter { name =~ *C } ] -to [all_registers -edge_triggered]
set_max_delay 6.000 -datapath_only -from [get_pins -of [get_cells -hier -filter {name =~ *RX_ELASTIC_BUFFER_I2/RD_ADDR_GRAY_reg[*] }] -filter { name =~ *C } ] -to [all_registers -edge_triggered]

# Constrain between Distributed Memory (output data) and the 1st set of flip-flops
set_false_path -to  [get_pins -of [get_cells -hier -filter {name =~ *RX_ELASTIC_BUFFER_I2/GEN_FIFO[*].RD_DATA_reg* } ] -filter { name =~ *D } ]


# Channel 3 Rx Elastic Buffer
#----------------------------------------------------------
# Identify clock domain crossing registers
# Control Gray Code delay and skew across clock boundary
set_max_delay 6.000 -datapath_only -from [get_pins -of [get_cells -hier -filter {name =~ *RX_ELASTIC_BUFFER_I3/WR_ADDR_GRAY_reg[*] }] -filter { name =~ *C } ] -to [all_registers -edge_triggered]
set_max_delay 6.000 -datapath_only -from [get_pins -of [get_cells -hier -filter {name =~ *RX_ELASTIC_BUFFER_I3/RD_ADDR_GRAY_reg[*] }] -filter { name =~ *C } ] -to [all_registers -edge_triggered]

# Constrain between Distributed Memory (output data) and the 1st set of flip-flops
set_false_path -to  [get_pins -of [get_cells -hier -filter {name =~ *RX_ELASTIC_BUFFER_I3/GEN_FIFO[*].RD_DATA_reg* } ] -filter { name =~ *D } ]


