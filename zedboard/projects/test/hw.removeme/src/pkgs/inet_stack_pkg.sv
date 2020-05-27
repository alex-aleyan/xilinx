`ifndef TYPES_DONE
  `define TYPES_DONE 1
  
  package inet_stack_pkg;
  
/*  LINK HEADER:
LINK HEADER:
0      0      MAC     MAC
MAC    MAC    MAC     MAC
MAC    MAC    MAC     MAC
MAC    MAC    TYPE    TYPE

0x00,0x00,0x01,0x00, 
0x5e,0x01,0x01,0x01, 
0x54,0x53,0xed,0xb5, 
0x2d,0xaa,0x08,0x00, 

*/

    typedef struct packed {
      logic [7:0] ip_type_0;
      logic [7:0] ip_type_1;
      logic [7:0] src_mac_0;
      logic [7:0] src_mac_1;
      logic [7:0] src_mac_2;
      logic [7:0] src_mac_3;
      logic [7:0] src_mac_4;
      logic [7:0] src_mac_5;
      logic [7:0] dest_mac_0;
      logic [7:0] dst_mac_1;
      logic [7:0] dst_mac_2;
      logic [7:0] dst_mac_3;
      logic [7:0] dst_mac_4;
      logic [7:0] dst_mac_5;
      logic [15:0] zero_pad;
    } link_layer_ts;
    
  //  typedef union packed {
  //    link_layer_ts                    link_layer_struc;
  //    logic [$bits(link_layer_ts)-1:0] link_layer_vector;
  //    //logic [31:0] link_layer_vector;
  //  } link_layer_tu;
  
/*
IP HEADER:
0x45,0x00,0x00,0x22, // VERIHL TOSECN LENGTH  LENGTH
0xb9,0xa3,0x40,0x00, // ID     ID     FLAG----OFFSET
0x01,0x11,0x05,0x7b, // TTL    Proto  Header--ChkSum
0xc0,0xa8,0x0a,0x02, // source----IP----------address
0xef,0x01,0x01,0x01, // destination---IP------address
*/
   
    typedef struct packed {
      logic [7:0] dst_ip_0;    
      logic [7:0] dst_ip_1;    
      logic [7:0] dst_ip_2;    
      logic [7:0] dst_ip_3;    
      logic [7:0] src_ip_0;
      logic [7:0] src_ip_1;
      logic [7:0] src_ip_2;
      logic [7:0] src_ip_3;
      logic [7:0] checksum_0;
      logic [7:0] checksum_1;
      logic [7:0] protocol;
      logic [7:0] ttl;
      logic [7:0] frag_offset_0;
      logic [4:0] frag_offset_1;
      logic [2:0] flags;
      logic [7:0] msg_id_0;
      logic [7:0] msg_id_1;
      logic [7:0] total_len_0;
      logic [7:0] total_len_1;
      logic [1:0] ecn;           
      logic [5:0] dscp;          
      logic [3:0] ip_ver;           
      logic [3:0] ihl;        
    } ipv4_layer_ts;

   // typedef union packed {
   //   ipv4_layer_ts                              ipv4_layer_struc;
   //   logic [$bits(ipv4_layer_ts)-1:0]           ipv4_layer_vector;
   //   logic [($bits(ipv4_layer_ts)/8)-1:0] [7:0] ipv4_layer_bytes;
   // } ipv4_layer_tu;
    
/*
UDP HEADER:
0xbe,0x98,0x23,0x82, // Source-Port   DestinationPort
0x00,0x0e,0x3e,0xe3, // length-length CheckSumChecksum
*/
    typedef struct packed {
      logic [7:0] checksum_0;
      logic [7:0] checksum_1;
      logic [7:0] udp_length_0;
      logic [7:0] udp_length_1;
      logic [7:0] dst_port_0;
      logic [7:0] dst_port_1;
      logic [7:0] src_port_0;
      logic [7:0] src_port_1;
    } udp_layer_ts;
    
   // typedef union packed {
   //   udp_layer_ts                     udp_layer_struc;
   //   logic [$bits(udp_layer_ts)-1:0]  udp_layer_vector;
   // } udp_layer_tu;
    
  endpackage


import inet_stack_pkg::*;

`endif