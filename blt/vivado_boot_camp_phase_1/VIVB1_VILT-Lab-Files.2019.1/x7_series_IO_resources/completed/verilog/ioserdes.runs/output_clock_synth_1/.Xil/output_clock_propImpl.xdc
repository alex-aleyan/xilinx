set_property SRC_FILE_INFO {cfile:c:/training/7_series_IO_resources/completed/verilog/ioserdes.srcs/sources_1/ip/output_clock/output_clock_ooc.xdc rfile:../../../ioserdes.srcs/sources_1/ip/output_clock/output_clock_ooc.xdc id:1 order:EARLY scoped_inst:inst} [current_design]
current_instance inst
set_property src_info {type:SCOPED_XDC file:1 line:56 export:INPUT save:INPUT read:FILTER_OUT_OF_CONTEXT} [current_design]
set_input_jitter [get_clocks -of_objects [get_ports clk_in]] 0.1
