`define _CLOCK_PERIOD 5


module my_and_gate_tb;

localparam DATA_IN_WIDTH = 1;
localparam DATA_OUT_WIDTH = (DATA_IN_WIDTH);

logic clock=0, reset_n=1;

logic [DATA_IN_WIDTH-1:0]  a=0,
                           b=0;

logic [DATA_OUT_WIDTH-1:0] c=0;


my_and_gate #(
        .INPUT_WIDTH(DATA_IN_WIDTH)
    ) dut_1 (
         //driving ports:
        .clock_in(clock),
        .reset_n_in(reset_n),
        .a_in(a),
        .b_in(b),

         //driven ports:
        .c_out(c)
    );

always begin
  #(`_CLOCK_PERIOD/2) clock = ~clock;
end


initial
begin

    reset_n = 'b1;
    repeat(1) @(posedge clock);
    reset_n = 'b0;
    repeat(1) @(posedge clock);
    reset_n = 'b1;
  
    repeat(1) @(posedge clock);
    a=0;
    b=0;

    repeat(1) @(posedge clock);
    a=1;
    b=0;

    repeat(1) @(posedge clock);
    a=0;
    b=1;

    repeat(1) @(posedge clock);
    a=1;
    b=1;


    repeat(50) @(posedge clock);

    //$finish();

end




    

    

endmodule

