//`ifndef INTERFACE_DONE
//  `define INTERFACE_DONE 1

  
  
  interface IAvalonST ();
      parameter DATA_WIDTH = 32;
      parameter ERROR_WIDTH = 1;

/*      
7yy      logic Ready_xSI;
      logic [(ERROR_WIDTH-1):0 ] Error_xSO; // <-- fix this, should be 1 bit wide signal, not 2
      logic Valid_xSO;
      logic Sop_xSO;
      logic Eop_xSO;
      logic [1:0] Empty_xSO;
      logic [(DATA_WIDTH-1):0 ] Data_xDO;
      
      logic Ready_xSO;
      logic [(ERROR_WIDTH-1):0 ] Error_xSI; // <-- fix this, should be 1 bit wide signal, not 2
      logic Valid_xSI;
      logic Sop_xSI;
      logic Eop_xSI;
      logic [1:0] Empty_xSI;
      logic [(DATA_WIDTH-1):0 ] Data_xDI;
      
      assign Ready_xSI = Ready_xSO;
      assign Error_xSI = Error_xSO;
      assign Valid_xSI = Valid_xSO;
      assign Sop_xSI   = Sop_xSO;
      assign Eop_xSI   = Eop_xSO;
      assign Empty_xSI = Empty_xSO;
      assign Data_xDI  = Data_xDO;
  
      modport Source
        ( 
        input  Ready_xSI,
        output Error_xSO, // <-- fix this, should be 1 bit wide signal, not 2
        output Valid_xSO,
        output Sop_xSO,
        output Eop_xSO,
        output Empty_xSO,
        output Data_xDO
      );
      modport Sink
        ( 
        output Ready_xSO,
        input  Error_xSI, // <-- fix this, should be 1 bit wide signal, not 2
        input  Valid_xSI,
        input  Sop_xSI,
        input  Eop_xSI,
        input  Empty_xSI,
        input  Data_xDI
      );
*/

      logic Ready;
      logic [(ERROR_WIDTH-1):0 ] Error; // <-- fix this, should be 1 bit wide signal, not 2
      logic Valid;
      logic Sop;
      logic Eop;
      logic [1:0] Empty;
      logic [(DATA_WIDTH-1):0 ] Data;

      modport Source
        ( 
        input  Ready,
        output Error, // <-- fix this, should be 1 bit wide signal, not 2
        output Valid,
        output Sop,
        output Eop,
        output Empty,
        output Data
      );

      modport Sink
        ( 
        output Ready,
        input  Error, // <-- fix this, should be 1 bit wide signal, not 2
        input  Valid,
        input  Sop,
        input  Eop,
        input  Empty,
        input  Data
      );

  endinterface : IAvalonST

      
      
  interface IAvalonMM();
      parameter ADDRESS_WIDTH = 8;
      parameter DATA_WIDTH = 32;
 /* 
      logic [(ADDRESS_WIDTH-1):0 ] address_xDO;
      logic [(DATA_WIDTH-1):0]     readdata_xSI;
      logic                        read_xSO;
      logic [(DATA_WIDTH-1):0]     writedata_xDO;
      logic                        write_xSO;
      logic                        waitrequest_xSI;
  
      logic [(ADDRESS_WIDTH-1):0 ] address_xDI;
      logic [(DATA_WIDTH-1):0]     readdata_xSO;
      logic                        read_xSI;
      logic [(DATA_WIDTH-1):0]     writedata_xDI;
      logic                        write_xSI;
      logic                        waitrequest_xSO;
  
      assign readdata_xSI    = readdata_xSO;
      assign waitrequest_xSI = waitrequest_xSO;
      assign read_xSI        = read_xSO;
      assign write_xSI       = write_xSO;
      assign address_xDI     = address_xDO;
      assign writedata_xDI   = writedata_xDO;

      modport Master( 
        input  readdata_xSI,
        input  waitrequest_xSI,
        output read_xSO,
        output write_xSO,
        output address_xDO,
        output writedata_xDO
      );
      
      modport Slave( 
        output readdata_xSO,
        output waitrequest_xSO,
        input  read_xSI,
        input  write_xSI,
        input  address_xDI,
        input  writedata_xDI
      );
*/
      logic [(ADDRESS_WIDTH-1):0 ] address;
      logic [(DATA_WIDTH-1):0]     readdata;
      logic                        read;
      logic [(DATA_WIDTH-1):0]     writedata;
      logic                        write;
      logic                        waitrequest;

      modport Master( 
        input  readdata,
        input  waitrequest,
        output read,
        output write,
        output address,
        output writedata
      );
      
      modport Slave( 
        output readdata,
        output waitrequest,
        input  read,
        input  write,
        input  address,
        input  writedata
      );
      
      
  endinterface : IAvalonMM
      
//`endif
