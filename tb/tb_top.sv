/*-----------------------------------------------------------------
File name     : tb_top.sv
Description   : lab01_data tb_top module template file
Notes         : From the Cadence "SystemVerilog Advanced Verification with UVM" training
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015
-----------------------------------------------------------------*/

module tb_top;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  import apb_pkg::*;

  `include "apb_tb.sv"
  `include "apb_test_lib.sv"

  initial begin
    uvm_config_db#(bit)::set(null, "*.testbench.env.agent.driver", "is_master", 1); // 1 for master, 0 for slave

    uvm_config_db#(virtual apb_if)::set(null, "*.testbench.env.agent.*", "vif", hw_top.p_if);
    run_test();
  end

endmodule : tb_top
