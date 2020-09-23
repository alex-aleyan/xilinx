`ifndef _FSM_COUNTER_SPAN
  `define _FSM_COUNTER_SPAN 25000000
`endif
`ifndef _FSM_WAIT_TO_INIT
  `define _FSM_WAIT_TO_INIT 50
`endif
`ifndef _FSM_WAIT_SEND_AGAIN
  `define _FSM_WAIT_SEND_AGAIN 50000000
`endif

`include "./../src/pkgs/interface_pkg.sv"

module dynamometer_top(
	// Clock
	input         CLOCK_50,
	
	// KEY
	input  [3:0] KEY,
    input  [17:0] SW,
	
	// Ethernet 0
	output        ENET0_MDC,
	inout         ENET0_MDIO,
	output        ENET0_RESET_N,
	
	// Ethernet 1
	output        ENET1_GTX_CLK,
	output        ENET1_MDC,
	inout         ENET1_MDIO,
	output        ENET1_RESET_N,
	input         ENET1_RX_CLK,
	input  [3: 0] ENET1_RX_DATA,
	input         ENET1_RX_DV,
	output [3: 0] ENET1_TX_DATA,
	output        ENET1_TX_EN
);

IAvalonST #( .DATA_WIDTH(32) ) avalon_st_bus ( /*no ports*/ );

IAvalonMM #( .ADDRESS_WIDTH(8), .DATA_WIDTH(32) ) avalon_mm_bus( /* no ports */ );

logic sys_clk, clk_125, clk_25, clk_2p5, tx_clk;
logic core_reset_n;
logic mdc, mdio_in, mdio_oen, mdio_out;
logic eth_mode, ena_10;

logic start, reset; // always unsigned!


// reg [7:0] data;
// reg [4:0] address;

// // AVALON-ST for Tx 
// wire Tx_Ready_xS;
// wire [1:0]Tx_Error_xS;
// wire Tx_Valid_xS;   
// wire Tx_Sop_xS;      
// wire Tx_Eop_xS;      
// wire Tx_Empty_xS;    
// wire [31:0]Tx_Data_xD;
// 
// /* DMA:
// reg Tx_Ready_dma_xS;
// wire [1:0]Tx_Error_dma_xS;
// wire Tx_Valid_dma_xS;   
// wire Tx_Sop_dma_xS;      
// wire Tx_Eop_dma_xS;      
// wire Tx_Empty_dma_xS;    
// wire [31:0]Tx_Data_dma_xD;   
// */
// 
// /*     
// // AVALON-MM:
// reg Tx_Ready_tseCtrl_xS;
// wire [1:0]Tx_Error_tseCtrl_xS;
// wire Tx_Valid_tseCtrl_xS;   
// wire Tx_Sop_tseCtrl_xS;      
// wire Tx_Eop_tseCtrl_xS;      
// wire Tx_Empty_tseCtrl_xS;    
// wire [31:0]Tx_Data_tseCtrl_xD;
// */
// 
// // AVALON-MM:
// wire [7:0]  Tse_Control_address_xD;
// wire [31:0]	Tse_Control_readdata_xS;
// wire        Tse_Control_read_xS;
// wire [31:0] Tse_Control_writedata_xD;
// wire        Tse_Control_write_xS;
// wire        Tse_Control_waitrequest_xS;

/*
// (DMA | TSE_CONTROLLER) TO PHY MUX:

assign  Tx_Data_xD  = SW[0] ? Tx_Data_dma_xD :  Tx_Data_tseCtrl_xD;
assign  Tx_Sop_xS   = SW[0] ? Tx_Sop_dma_xS   :  Tx_Sop_tseCtrl_xS;
assign  Tx_Eop_xS   = SW[0] ? Tx_Eop_dma_xS   :  Tx_Eop_tseCtrl_xS;
assign  Tx_Empty_xS = SW[0] ? Tx_Empty_dma_xS :  Tx_Empty_tseCtrl_xS;
assign  Tx_Error_xS = SW[0] ? Tx_Error_dma_xS :  Tx_Error_tseCtrl_xS;
assign  Tx_Valid_xS = SW[0] ? Tx_Valid_dma_xS :  Tx_Valid_tseCtrl_xS;

always @(SW[0])
begin
   case( SW[0] )
       0 : Tx_Ready_tseCtrl_xS = Tx_Ready_xS;
       1 : Tx_Ready_tseCtrl_xS = 1'bz;
   endcase
   case( SW[0] )
       0 : Tx_Ready_dma_xS     = 1'bz;
       1 : Tx_Ready_dma_xS     = Tx_Ready_xS;
   endcase
end
*/

/*
assign  Tx_Data_xD  = Tx_Data_tseCtrl_xD;
assign  Tx_Sop_xS   = Tx_Sop_tseCtrl_xS;
assign  Tx_Eop_xS   = Tx_Eop_tseCtrl_xS;
assign  Tx_Empty_xS = Tx_Empty_tseCtrl_xS;
assign  Tx_Error_xS = Tx_Error_tseCtrl_xS;
assign  Tx_Valid_xS = Tx_Valid_tseCtrl_xS;
assign Tx_Ready_tseCtrl_xS = Tx_Ready_xS;
*/

// ARCHITECTURE:

assign mdio_in   = ENET1_MDIO;
assign ENET0_MDC  = mdc;
assign ENET1_MDC  = mdc;
assign ENET0_MDIO = mdio_oen ? 1'bz : mdio_out;
assign ENET1_MDIO = mdio_oen ? 1'bz : mdio_out;

assign ENET0_RESET_N = core_reset_n;
assign ENET1_RESET_N = core_reset_n;

assign reset = ~KEY[2];
assign start = ~KEY[1] | SW[17];
	
my_pll pll_inst(
	.areset	(~KEY[0]),
	.inclk0	(CLOCK_50),
	.c0		(sys_clk),
	.c1		(clk_125),
	.c2		(clk_25),
	.c3		(clk_2p5),
	.locked	(core_reset_n)
); 

assign tx_clk = eth_mode ? clk_125 :       // if       eth_mode = true: use GbE   Mode and set tx_clk=125MHz clock
                ena_10   ? clk_2p5 :       // else if  ena_10   = true: use 10Mb  Mode and set tx_clk=2.5MHz clock
                           clk_25;         // else                    : use 100Mb Mode and set tx_clk=25 MHz clock


my_ddio_out ddio_out_inst(
    .datain_h(1'b1),
    .datain_l(1'b0),
    .outclock(tx_clk),
    .dataout(ENET1_GTX_CLK)
  );



  nios_system system_inst (
      .clk_clk                                   (sys_clk),              // .clk.clk
      .reset_reset_n                             (core_reset_n),         // .reset.reset_n
      
      .tse_pcs_mac_tx_clock_connection_clk 	   (tx_clk), 		       // .eth_tse_0_pcs_mac_tx_clock_connection.clk
      .tse_pcs_mac_rx_clock_connection_clk 	   (ENET1_RX_CLK), 		   // .eth_tse_0_pcs_mac_rx_clock_connection.clk
      
      .tse_mac_mdio_connection_mdc               (mdc),             	   // .tse_mac_mdio_connection.mdc
      .tse_mac_mdio_connection_mdio_in           (mdio_in),              // .mdio_in
      .tse_mac_mdio_connection_mdio_out          (mdio_out),             // .mdio_out
      .tse_mac_mdio_connection_mdio_oen          (mdio_oen),             // .mdio_oen
      
      .tse_mac_rgmii_connection_rgmii_in         (ENET1_RX_DATA),        // .tse_mac_rgmii_connection.rgmii_in
      .tse_mac_rgmii_connection_rgmii_out        (ENET1_TX_DATA),        // .rgmii_out
      .tse_mac_rgmii_connection_rx_control       (ENET1_RX_DV),          // .rx_control
      .tse_mac_rgmii_connection_tx_control       (ENET1_TX_EN),          // .tx_control
      
      .tse_mac_status_connection_eth_mode        (eth_mode),        	   // .eth_mode
      .tse_mac_status_connection_ena_10          (ena_10),          	   // .ena_10	  
      
      // Avalon-ST Master:
/*
          .tse_tx_avalon_st_data               (avalon_st_bus.Data_xDI),                 // .tse_tx_avalon_st.data
  	  .tse_tx_avalon_st_endofpacket        (avalon_st_bus.Eop_xSI),                  // .endofpacket
  	  .tse_tx_avalon_st_error              (avalon_st_bus.Error_xSI),                // .error
  	  .tse_tx_avalon_st_empty              (avalon_st_bus.Empty_xSI),                // .empty
  	  .tse_tx_avalon_st_ready              (avalon_st_bus.Ready_xSO),                // .ready
  	  .tse_tx_avalon_st_startofpacket      (avalon_st_bus.Sop_xSI),                  // .startofpacket
  	  .tse_tx_avalon_st_valid              (avalon_st_bus.Valid_xSI),
*/    
          .tse_tx_avalon_st_data               (avalon_st_bus.Data),                 // .tse_tx_avalon_st.data
  	  .tse_tx_avalon_st_endofpacket        (avalon_st_bus.Eop),                  // .endofpacket
  	  .tse_tx_avalon_st_error              (avalon_st_bus.Error),                // .error
  	  .tse_tx_avalon_st_empty              (avalon_st_bus.Empty),                // .empty
  	  .tse_tx_avalon_st_ready              (avalon_st_bus.Ready),                // .ready
  	  .tse_tx_avalon_st_startofpacket      (avalon_st_bus.Sop),                  // .startofpacket
  	  .tse_tx_avalon_st_valid              (avalon_st_bus.Valid),

        // Avalon-MM Master:
/*
  	  .tse_mm_control_port_address         (avalon_mm_bus.address_xDO),     // .tse_mm_control_port.address
  	  .tse_mm_control_port_readdata        (avalon_mm_bus.readdata_xSI),    // .readdata
  	  .tse_mm_control_port_read            (avalon_mm_bus.read_xSO),        // .read
  	  .tse_mm_control_port_writedata       (avalon_mm_bus.writedata_xDO),   // .writedata
  	  .tse_mm_control_port_write           (avalon_mm_bus.write_xSO),       // .write
  	  .tse_mm_control_port_waitrequest     (avalon_mm_bus.waitrequest_xSI)  // .waitrequest
*/
  	  .tse_mm_control_port_address         (avalon_mm_bus.address),     // .tse_mm_control_port.address
  	  .tse_mm_control_port_readdata        (avalon_mm_bus.readdata),    // .readdata
  	  .tse_mm_control_port_read            (avalon_mm_bus.read),        // .read
  	  .tse_mm_control_port_writedata       (avalon_mm_bus.writedata),   // .writedata
  	  .tse_mm_control_port_write           (avalon_mm_bus.write),       // .write
  	  .tse_mm_control_port_waitrequest     (avalon_mm_bus.waitrequest)  // .waitrequest
    );	


tse_controller #(
    /*._SIMULATION(`_SIMULATION),
      ._COMPILE_TYPE(`_COMPILE_TYPE),
      parameter MTU_WIDTH          = 16,
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
    ) 
  dut_1 (
      .Clock_xCI(sys_clk),
      .Reset_xSI(reset),
      .Send_Packet_xSI(start),
      
      .Mtu_xDI( 16'h06),          
      .Speed_Sensor_xDI(16'hABCD),
      .Adc_xDI(SW[16:1]),         
      
      // Avalon-ST Master:
      .Avalon_ST_Source(avalon_st_bus.Source),
      
      // Avalon-MM Master:
      .Avalon_MM_Master(avalon_mm_bus.Master)
    
    );
    
/*
//defparam dut_1.DATA_LAYER_BYTES    = 4;
//defparam dut_1.FSM_WAIT_TO_INIT    = 250000000;
//defparam dut_1.FSM_WAIT_SEND_AGAIN = 50000000; 
tse_controller #(
    .FSM_WAIT_TO_INIT(25000000),
    .FSM_WAIT_SEND_AGAIN(50000000)
  )
  dut_1 (
     .Clock_xCI(sys_clk),
     .Send_Packet_xSI(start),
     //.Reset_xSI(reset),
     .Reset_xSI(core_reset_n),
     .Adc_xDI(16'h1234),
     .Speed_Sensor_xDI(16'hABCD),
     .Mtu_xDI(SW[16:1]),
     
     // Avalon-ST Master:
     .Tx_Ready_xSI(avalon_st_bus.Source_Ready_xSI),
     .Tx_Error_xSO(avalon_st_bus.Source_Error_xSO),
     .Tx_Valid_xSO(avalon_st_bus.Source_Valid_xSO),           
     .Tx_Sop_xSO(avalon_st_bus.Source_Sop_xSO),             
     .Tx_Eop_xSO(avalon_st_bus.Source_Eop_xSO),             
     .Tx_Empty_xSO(avalon_st_bus.Source_Empty_xSO),           
     .Tx_Data_xDO(avalon_st_bus.Source_Data_xDO),
     
     // Avalon-MM Master:
    .Tse_Control_address_xDO(avalon_mm_bus.Master_address_xDO),
 	.Tse_Control_readdata_xSI(avalon_mm_bus.Master_readdata_xSI),
 	.Tse_Control_read_xSO(avalon_mm_bus.Master_read_xSO),
 	.Tse_Control_writedata_xDO(avalon_mm_bus.Master_writedata_xDO),
 	.Tse_Control_write_xSO(avalon_mm_bus.Master_write_xSO),
 	.Tse_Control_waitrequest_xSI(avalon_mm_bus.Master_waitrequest_xSI)
  );
*/
  
endmodule 

