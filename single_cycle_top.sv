
module single_cycle_top(
    input logic clk,
    input logic reset,

    output logic [31:0] pc_debug,
    output logic [31:0] instruction_debug
);

    // Program counter and instruction
    logic [31:0] pc;
    logic [31:0] pc_plus4;
    logic [31:0] instruction;

    // Decoder outputs
    logic [4:0] rs1, rs2, rd;
    logic [6:0] opcode, imm11_5;
    logic [2:0] func3;
    logic func7_5;
    logic [31:0] imm_output;

    // Control signals
    logic reg_write;
    logic alu_src;
    logic [2:0] alu_op;
    logic mem_read;
    logic mem_write;
    logic mem_to_reg;
    logic branch;
    logic auipc;
    logic jump;

    // Register file
    logic [31:0] rs1_data, rs2_data;
    logic [31:0] wb_data;

    // ALU and memory
    logic [31:0] alu_result;
    logic [31:0] mem_data;
    logic zero;
    logic branch_taken;
    logic [31:0] branch_target;

    // PC control
    logic [31:0] pc_offset;
    logic [31:0] jalr_target;
    logic pc_src;

    assign pc_debug = pc;
    assign instruction_debug = instruction;

    // 1. Instruction Fetch
    instruction_fetch FETCH (
        .clk(clk),
        .reset(reset),
        .stall(1'b0),
        .pc_src(pc_src),
        .pc_signed_offset(pc_offset),
        .address(pc),
        .pc_new(pc_plus4)
    );

    // 2. Instruction Memory
    instruction_memory IMEM (
        .address(pc),
        .instruction(instruction)
    );

    // 3. Main Control and Instruction Decode
    maincontrol CONTROL (
        .instruction(instruction),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .opcode(opcode),
        .imm11_5(imm11_5),
        .func3(func3),
        .func7_5(func7_5),
        .imm_output(imm_output),
        .reg_write(reg_write),
        .alu_src(alu_src),
        .alu_op(alu_op),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .mem_to_reg(mem_to_reg),
        .branch(branch),
        .auipc(auipc),
        .jump(jump)
    );

    // 4. Register File
    register_file REGFILE (
        .clk(clk),
        .reset(reset),
        .rs1_sel(rs1),
        .rs2_sel(rs2),
        .rd_sel(rd),
        .wb_data(wb_data),
        .reg_write(reg_write),
        .rs1_data(rs1_data),
        .rs2_data(rs2_data)
    );

    // 5. Execution Unit
    execution_unit EXEC (
        .pc(pc),
        .rs1_data(rs1_data),
        .rs2_data(rs2_data),
        .imm(imm_output),
        .alu_op(alu_op),
        .funct3(func3),
        .funct7_5(func7_5),
        .imm11_5(imm11_5),
        .alu_src(alu_src),
        .branch(branch),
        .auipc(auipc),
        .alu_result(alu_result),
        .branch_target(branch_target),
        .branch_taken(branch_taken),
        .zero(zero)
    );

    // 6. Data Memory
    data_memory DMEM (
        .clk(clk),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .address(alu_result),
        .write_data(rs2_data),
        .read_data(mem_data)
    );

    // 7. Write Back
    writeback_unit WB (
        .alu_result(alu_result),
        .mem_data(mem_data),
        .pc_plus4(pc_plus4),
        .imm(imm_output),
        .mem_to_reg(mem_to_reg),
        .jump(jump),
        .is_lui(opcode == 7'b0110111),
        .wb_data(wb_data)
    );

    // 8. Next PC selection
    assign jalr_target =
        (rs1_data + imm_output) & 32'hFFFFFFFE;

    always_comb begin

        pc_src = branch_taken | jump;

        if (jump && opcode == 7'b1100111)
            pc_offset = jalr_target - pc;
        else
            pc_offset = imm_output;

    end

endmodule
