Step 1(Optional): skip step 2-3 if using this step:
    vivado -mode batch -source do_build.ln

Step 2: run the script to build a project
    from CLI:    
        vivado -mode tcl -source do_build.ln
    from vivado: 
        source do_build.ln

Step 3: open the created project in GUI:
    Vivado% start_gui
    Vivado% open_project
    Vivado% stop_gui


