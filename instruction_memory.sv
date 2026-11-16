
module instruction_memory #(
    parameter DEPTH = 256
)(
    input  logic [31:0] address,
    output logic [31:0] instruction
);

    logic [31:0] mem [0:DEPTH-1];

    integer i;

    initial begin
        for (i = 0; i < DEPTH; i = i + 1)
            mem[i] = 32'h00000013; // NOP (ADDI x0,x0,0)

        // Example instructions can be loaded here.
        // Example: mem[0] = 32'h00500093; // ADDI x1,x0,5
    end

    always_comb begin
        if (address >= 32'h80000000 &&
            ((address - 32'h80000000) >> 2) < DEPTH)
            instruction = mem[(address - 32'h80000000) >> 2];
        else
            instruction = 32'h00000013;
    end

endmodule
