class base_test extends uvm_test;
    `uvm_component_utils(base_test)

    apb_tb testbench;

    function new(string name = "base_test", uvm_component parent);
        super.new(name, parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("BUILD_PHASE", "The build phase of the test is being executed", UVM_HIGH)
        uvm_config_int::set(this, "*", "recording_detail", 1);
        testbench = apb_tb::type_id::create("testbench", this);
    endfunction: build_phase

    function void end_of_elaboration_phase(uvm_phase phase);
        uvm_top.print_topology();
    endfunction: end_of_elaboration_phase

    function void start_of_simulation_phase(uvm_phase phase);
        `uvm_info(get_type_name(), {"start of simulation for ", get_full_name()}, UVM_HIGH);
    endfunction : start_of_simulation_phase

    task run_phase(uvm_phase phase);
        uvm_objection obj = phase.get_objection();
        obj.set_drain_time(this, 200ns);
    endtask: run_phase
    
    
    function void check_phase(uvm_phase phase);
        check_config_usage();
    endfunction: check_phase
    
endclass: base_test

class simple_test extends base_test;
    `uvm_component_utils(simple_test)

    function new(string name = "simple_test", uvm_component parent);
        super.new(name, parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
      uvm_config_wrapper::set(this, "testbench.env.agent.sequencer.run_phase",
                                     "default_sequence",
                                     apb_base_seq::get_type());
      super.build_phase(phase);
    endfunction: build_phase

endclass: simple_test
