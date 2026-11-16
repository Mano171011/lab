
module writeback_unit(
    input logic [31:0] alu_result,
    input logic [31:0] mem_data,
    input logic [31:0] pc_plus4,
    input logic [31:0] imm,
    input logic mem_to_reg,
    input logic jump,
    input logic is_lui,

    output logic [31:0] wb_data
);

always_comb begin

    if (is_lui)
        wb_data = imm;

    else if (jump)
        wb_data = pc_plus4;

    else if (mem_to_reg)
        wb_data = mem_data;

    else
        wb_data = alu_result;

end

endmodule
