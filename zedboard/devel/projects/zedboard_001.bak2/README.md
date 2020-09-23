
Step 1: follow the lab to fix these scripts:
    support/do_build.tcl
    support/create_proj.tcl

Step 2(Optional): skip step 3-4 if using this step:
    vivado -mode batch -source support/do_build.tcl

    Step 3: run the script to build a project
        from CLI:    
            vivado -mode tcl -source support/do_build.tcl
        from vivado: 
            source support/do_build

    Step 4: open the created project in GUI:
        Vivado% start_gui
        Vivado% open_project
        Vivado% stop_gui


