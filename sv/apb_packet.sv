//  Class: apb_packet
//
class apb_packet extends uvm_sequence_item;

    rand logic [8:0] paddr;
    rand logic pwrite;
    rand logic [31:0] pwdata;
    rand int pready_delay;
    logic [31:0] prdata;   

    `uvm_object_utils_begin(apb_packet)
        `uvm_field_int(paddr, UVM_ALL_ON)
        `uvm_field_int(pwrite, UVM_ALL_ON)
        `uvm_field_int(pwdata, UVM_ALL_ON)
        `uvm_field_int(pready_delay, UVM_ALL_ON)
        `uvm_field_int(prdata, UVM_ALL_ON)
    `uvm_object_utils_end

    //  Constructor: new
    function new(string name = "apb_packet");
        super.new(name);
    endfunction: new

endclass: apb_packet
