# This script sets the project variables 

# assign part to device variable
#set device xcku040-ffva1156-2-e
set device xc7z020clg484-1
set project_name zedboard_base_proj

# Create the project
puts "Creating new project."

# Insert the command to create the project here
create_project $project_name -part $device

# Insert the command to set the target language for the project here
set_property target_language VHDL [current_project]
