//Alex Aleyan

`ifndef _CLOCK_PERIOD
  `define _CLOCK_PERIOD 5
`endif
`ifndef _HALT
  `define _HALT 2500
`endif

`ifndef _FSM_COUNTER_SPAN
  `define _FSM_COUNTER_SPAN 25000000
`endif
`ifndef _FSM_WAIT_TO_INIT
  `define _FSM_WAIT_TO_INIT 50
`endif
`ifndef _FSM_WAIT_SEND_AGAIN
  `define _FSM_WAIT_SEND_AGAIN 50000000
`endif

//`ifndef _SIMULATION
//  `define _SIMULATION 1
//`endif

`ifndef _COMPILE_TYPE
  localparam _COMPILE_TYPE = 0;
`else
  localparam _COMPILE_TYPE = 1;
`endif

// `include "./../src/pkgs/inet_stack_pkg.sv"
`include "./../src/pkgs/interface_pkg.sv"

module tse_controller_tb;

localparam BRIDGE_DATA_WIDTH = 32;

logic clock, start,reset_n_xR,waitrequest; // always unsigned!
logic [511:0] write_data_512 [5];// = 'habcd_ef00;


AvalonST #(
    .DATA_WIDTH(32)
  )
  avalon_st_bus ( /*no ports*/ );


IAvalonMM #(
    .ADDRESS_WIDTH(8),
    .DATA_WIDTH(32)
  )
  avalon_mm_bus( /* no ports */ );


tse_controller #(
    //._SIMULATION(`_SIMULATION),
    //  ._COMPILE_TYPE(`_COMPILE_TYPE),
    /*parameter MTU_WIDTH          = 16,
      parameter SPEED_SENSOR_WIDTH = 16,
      parameter ADC_WIDTH          = 16,
      
      parameter TSE_TX_ST_DATA_WIDTH = 32,
      parameter TSE_CONTROL_MM_ADDRESS_WIDTH = 8,
      parameter TSE_CONTROL_MM_DATA_WIDTH = 32, */

      .FSM_COUNTER_SPAN(`_FSM_COUNTER_SPAN),       // parameter FSM_COUNTER_SPAN = 250000000,
      .FSM_WAIT_TO_INIT(`_FSM_WAIT_TO_INIT),       // parameter FSM_WAIT_TO_INIT = 5,
      .FSM_WAIT_SEND_AGAIN(`_FSM_WAIT_SEND_AGAIN)  // parameter FSM_WAIT_SEND_AGAIN = 5,

    /*parameter LINK_LAYER_BYTES = 16,
      parameter IP_LAYER_BYTES   = 20,
      parameter UDP_LAYER_BYTES  = 8,
      parameter DATA_LAYER_BYTES = 24 */
    ) dut_1 (
      .Clock_xCI(clock),
      .Reset_xSI(reset_n_xR),
      .Send_Packet_xSI(start),

      .Mtu_xDI( 16'h06),
      .Speed_Sensor_xDI(speed_sensor_driver),
      .Adc_xDI(adc_driver),

      // Avalon-ST Master:
      .Avalon_ST_Source(avalon_st_bus.Source),

      // Avalon-MM Master:
      .Avalon_MM_Master(avalon_mm_bus.Master)
    );



initial
begin
  #1   reset_n_xR = 'b1;
  #150 reset_n_xR = 'b0;
  #20  reset_n_xR = 'b1;

  #50;
  for(int j=0;j<5;j=j+1) begin
    for(int i=0;i<16;i=i+1) begin
      write_data_512[j][i*BRIDGE_DATA_WIDTH+:BRIDGE_DATA_WIDTH] = 'hadd00000 + i + (j*16);
      $display("Time: %t; set write_data_512[%d][%d %d] %x", $time, j, i*BRIDGE_DATA_WIDTH+32-1, i*BRIDGE_DATA_WIDTH, write_data_512[j][i*BRIDGE_DATA_WIDTH+:BRIDGE_DATA_WIDTH]);
    end
  end
  #50 start=1;
  #1  start=0;
end




    

    

endmodule

