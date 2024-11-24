//  Class: apb_monitor
//
class apb_monitor extends uvm_monitor;

  // Collected Data handle
  apb_packet pkt;

  // Count packets collected
  int num_pkt_col;

  uvm_analysis_port #(apb_packet) item_collected_port;
  virtual interface apb_if vif;
  
  `uvm_component_utils(apb_monitor)

  // packet collected covergroup
  //covergroup cover_packet @cov_packet;
  covergroup cover_packet;
    option.per_instance = 1;
    paddr_cp : coverpoint pkt.paddr;
    pwrite_cp : coverpoint pkt.pwrite;
    pwdata_cp : coverpoint pkt.pwdata;
    prdata_cp : coverpoint pkt.prdata;
    
    // cross pwrite and paddr
    cross_addr_length: cross paddr_cp, pwrite_cp;
  endgroup : cover_packet

  //  Constructor: new
  function new(string name = "apb_monitor", uvm_component parent);
    super.new(name, parent);
    cover_packet = new();
    cover_packet.set_inst_name({get_full_name(), ".cover_packet"});
    item_collected_port = new("item_collected_port", this);
  endfunction: new

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (!uvm_config_db#(virtual apb_if)::get(this, "", "vif", vif))
      `uvm_error(get_name(), "vif not set")
  endfunction: connect_phase

  function void start_of_simulation_phase(uvm_phase phase);
    `uvm_info(get_type_name(), {"start of simulation for ", get_full_name()}, UVM_HIGH)
  endfunction : start_of_simulation_phase

  // UVM run() phase
  task run_phase(uvm_phase phase);
    // Look for packets after reset
    @(negedge vif.rst_n)
    @(posedge vif.rst_n)

    `uvm_info(get_type_name(), "Detected Reset Done", UVM_MEDIUM)
    forever begin 
      // Create collected packet instance
      pkt = apb_packet::type_id::create("pkt", this);

      // concurrent blocks for packet collection and transaction recording
      fork
        // collect packet
        vif.collect_packet(pkt.paddr, pkt.pwrite, pkt.pwdata, pkt.prdata);
        // trigger transaction at start of packet
        @(posedge vif.monstart) void'(begin_tr(pkt, "Monitor_apb_Packet"));
        
      join

      // End transaction recording
      end_tr(pkt);
      `uvm_info(get_type_name(), $sformatf("Packet Collected :\n%s", pkt.sprint()), UVM_LOW)
      item_collected_port.write(pkt);
      cover_packet.sample();
      num_pkt_col++;
    end
  endtask : run_phase

  // UVM report_phase
  function void report_phase(uvm_phase phase);
    `uvm_info(get_type_name(), $sformatf("Report: apb Monitor Collected %0d Packets", num_pkt_col), UVM_LOW)
  endfunction : report_phase
    
endclass: apb_monitor
