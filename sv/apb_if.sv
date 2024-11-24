interface apb_if (input pclk, input rst_n);
    timeunit 1ns;
    timeprecision 100ps;
  
    import uvm_pkg::*;
    `include "uvm_macros.svh"
  
    import apb_pkg::*;
  
    logic [8:0] paddr;
    logic psel;
    logic penable;
    logic pwrite;
    logic [31:0] pwdata;
    logic pready;
    logic [31:0] prdata;
  
    // signal for transaction recording
    bit monstart, drvstart;
  
    task apb_reset();
        @(negedge rst_n);
        paddr   <=  'hz;
        psel    <= 1'b0;
        penable <= 1'b0;
        pwrite  <= 1'b0;
        pwdata  <=  'hz;
        disable master_send_to_dut;
        disable slave_send_to_dut;
    endtask
  
    // Gets a packet and drive it into the DUT
    task master_send_to_dut(input logic [8:0] paddr_in,
                            input logic  pwrite_in,
                            input logic [31:0] pwdata_in,
                            output logic [31:0] prdata_out);
        `uvm_info("[interface]", "master_send_to_dut", UVM_NONE)
        
        @(posedge pclk);  // trigger for transaction recording
        drvstart = 1'b1;

        psel <= 1;
        pwrite <= pwrite_in;
        paddr <= paddr_in;
        penable <= 0;
        if (pwrite_in) pwdata <= pwdata_in;
  
        @(posedge pclk);
        penable <= 1;
  
        // Use iff instead of wait
        @(posedge pclk iff pready);
        if (!pwrite_in) prdata_out <= prdata;
  
        @(posedge pclk)
        psel <= 0;
  
        // reset trigger
        drvstart = 1'b0;
    endtask : master_send_to_dut
  
    task slave_send_to_dut(input int pready_delay);
        // Wait for packet delay
        repeat(pready_delay) @(posedge pclk);
    
        // reset trigger
        drvstart = 1'b0;
    endtask : slave_send_to_dut

    task collect_packet(output logic [8:0] paddr_out,
                        output logic pwrite_out,
                        output logic [31:0] pwdata_out,
                        output logic [31:0] prdata_out);
    
        // Use iff instead of wait
        @(posedge pclk iff psel == 1);

        // Use iff instead of wait
        @(posedge pclk iff penable == 1);
        
        // Use iff instead of wait
        @(posedge pclk iff pready == 1);

        monstart = 1'b1;
        
        paddr_out <= paddr;
        pwrite_out <= pwrite;
        pwdata_out <= pwdata;
        prdata_out <= prdata;
  
        @(negedge pready)
        // reset trigger
        monstart = 1'b0;
    endtask : collect_packet
  
  endinterface : apb_if