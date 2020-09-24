# Synthesize and Implement the design 

puts "synthesizing the design"
# Insert the command to launch synthesis run here 
launch_runs synth_1

puts "wait until synthesis done"
# Insert the command to wait on synth_1 run here 
wait_on_run synth_1

puts "Implementing the design"
#launch_runs impl_1
launch_runs impl_1 -to_step write_bitstream -jobs 2

puts "wait until Implementation done"
wait_on_run impl_1

#launch_runs impl_1 -to_step write_bitstream -jobs 2

#wait_on_run impl_1
