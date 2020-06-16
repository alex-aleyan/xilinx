`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/27/2017 10:23:41 PM
// Design Name: 
// Module Name: Squaring
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

    // This module implements a parameterizable (a-b) squarer
    // which can be implemented in a DSP48E2(ultrascale) by using the pre-adder
    // The size should be less than or equal to what is supported
    // by the architecture
      

module Squaring #(parameter SIZEIN = 16)
(input clk, ce, rst,input [SIZEIN-1:0] a, b, output [2*SIZEIN+1:0] square_out  );

//Paste the copied text from Language Templates here              
                    
endmodule
