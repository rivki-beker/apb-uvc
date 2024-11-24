/*-----------------------------------------------------------------
File name     : apb_seqs.sv
Developers    : Kathleen Meade, Brian Dickinson
Created       : 01/04/11
Description   : apb UVC simple TX test sequence for labs 2 to 4
Notes         : From the Cadence "SystemVerilog Advanced Verification with UVM" training
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015
-----------------------------------------------------------------*/

//------------------------------------------------------------------------------
//
// SEQUENCE: base apb sequence - base sequence with objections from which 
// all sequences can be derived
//
//------------------------------------------------------------------------------
class apb_base_seq extends uvm_sequence #(apb_packet);
  
  // Required macro for sequences automation
  `uvm_object_utils(apb_base_seq)

  // Constructor
  function new(string name="apb_base_seq");
    super.new(name);
  endfunction

  task pre_body();
    uvm_phase phase;
    `ifdef UVM_VERSION_1_2
      // in UVM1.2, get starting phase from method
      phase = get_starting_phase();
    `else
      phase = starting_phase;
    `endif
    if (phase != null) begin
      phase.raise_objection(this, get_type_name());
      `uvm_info(get_type_name(), "raise objection", UVM_MEDIUM)
    end
  endtask : pre_body

    // Sequence body definition
  virtual task body();
    `uvm_info(get_type_name(), "Executing apb_simple_seq sequence", UVM_LOW)
    `uvm_do(req)
    `uvm_do_with(req, {req.pwrite == 1'b1;})
    `uvm_do_with(req, {req.pwrite == 1'b0;})
    `uvm_do_with(req, {req.pwrite == 1'b1; req.paddr == 8'h55;})
    `uvm_do_with(req, {req.pwrite == 1'b0; req.paddr == 8'h55;})
  endtask

  task post_body();
    uvm_phase phase;
    `ifdef UVM_VERSION_1_2
      // in UVM1.2, get starting phase from method
      phase = get_starting_phase();
    `else
      phase = starting_phase;
    `endif
    if (phase != null) begin
      phase.drop_objection(this, get_type_name());
      `uvm_info(get_type_name(), "drop objection", UVM_MEDIUM)
    end
  endtask : post_body

endclass : apb_base_seq