
module data_memory #(
    parameter DEPTH = 256
)(
    input  logic clk,
    input  logic mem_read,
    input  logic mem_write,
    input  logic [31:0] address,
    input  logic [31:0] write_data,
    output logic [31:0] read_data
);

    logic [31:0] mem [0:DEPTH-1];

    integer i;

    initial begin
        for (i = 0; i < DEPTH; i = i + 1)
            mem[i] = 32'b0;
    end

    // Synchronous memory write
    always_ff @(posedge clk) begin
        if (mem_write && address[1:0] == 2'b00) begin
            if ((address >> 2) < DEPTH)
                mem[address >> 2] <= write_data;
        end
    end

    // Combinational memory read
    always_comb begin
        read_data = 32'b0;

        if (mem_read && address[1:0] == 2'b00) begin
            if ((address >> 2) < DEPTH)
                read_data = mem[address >> 2];
        end
    end

endmodule
