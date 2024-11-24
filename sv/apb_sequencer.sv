//  Class: apb_sequencer
//
class apb_sequencer extends uvm_sequencer #(apb_packet);
    `uvm_component_utils(apb_sequencer)

    //  Constructor: new
    function new(string name = "apb_sequencer", uvm_component parent);
        super.new(name, parent);
    endfunction: new

    function void start_of_simulation_phase(uvm_phase phase);
        `uvm_info(get_type_name(), {"start of simulation for ", get_full_name()}, UVM_HIGH)
    endfunction : start_of_simulation_phase
     
endclass: apb_sequencer
