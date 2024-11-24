/*-----------------------------------------------------------------
File name     : run.f
Description   : lab01_data simulator run template file
Notes         : From the Cadence "SystemVerilog Advanced Verification with UVM" training
              : Set $UVMHOME to install directory of UVM library
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015
-----------------------------------------------------------------*/
// 64 bit option for AWS labs
-64

 -uvmhome $UVMHOME


-timescale 1ns/1ns

+UVM_TESTNAME=simple_test
+UVM_VERBOSITY=UVM_LOW
+SVSEED=random

// include directories
-incdir ../sv
-incdir ../../clock_and_reset/sv

// compile files

../sv/apb_pkg.sv
../sv/apb_if.sv 

// top module for UVM test environment
tb_top.sv
// accelerated top module for interface instance
hw_top.sv

// DUT
../apb_dut.sv