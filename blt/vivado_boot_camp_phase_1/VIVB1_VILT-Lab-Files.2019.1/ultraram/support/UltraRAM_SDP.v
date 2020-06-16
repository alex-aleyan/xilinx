`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/21/2016 12:36:29 PM
// Design Name: 
// Module Name: UltraRAM_SDP
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module UltraRAM_SDP
(
// Port A module ports
input  wire                                               clka,
input  wire                                               rsta,
input  wire                                               ena,
input  wire                                               wea,
input  wire [20:0]                                        addra,
input  wire [71:0]                                        dina,

// Port B module ports
input  wire                                               clkb,
input  wire                                               rstb,
input  wire                                               enb,
input  wire                                               regceb,
input  wire [20:0]                                        addrb,
output wire [71:0]                                        doutb
 );


//Instantiate the Simple Dual Port UltraRAM memoy using XPM here

endmodule