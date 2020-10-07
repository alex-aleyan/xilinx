This is a hello world project which directly connect FPGA SWs to FPGA LEDs

Familiarize yourself with the project by reviewing the top file:
    ./zedboard_top.vhd

Board constrains:
    constraints/zedboard_master_XDC_RevC_D_v3.xdc


Step 1(Optional): skip step 2-3 if using this step:
    vivado -mode batch -source do_build.tcl

Step 2: run the script to build a project
    from CLI:    
        vivado -mode tcl
        source do_build.tcl
    from vivado: 
        vivado
        source do_build.tcl

Step 3: open the created project in GUI:
    Vivado% start_gui
    Vivado% open_project
    Vivado% stop_gui


