module apb_slave(
    input logic pclk, 
    input logic rst_n, 
    input logic [8:0] paddr, 
    input logic psel, 
    input logic penable, 
    input logic pwrite, 
    input logic [31:0] pwdata,
    output logic pready,
    output logic [31:0] prdata
);
logic [31:0] mem [0:255];
logic [1:0] apb_st;
const logic [1:0] SETUP=0;
const logic [1:0] W_ENABLE=1;
const logic [1:0] R_ENABLE=2;
always @(posedge pclk or negedge rst_n) begin
    if (!rst_n) begin
        apb_st <= SETUP;
        prdata <= 32'b0;
        pready <= 1'b0;
        for(int i=0; i<256; i++) mem[i] <= i;
    end else begin
        case (apb_st)
            SETUP: begin
                pready <= 1'b0;  // Not ready initially
                prdata <= 32'b0;
                if (psel && !penable) begin
                    if (pwrite) begin
                        apb_st <= W_ENABLE;
                    end else begin
                        apb_st <= R_ENABLE;
                    end
                end
            end
            W_ENABLE: begin
                if (psel && penable && pwrite) begin
                    mem[paddr] <= pwdata;
                end
                pready <= 1'b1;  // Ready after write
                apb_st <= SETUP;
            end
            R_ENABLE: begin
                if (psel && penable && !pwrite) begin
                    prdata <= mem[paddr];
                end
                pready <= 1'b1;  // Ready after read
                apb_st <= SETUP;
            end
        endcase
    end
end
endmodule