//  Class: apb_driver
//
class apb_driver extends uvm_driver #(apb_packet);
  `uvm_component_utils(apb_driver)

  virtual interface apb_if vif;

  //  Constructor: new
  function new(string name = "apb_driver", uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void start_of_simulation_phase(uvm_phase phase);
    `uvm_info(get_type_name(), {"start of simulation for ", get_full_name()}, UVM_HIGH)
  endfunction : start_of_simulation_phase
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (!uvm_config_db#(virtual apb_if)::get(this, "", "vif", vif))
      `uvm_error(get_name(), "vif not set")
  endfunction: connect_phase


  // Declare this property to count packets sent
  int num_sent;

  // UVM run_phase
  task run_phase(uvm_phase phase);
    `uvm_info(get_name(), "run_phase", UVM_NONE)

    fork
      get_and_drive();
        
      reset_signals();
    join
  endtask : run_phase

  // Gets packets from the sequencer and passes them to the driver. 
  task get_and_drive();
    bit is_master;
    @(negedge vif.rst_n);
    @(posedge vif.rst_n);
    `uvm_info(get_type_name(), "Reset dropped", UVM_MEDIUM)
    forever begin
      `uvm_info(get_name(), "seq_item_port.get_next_item(req);", UVM_NONE)

      // Get new item from the sequencer
      seq_item_port.get_next_item(req);

      `uvm_info(get_type_name(), $sformatf("Sending Packet :\n%s", req.sprint()), UVM_HIGH)
      if (!uvm_config_db#(bit)::get(this, "", "is_master", is_master))
      `uvm_error(get_name(), "is_master not set")
       
      // concurrent blocks for packet driving and transaction recording
      fork
        // send packet
        begin
          
        if (is_master)
          vif.master_send_to_dut(req.paddr, req.pwrite,req.pwdata, req.prdata);
        else
          vif.slave_send_to_dut(req.pready_delay);
        end
        // trigger transaction at start of packet (trigger signal from interface)
        @(posedge vif.drvstart) void'(begin_tr(req, "Driver_apb_Packet"));
      join

      // End transaction recording
      end_tr(req);
      num_sent++;
      // Communicate item done to the sequencer
      seq_item_port.item_done();
      #10ns;
    end
  endtask : get_and_drive

  // Reset all TX signals
  task reset_signals();
    forever 
     vif.apb_reset();
  endtask : reset_signals

  // UVM report_phase
  function void report_phase(uvm_phase phase);
    `uvm_info(get_type_name(), $sformatf("Report: apb TX driver sent %0d packets", num_sent), UVM_LOW)
  endfunction : report_phase
    
endclass: apb_driver

