`ifndef _SIMULATION
  `define _SIMULATION 1
`endif

//`include "./../src/pkgs/inet_stack_pkg.sv"
//`include "interface_pkg.sv"

import inet_stack_pkg::*;

module tse_controller
  #(
    parameter _COMPILE_TYPE      = 0,
    
    parameter MTU_WIDTH          = 16,
    parameter SPEED_SENSOR_WIDTH = 16,
    parameter ADC_WIDTH          = 16,
    
    parameter TSE_TX_ST_DATA_WIDTH = 32,
    parameter TSE_CONTROL_MM_ADDRESS_WIDTH = 8,
    parameter TSE_CONTROL_MM_DATA_WIDTH = 32,
    
    parameter FSM_COUNTER_SPAN = 250000000,
    parameter FSM_WAIT_TO_INIT = 5,
    parameter FSM_WAIT_SEND_AGAIN = 5,
    
    parameter LINK_LAYER_BYTES = 16,
    parameter IP_LAYER_BYTES   = 20,
    parameter UDP_LAYER_BYTES  = 8,
    parameter DATA_LAYER_BYTES = 24
  )
  (
    // Inputs:
    input Clock_xCI,
    input Reset_xSI,
    input Send_Packet_xSI,
    
    // User Interface:
    input [(MTU_WIDTH-1):0]          Mtu_xDI,
    input [(SPEED_SENSOR_WIDTH-1):0] Speed_Sensor_xDI,
    input [(ADC_WIDTH-1):0]          Adc_xDI,
    
    // Avalon-ST Source:
    interface Avalon_ST_Source,    
    
    // Avalon-MM Master:
    interface Avalon_MM_Master

  );


localparam NUMBER_OF_INIT_WORDS = $size(Master_Reg_xD) - 1;
  
logic Start_xS, Reset_xS;
logic [(TSE_TX_ST_DATA_WIDTH-1):0] Source_Data_xD;
logic [(SPEED_SENSOR_WIDTH-1):0] Speed_Sensor_xD;
logic [(ADC_WIDTH-1):0] Adc_xD;
logic [($clog2(FSM_COUNTER_SPAN)-1):0] Counter_xD;

/*  LINK HEADER:
LINK HEADER:
0x00,0x00,0x01,0x00, // 0      0      MAC     MAC
0x5e,0x01,0x01,0x01, // MAC    MAC    MAC     MAC
0x54,0x53,0xed,0xb5, // MAC    MAC    MAC     MAC
0x2d,0xaa,0x08,0x00, // MAC    MAC    TYPE    TYPE
*/

const ipv4_layer_ts LINK_HEADER = { 32'h00_08_aa_2d,
                                    32'hb5_ed_53_54,
                                                                                                                                                32'h01_01_01_5e,
                                                                                                                                                32'h00_01_00_00 };                                                        



/*
IP HEADER:
0x45,0x00,0x00,0x22, // VERIHL TOSECN LENGTH  LENGTH
0xb9,0xa3,0x40,0x00, // ID     ID     FLAG----OFFSET
0x01,0x11,0x05,0x7b, // TTL    Proto  Header--ChkSum
0xc0,0xa8,0x0a,0x02, // source----IP----------address
0xef,0x01,0x01,0x01, // destination---IP------address
*/

ipv4_layer_ts IP_HEADER;

logic [15:0] Ip_Total_Len;
logic [16:0] chksum_01_xD, chksum_02_xD, chksum_03_xD, chksum_04_xD;
logic [17:0] chksum_11_xD, chksum_12_xD;
logic [18:0] chksum_21_xD;
logic [19:0] chksum_31_xD;
logic [20:0] chksum_41_xD;
logic [16:0] chksum_51_xD;
logic [15:0] chksum_xD;

localparam [15:0] ip_hdr1 = 16'h4500;
localparam [15:0] ip_hdr2 = 16'hb9a3;
localparam [15:0] ip_hdr3 = 16'h4000;
localparam [15:0] ip_hdr4 = 16'h0111;
localparam [15:0] ip_hdr5 = 16'hc0a8;
localparam [15:0] ip_hdr6 = 16'h0a02;
localparam [15:0] ip_hdr7 = 16'hef01;
localparam [15:0] ip_hdr8 = 16'h0101;

/*
-- // Initialize the MAC address 
-- *(tse + 3) = 0xb5ed5354;
-- *(tse + 4) = 0x0000aa2d; 

-- // Specify the addresses of the PHY devices to be accessed through MDIO interface
-- *(tse + 0x0F) = 0x10;
-- *(tse + 0x10) = 0x11;

-- //PHY0:
-- // Write to register 20 of the PHY chip for Ethernet port 0 to set up line loopback
-- *(tse + 0x94) = 0x4000;

-- //PHY1:
-- // Write to register 16 of the PHY chip for Ethernet port 1 to enable automatic crossover for all modes
-- *(tse + 0xB0) = *(tse + 0xB0) | 0x0060;    
-- // Write to register 20 of the PHY chip for Ethernet port 1 to set up delay for input/output clk
-- *(tse + 0xB4) = *(tse + 0xB4) | 0x0082;
-- // Software reset the second PHY chip and wait
-- *(tse + 0xA0) = *(tse + 0xA0) | 0x8000;
-- while ( *(tse + 0xA0) & 0x8000  );     
 
-- //TSE Megafunction:
-- // Enable read and write transfers, gigabit Ethernet operation, and CRC forwarding
-- // *(tse + 2) = *(tse + 2) | 0x0000004B;
--    *(tse + 2) = *(tse + 2) | 0x00000043;
*/

const logic [0:7] [39:0] Master_Reg_xD = { 40'h03_b5ed5354,
                                           40'h04_0000aa2d,
                                           40'h0F_00000010,
                                           40'h10_00000011,
                                           40'h94_00004000,
                                           40'hB0_00000078,
                                           40'hB4_00000ce2,
                                           40'hA0_00009140 };

localparam[39:0] TSE_ENABLE_TX_RX = 40'h02_00000043;

typedef enum logic[3:0]{ RESET                       = 4'd0,
                         INITIALIZE_TSE_VIA_MM       = 4'd1,
                         RESEND_INIT_ON_WAITREQUEST1 = 4'd2,
                         IS_MORE_INIT_DATA_LEFT      = 4'd3,  
                         WAIT_FOR_RESET                 = 4'd4, 
                         CONFIGURE_TSE_VIA_MM           = 4'd5, 
                         RESEND_ON_WAITREQUEST2      = 4'd6, 
                         IDLE                        = 4'd7, 
                         SEND_LINK_HEADER            = 4'd8, 
                         SEND_IP_HEADER              = 4'd9, 
                         SEND_UDP_HEADER             = 4'd10, 
                         SEND_PAYLOAD                = 4'd11, 
                         WAIT_DELAY                  = 4'd12 } fsm_type;

fsm_type next_state;


always_ff @ (posedge Clock_xCI)
begin
  Start_xS    <= Send_Packet_xSI;
  Reset_xS    <= Reset_xSI;
  Speed_Sensor_xD <= Speed_Sensor_xDI;
  Adc_xD          <= Adc_xDI;
end


always_ff @ (posedge Clock_xCI)
begin
  Ip_Total_Len <= IP_LAYER_BYTES + UDP_LAYER_BYTES + Mtu_xDI;

/*
localparam [15:0] ip_hdr1 = 16'h4500;
localparam [15:0] ip_hdr2 = 16'hb9a3;
localparam [15:0] ip_hdr3 = 16'h4000;
localparam [15:0] ip_hdr4 = 16'h0111;
localparam [15:0] ip_hdr5 = 16'hc0a8;
localparam [15:0] ip_hdr6 = 16'h0a02;
localparam [15:0] ip_hdr7 = 16'hef01;
localparam [15:0] ip_hdr8 = 16'h0101;
*/
  
  //--Calculate header checksum:
  //-- 1st stage pipeline:
  chksum_01_xD <= Ip_Total_Len + ip_hdr1; //{<<8{ipv4_layer_bytes[7:0]}};
  chksum_02_xD <= ip_hdr3 + ip_hdr2;
  chksum_03_xD <= ip_hdr5 + ip_hdr4;
  chksum_04_xD <= ip_hdr7 + ip_hdr6;
  //-- 2nd stage pipeline:
  chksum_11_xD <= chksum_01_xD + chksum_02_xD;
  chksum_12_xD <= chksum_03_xD + chksum_04_xD;
  //-- 3rd stage pipeline:
  chksum_21_xD <= chksum_11_xD + chksum_12_xD;
  //-- 4th stage pipeline:
  chksum_31_xD <= ip_hdr8 + chksum_21_xD;
  //-- 5th stage pipeline:
  chksum_41_xD <= chksum_31_xD[19:16] + chksum_31_xD[15:0];
  //-- 6th stage pipeline:
  chksum_xD <= ~ (chksum_41_xD[20:16] + chksum_41_xD[15:0]);

/*
IP HEADER:
0x45,0x00,0x00,0x22, // VERIHL TOSECN LENGTH  LENGTH
0xb9,0xa3,0x40,0x00, // ID     ID     FLAG----OFFSET
0x01,0x11,0x05,0x7b, // TTL    Proto  Header--ChkSum
0xc0,0xa8,0x0a,0x02, // source----IP----------address
0xef,0x01,0x01,0x01, // destination---IP------address
*/ 
  IP_HEADER.dst_ip_0      <= 8'h01;    
  IP_HEADER.dst_ip_1      <= 8'h01;    
  IP_HEADER.dst_ip_2      <= 8'h01;    
  IP_HEADER.dst_ip_3      <= 8'hef;    
  IP_HEADER.src_ip_0      <= 8'h02; 
  IP_HEADER.src_ip_1      <= 8'h0a; 
  IP_HEADER.src_ip_2      <= 8'ha8; 
  IP_HEADER.src_ip_3      <= 8'hc0; 
  IP_HEADER.checksum_0    <= chksum_xD[7:0]; 
  IP_HEADER.checksum_1    <= chksum_xD[15:8]; 
  IP_HEADER.protocol      <= 8'h11; 
  IP_HEADER.ttl           <= 8'h01; 
  IP_HEADER.frag_offset_0 <= 8'h00; 
  IP_HEADER.frag_offset_1 <= 5'h8; // <-- INVESTIGATE WHY!!!
  IP_HEADER.flags         <= 3'h0;  
  IP_HEADER.msg_id_0      <= 8'ha3; 
  IP_HEADER.msg_id_1      <= 8'hb9; 
  IP_HEADER.total_len_0   <= Ip_Total_Len[7:0];
  IP_HEADER.total_len_1   <= Ip_Total_Len[15:8];
  IP_HEADER.ecn           <= 2'h0;          
  IP_HEADER.dscp          <= 6'h0;         
  IP_HEADER.ip_ver        <= 4'h4;
  IP_HEADER.ihl           <= 4'h5;
  
// IP_HEADER <= {32'h01_01_01_ef, 32'h02_0a_a8_c0, chksum_xD[7:0], chksum_xD[15:8], 16'h11_01, 32'h00_40_a3_b9, Ip_Total_Len[7:0], Ip_Total_Len[15:8], 16'h00_45};
end



/* 
-- UDP HEADER:
-- 0xbe,0x98,0x23,0x82, // Source-Port   DestinationPort
-- 0x00,0x0e,0x3e,0xe3, // length-length CheckSumChecksum
-- Registered Inputs:
*/

udp_layer_ts UDP_HEADER;
logic [15:0] Udp_Total_Len;

always_ff @ (posedge Clock_xCI)
begin
  Udp_Total_Len <= UDP_LAYER_BYTES + Mtu_xDI;
  
  UDP_HEADER.src_port_1   <= 8'hbe;
  UDP_HEADER.src_port_0   <= 8'h98;
  UDP_HEADER.dst_port_1   <= 8'h23;
  UDP_HEADER.dst_port_0   <= 8'h82;
  UDP_HEADER.udp_length_1 <= Udp_Total_Len[15:8];
  UDP_HEADER.udp_length_0 <= Udp_Total_Len[7:0];
  UDP_HEADER.checksum_1   <= 8'h00;
  UDP_HEADER.checksum_0   <= 8'h00;  

/*  UDP_HEADER  <= {16'h00_00, Udp_Total_Len[7:0], Udp_Total_Len[15:8], 32'h82_23_98_be};*/
end


/*
//-- Byte swap the endianess on the data sent to TSE Module since we implement little endianess while altera uses big endian:
byte_swap: FOR k in 0 to (TSE_TX_ST_DATA_WIDTH/8-1) GENERATE
  Source_Data(((k*8)+8)-1 DOWNTO ((k*8))) <= Source_Data_xD( (32-((k*8))-1) DOWNTO (32-((k*8)+8)));
END GENERATE byte_swap; 
*/
assign Avalon_ST_Source.Data = {Source_Data_xD[7:0], Source_Data_xD[15:8], Source_Data_xD[23:16], Source_Data_xD[31:24]};

//genvar Data_Bytes 
//generate
//  for (Data_Bytes=0; Data_Bytes < ($bits(Avalon_ST_Source.Data)/8); Data_Bytes+=1 ) begin: byte_swap_gen
//    assign Avalon_ST_Source.Data[ TSE_TX_ST_DATA_WIDTH - ( 8*Data_Bytes) +: TSE_TX_ST_DATA_WIDTH ] = Source_Data_xD[ (Data_Bytes*TSE_TX_ST_DATA_WIDTH) +: TSE_TX_ST_DATA_WIDTH ]

/*
-- 1. Add State Machine.
-- 2. use case statement to implement next logic:
--   WHEN state is SEND LINK HEADER, MUX the LINK_HEADER to Source_data
--   WHEN state is SEND IP HEADER, MUX the IP_HEADER to Source_data
--   WHEN state is SEND UDP HEADER, MUX the UDP_HEADER to Source_data
--   WHEN state is SEND DATA, MUX the DATA to Source_data */

always_ff @ (posedge Clock_xCI)
begin

  // Default Assignments:
  Counter_xD <= Counter_xD;
  next_state <= RESET;
  
  Avalon_ST_Source.Error <= '0;
  Avalon_ST_Source.Valid <= 1'b0;
  Avalon_ST_Source.Sop   <= 1'b0; 
  Avalon_ST_Source.Eop   <= 1'b0;
  Avalon_ST_Source.Empty <= 1'b0;
  Source_Data_xD   <= '0;
  
  Avalon_MM_Master.address     <= Avalon_MM_Master.address;
  Avalon_MM_Master.read        <= '0;
  Avalon_MM_Master.writedata   <= Avalon_MM_Master.writedata;
  Avalon_MM_Master.write       <= '0;

  if (Reset_xS == 1'b0) begin
    next_state <= RESET;
    Counter_xD <= '0; 
  end
  else begin 
    case(next_state)
    
    RESET: begin
        next_state  <= INITIALIZE_TSE_VIA_MM;
        Counter_xD <= '0; 
        if (Counter_xD < FSM_WAIT_TO_INIT) begin
            next_state <= RESET; 
            Counter_xD  <= Counter_xD + 1;
        end
    end
    INITIALIZE_TSE_VIA_MM: begin 
        Counter_xD                      <= Counter_xD;
        Avalon_MM_Master.write      <= '1;
        Avalon_MM_Master.address    <= Master_Reg_xD[Counter_xD][39:TSE_CONTROL_MM_DATA_WIDTH]; 
        Avalon_MM_Master.writedata  <= Master_Reg_xD[Counter_xD][(TSE_CONTROL_MM_DATA_WIDTH-1):0];
        next_state                      <= RESEND_INIT_ON_WAITREQUEST1; 
    end
    RESEND_INIT_ON_WAITREQUEST1: begin
        next_state             <= RESEND_INIT_ON_WAITREQUEST1;
        Avalon_MM_Master.write <= '1;
        if ( Avalon_MM_Master.waitrequest == 1'b0) begin
            next_state             <= IS_MORE_INIT_DATA_LEFT;
            Avalon_MM_Master.write <= '0;
        end
    end
    IS_MORE_INIT_DATA_LEFT: begin
        next_state <= INITIALIZE_TSE_VIA_MM;
        Counter_xD   <= Counter_xD + 1;
        if (Counter_xD >= ($size(Master_Reg_xD) - 1) ) begin
            next_state <= WAIT_FOR_RESET;
            Counter_xD <= '0;
        end
    end
    WAIT_FOR_RESET: begin //replace with read for soft reset to finish :)
        next_state <= CONFIGURE_TSE_VIA_MM;
        Counter_xD  <= '0;
        if (Counter_xD < 5) begin
            next_state <= WAIT_FOR_RESET;
            Counter_xD <= Counter_xD + 1;
        end
    end
    CONFIGURE_TSE_VIA_MM: begin
        next_state <= RESEND_ON_WAITREQUEST2;

        Avalon_MM_Master.write      <= '1;
        Avalon_MM_Master.address    <= TSE_ENABLE_TX_RX[39:TSE_CONTROL_MM_DATA_WIDTH];
        Avalon_MM_Master.writedata  <= TSE_ENABLE_TX_RX[(TSE_CONTROL_MM_DATA_WIDTH-1):0];
    end
    RESEND_ON_WAITREQUEST2: begin
        Avalon_MM_Master.write      <= '1;
        Avalon_MM_Master.address    <= TSE_ENABLE_TX_RX[39:TSE_CONTROL_MM_DATA_WIDTH];
        Avalon_MM_Master.writedata  <= TSE_ENABLE_TX_RX[(TSE_CONTROL_MM_DATA_WIDTH-1):0];
        if ( Avalon_MM_Master.waitrequest == 1'b1) begin
            next_state <= RESEND_ON_WAITREQUEST2; end
        else begin
            Avalon_MM_Master.write <= '0;
            next_state <= IDLE;
        end
    end
    IDLE: begin
        if ( Start_xS == 1'b1 ) begin
            next_state <= SEND_LINK_HEADER; end
        else begin
            next_state <= IDLE;
        end     
    end        
    SEND_LINK_HEADER: begin
        Counter_xD   <= Counter_xD + 1;
        Avalon_ST_Source.Sop   <= '1;
        Avalon_ST_Source.Valid <= '1;
        //Source_Data_xD  <= LINK_HEADER[ (((Counter_xD*TSE_TX_ST_DATA_WIDTH)+TSE_TX_ST_DATA_WIDTH)-1) : (Counter_xD*TSE_TX_ST_DATA_WIDTH) ];
        Source_Data_xD  <= LINK_HEADER[ (Counter_xD*TSE_TX_ST_DATA_WIDTH) +: TSE_TX_ST_DATA_WIDTH ];
        if ( Avalon_ST_Source.Ready == '0) begin
            Counter_xD <= Counter_xD;
        end
        if ( Counter_xD > 0 ) begin
            Avalon_ST_Source.Sop <= '0;
        end
        if (Counter_xD < ((LINK_LAYER_BYTES/4)-1)) begin
            next_state <= SEND_LINK_HEADER; end
        else begin
            next_state <= SEND_IP_HEADER;
            Counter_xD  <=  '0 ; 
        end
    end
    SEND_IP_HEADER: begin
        Avalon_ST_Source.Valid <= '1;
        //Source_Data_xD  <= IP_HEADER( ((to_integer(unsigned(Counter_xD))*TSE_TX_ST_DATA_WIDTH)+TSE_TX_ST_DATA_WIDTH)-1 DOWNTO ((to_integer(unsigned(Counter_xD))*TSE_TX_ST_DATA_WIDTH)));
        Source_Data_xD  <= IP_HEADER[ Counter_xD*TSE_TX_ST_DATA_WIDTH +: TSE_TX_ST_DATA_WIDTH ];
        //Source_Data_xD  <= IP_HEADER[ ((Counter_xD*TSE_TX_ST_DATA_WIDTH)+TSE_TX_ST_DATA_WIDTH)-1) : (Counter_xD*TSE_TX_ST_DATA_WIDTH) ];
        Counter_xD  <= Counter_xD + 1;
        if ( Avalon_ST_Source.Ready == 1'b0) begin
            Counter_xD <= Counter_xD; 
        end
        if ( Counter_xD < ((IP_LAYER_BYTES/4)-1)) begin
            next_state <= SEND_IP_HEADER; end
        else begin
            next_state <= SEND_UDP_HEADER;
            Counter_xD  <= '0;
        end
    end 
    SEND_UDP_HEADER: begin
        Avalon_ST_Source.Valid <= '1;
        // Source_Data_xD  <= UDP_HEADER( ((to_integer(unsigned(Counter_xD))*TSE_TX_ST_DATA_WIDTH)+TSE_TX_ST_DATA_WIDTH)-1 DOWNTO ((to_integer(unsigned(Counter_xD))*TSE_TX_ST_DATA_WIDTH)));
        //Source_Data_xD <= UDP_HEADER[ ((Counter_xD*TSE_TX_ST_DATA_WIDTH)+TSE_TX_ST_DATA_WIDTH)-1 : Counter_xD*TSE_TX_ST_DATA_WIDTH ];
        Source_Data_xD <= UDP_HEADER[ Counter_xD*TSE_TX_ST_DATA_WIDTH +: TSE_TX_ST_DATA_WIDTH ];
        Counter_xD <= Counter_xD + 1;
        if ( Avalon_ST_Source.Ready == '0) begin
            Counter_xD <= Counter_xD;
        end
        if ( Counter_xD < ((UDP_LAYER_BYTES/4)-1)) begin
            next_state <= SEND_UDP_HEADER; end
        else begin
            next_state <= SEND_PAYLOAD;
            Counter_xD <= '0;
        end
    end
    SEND_PAYLOAD: begin
        Avalon_ST_Source.Valid <= '1;
        Counter_xD  <= Counter_xD + 1;
        Source_Data_xD  <= {Speed_Sensor_xD,Adc_xD};
        if ( Avalon_ST_Source.Ready == '0) begin
            Counter_xD <= Counter_xD;
        end
        if ( Counter_xD == ( (Mtu_xDI/4)-1) ) begin
            Avalon_ST_Source.Eop <= '1;
        end
        if ( Counter_xD < ( (Mtu_xDI/4)-1) ) begin
            next_state <= SEND_PAYLOAD; end
        else begin
            next_state <= WAIT_DELAY;
            Counter_xD  <=  '0;
        end
    end
    WAIT_DELAY: begin
        Counter_xD <= Counter_xD + 1;
        next_state <= IDLE;
        if ( Counter_xD < FSM_WAIT_SEND_AGAIN) begin
            next_state <= WAIT_DELAY; end
        else begin
            next_state <= IDLE;
            Counter_xD  <= '0;
        end
    end
    default:  ;
    endcase

  end
end



// OTHER STUFF (NOT NEEDED FOR THE DESIGN; EDUCATIONAL)
`ifdef _SIMULATION
  
  
  logic [15:0] b1, b2, b3;
  /* NOTICE: 
      1. Everything inside a task is combinatorial logic as with blocking assignment (wires).
      2. Registers behavior is not allowed within a task.
      3. Declaration of wires or registers is not allowed within a task.  */
  task bitwise_oper;
    input [15:0] a, b;
    output [15:0] a1_xDO, a2_xDO, a3_xDO;
    begin
      a1_xDO = a & b;
        a2_xDO = a1_xDO;
        a3_xDO = a2_xDO;
    end
  endtask
  
  always_ff @ (posedge Clock_xCI)
  begin
  
    begin : bitwise_oper_block1
      if (_COMPILE_TYPE) disable bitwise_oper_block1;
      //$display("\n\nDisplaying on %m; using bitwise_oper within bitwise_oper_block1");
      bitwise_oper(
        // OUTPUTS:
          .a1_xDO(b1), 
          .a2_xDO(b2), 
          .a3_xDO(b3),
          // INPUTS
          .a(Avalon_ST_Source.Data[31:16]),
          .b(Avalon_ST_Source.Data[15:0])    );
    end
    
    begin : bitwise_oper_block2
      if (!_COMPILE_TYPE) disable bitwise_oper_block2;
      //$display("\n\nDisplaying on %m; setting b1 thru b3 to Z within bitwise_oper_block2");
      b1 = 'bZ;
      b2 = 'bZ;
      b3 = 'bZ;
    end
    
  end
  
`else

  always_ff @ (posedge Clock_xCI)
  begin
  
    begin : bitwise_oper_block1
      if (_COMPILE_TYPE) disable bitwise_oper_block1;
      b1 = '1;
      b2 = '1;
      b3 = '1;
    end
    
    begin : bitwise_oper_block2
      if (!_COMPILE_TYPE) disable bitwise_oper_block2;
      b1 = '0;
      b2 = '0;
      b3 = '0;
    end
    
  end

`endif



`ifdef _SIMULATION
  logic [15:0] c1, c2, c3;
  // Direct task operates on REG vectors declared within the same module.
  task bitwise_oper_direct;
  begin
    c1 = Avalon_ST_Source.Data[31:16] & Avalon_ST_Source.Data[15:0];
    c2 = c1;
    c3 = c2;
  end
  endtask
  
  always_ff @ (posedge Clock_xCI)
  begin
  
    begin : bitwise_oper_direct_block1
      if (_COMPILE_TYPE) disable bitwise_oper_direct_block1;
      bitwise_oper_direct;    
    end
    
    begin : bitwise_oper_direct_block2
      if (!_COMPILE_TYPE) disable bitwise_oper_direct_block2;
      c1 = 'bZ;
      c2 = 'bZ;
      c3 = 'bZ;
    end
    
  end
`else
  always_ff @ (posedge Clock_xCI)
  begin
  
    begin : bitwise_oper_block1
      if (_COMPILE_TYPE) disable bitwise_oper_block1;
      c1 = '1;
      c2 = '1;
      c3 = '1;
    end
    
    begin : bitwise_oper_block2
      if (!_COMPILE_TYPE) disable bitwise_oper_block2;
      c1 = '0;
      c2 = '0;
      c3 = '0;
    end
    
  end
`endif




endmodule
