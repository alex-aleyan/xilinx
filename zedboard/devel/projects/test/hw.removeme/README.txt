To simulate:
    1. Run syn/generateqsys.ln
    2. Run sim/RunSim.ln
  
To use the programmed board:
  1. Connect ETHERNET1 port to a laptop with the wireshark running or to ETHERNET0 (used in loop back mode).
  2. Used KEY(0) to reset
  3. Use KEY(1) to send a packet, or shift the SW[16] to the on position to send continuously.
  4. Use SW(15 downto 0 ) to set the MTU in the number of Data bytes
