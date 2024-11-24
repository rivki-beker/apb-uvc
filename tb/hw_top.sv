/*-----------------------------------------------------------------
File name     : hw_top.sv
Developers    : Kathleen Meade, Brian Dickinson
Created       : 01/04/11
Description   : lab06_vif hardware top module for acceleration
              : Instantiates clock generator and YAPP interface only for testing - no DUT
Notes         : From the Cadence "SystemVerilog Accelerated Verification with UVM" training
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015
-----------------------------------------------------------------*/

module hw_top;

  logic         pclk;
  logic         rst_n;

  initial begin
    pclk = 1;
    rst_n = 1;
    #15ns
    rst_n = 0;
    #15ns;
    rst_n = 1;
  end

  always begin
    #5ns;
    pclk = ~pclk;
  end

  apb_if p_if(pclk, rst_n);

  apb_slave dut(
    .pclk(pclk),
    .rst_n(rst_n),

    .paddr(p_if.paddr),
    .psel(p_if.psel),
    .penable(p_if.penable),
    .pwrite(p_if.pwrite),
    .pwdata(p_if.pwdata),
    .pready(p_if.pready),
    .prdata(p_if.prdata));

endmodule
