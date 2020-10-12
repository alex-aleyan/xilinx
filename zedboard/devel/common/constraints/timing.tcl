set REFCLK_PERIOD 10; # specified period must be <= to actual periond

create_clock -period $REFCLK_PERIOD -name clk_33_mhz [get_ports GCLK]
