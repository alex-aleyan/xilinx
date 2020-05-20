`ifndef _SIMULATION
  `define _SIMULATION 1
`endif

//`include "./../src/pkgs/inet_stack_pkg.sv"
//`include "interface_pkg.sv"

// import inet_stack_pkg::*;

module my_and_gate
    #(
      parameter INPUT_WIDTH  = 8
    )
    (
      // Inputs:
      input clock_in,
      input reset_n_in,
      input [(INPUT_WIDTH-1):0] a_in,
      input [(INPUT_WIDTH-1):0] b_in,
  
      output [(INPUT_WIDTH ):0] c_out
    );

logic [INPUT_WIDTH:0] c_reg;

    always_ff @ (posedge clock_in)
    begin
    
        if (~reset_n_in) begin
            c_reg <= '0;
        end else begin
            c_reg <= a_in & b_in;
        end
    
    end

assign c_out = c_reg;

endmodule
