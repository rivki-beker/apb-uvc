class apb_tb extends uvm_env;

  apb_env env;

  `uvm_component_utils(apb_tb)

  function new(string name = "apb_tb", uvm_component parent = null);
    super.new(name, parent);
  endfunction: new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("BUILD_PHASE", "The build phase of the testbench is being executed", UVM_HIGH)

    env = apb_env::type_id::create("env", this);

    // scoreboard = apb_fifo_scoreboard::type_id::create("scoreboard", this);

  endfunction : build_phase

  // function void connect_phase(uvm_phase phase);

  //   env.agent.monitor.item_collected_port.connect(scoreboard.apb_fifo.analysis_export);
  // endfunction: connect_phase
  

endclass: apb_tb