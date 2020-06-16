# Global timing constraints
create_clock -period 3.333 -name clk_pin_p -waveform {0.000 1.666} [get_ports clk_pin_p]

create_generated_clock -name spi_clk -source [get_pins dac_spi_i0/out_ddr_flop_spi_clk_i0/ODDR_inst/C] -divide_by 1 -invert [get_ports spi_clk_pin]

set_input_delay  -clock clk_pin_p            0.8   [get_ports {rst_pin}]
set_input_delay  -clock clk_pin_p      -min 0.5 [get_ports {rst_pin}]

create_clock -period 5.161 -name clk_tx_virtual -waveform {0.000 2.580}

set_input_delay  -clock clk_tx_virtual       1   [get_ports {lb_sel_pin}]
set_input_delay  -clock clk_tx_virtual -min 0.5 [get_ports {lb_sel_pin}]

create_clock -period 5.000 -name clk_rx_virtual -waveform {0.000 2.500}
set_input_delay  -clock clk_rx_virtual            1   [get_ports {rxd_pin}]
set_input_delay  -clock clk_rx_virtual      -min 0.5 [get_ports {rxd_pin}]

set_output_delay -clock clk_tx_virtual       1.25   [get_ports {txd_pin led_pins[*]} ]
set_output_delay -clock clk_tx_virtual -min  0.5 [get_ports {txd_pin led_pins[*]} ]

# Path specific timing constraints


set_output_delay -clock [get_clocks spi_clk] -max  1 [get_ports {spi_mosi_pin dac_cs_n_pin dac_clr_n_pin}]
set_output_delay -clock [get_clocks spi_clk] -min 0.2 [get_ports {spi_mosi_pin dac_cs_n_pin dac_clr_n_pin}]

set_multicycle_path -from [get_cells {cmd_parse_i0/send_resp_data_reg[*]}] -to [get_cells {resp_gen_i0/to_bcd_i0/bcd_out_reg[*]}] 2
set_multicycle_path -from [get_cells {cmd_parse_i0/send_resp_data_reg[*]}] -to [get_cells {resp_gen_i0/to_bcd_i0/bcd_out_reg[*]}] -hold 1

set_multicycle_path -from [get_cells "uart_rx_i0/uart_rx_ctl_i0/*" -filter {IS_SEQUENTIAL == 1}] -to [get_cells "uart_rx_i0/uart_rx_ctl_i0/*" -filter {IS_SEQUENTIAL == 1}] 108 
set_multicycle_path -from [get_cells "uart_rx_i0/uart_rx_ctl_i0/*" -filter {IS_SEQUENTIAL == 1}] -to [get_cells "uart_rx_i0/uart_rx_ctl_i0/*" -filter {IS_SEQUENTIAL == 1}] -hold 107 

set_multicycle_path -from [get_cells "uart_tx_i0/uart_tx_ctl_i0/*" -filter {IS_SEQUENTIAL == 1}] -to [get_cells "uart_tx_i0/uart_tx_ctl_i0/*" -filter {IS_SEQUENTIAL == 1}] 105 
set_multicycle_path -from [get_cells "uart_tx_i0/uart_tx_ctl_i0/*" -filter {IS_SEQUENTIAL == 1}] -to [get_cells "uart_tx_i0/uart_tx_ctl_i0/*" -filter {IS_SEQUENTIAL == 1}] -hold 104 

create_generated_clock -name clk_samp -source [get_pins {clk_gen_i0/BUFGCE_clk_samp_i0/I}] -divide_by 32 [get_pins {clk_gen_i0/BUFGCE_clk_samp_i0/O}]

set_max_delay -from clkx_nsamp_i0/meta_harden_bus_new_i0/signal_meta_reg            -to clkx_nsamp_i0/meta_harden_bus_new_i0/signal_dst_reg 2 
set_max_delay -from clkx_pre_i0/meta_harden_bus_new_i0/signal_meta_reg              -to clkx_pre_i0/meta_harden_bus_new_i0/signal_dst_reg 2 
set_max_delay -from clkx_spd_i0/meta_harden_bus_new_i0/signal_meta_reg              -to clkx_spd_i0/meta_harden_bus_new_i0/signal_dst_reg 2 
set_max_delay -from lb_ctl_i0/debouncer_i0/meta_harden_signal_in_i0/signal_meta_reg -to lb_ctl_i0/debouncer_i0/meta_harden_signal_in_i0/signal_dst_reg 2 
set_max_delay -from samp_gen_i0/meta_harden_samp_gen_go_i0/signal_meta_reg          -to samp_gen_i0/meta_harden_samp_gen_go_i0/signal_dst_reg 2 
set_max_delay -from uart_rx_i0/meta_harden_rxd_i0/signal_meta_reg                   -to uart_rx_i0/meta_harden_rxd_i0/signal_dst_reg 2 

set_max_delay -from rst_gen_i0/reset_bridge_clk_rx_i0/rst_meta_reg                  -to rst_gen_i0/reset_bridge_clk_rx_i0/rst_dst_reg 2 
set_max_delay -from rst_gen_i0/reset_bridge_clk_tx_i0/rst_meta_reg                  -to rst_gen_i0/reset_bridge_clk_tx_i0/rst_dst_reg 2 
set_max_delay -from rst_gen_i0/reset_bridge_clk_samp_i0/rst_meta_reg                -to rst_gen_i0/reset_bridge_clk_samp_i0/rst_dst_reg 2 

set_false_path -from [get_ports rst_pin]

# The below constraint is added to resolve timing issues in Vivado 2016.3. The Vivado Placer places MMCM and BUGGCE very far that causes large routing delay and timing failure. This constraint places BUFGCE_clk_samp_i0 in XOY1 clock region i.e., near to MMCM. 
# set_property CLOCK_REGION X0Y1 [get_cells clk_gen_i0/BUFGCE_clk_samp_i0]
set_max_delay 5 -from [get_clocks -of [get_nets clk_rx] ] -to [get_clocks -of [get_nets clk_tx] ] -datapath_only
