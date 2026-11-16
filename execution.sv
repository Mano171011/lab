
module execution_unit (
    input logic [31:0] pc,
    input logic [31:0] rs1_data,
    input logic [31:0] rs2_data,
    input logic [31:0] imm,

    input logic [2:0] alu_op,
    input logic [2:0] funct3,
    input logic funct7_5,
    input logic [6:0] imm11_5,

    input logic alu_src,
    input logic branch,
    input logic auipc,

    output logic [31:0] alu_result,
    output logic [31:0] branch_target,
    output logic branch_taken,
    output logic zero
);

    logic [4:0] alu_control_signal;

    logic [31:0] alu_input_a;
    logic [31:0] alu_input_b;

    // Operand A selection
    // AUIPC uses PC as the first operand
    always_comb begin
        if (auipc)
            alu_input_a = pc;
        else
            alu_input_a = rs1_data;
    end

    // Operand B selection
    // Immediate for I-type, load and store instructions
    always_comb begin
        if (alu_src)
            alu_input_b = imm;
        else
            alu_input_b = rs2_data;
    end

    // ALU Control Unit
    alu_control AC (
        .alu_op(alu_op),
        .fn3(funct3),
        .fn7_5(funct7_5),
        .imm11_5(imm11_5),
        .control_out(alu_control_signal)
    );

    // Arithmetic Logic Unit
    alu ALU (
        .alu_control(alu_control_signal),
        .rs1_data(alu_input_a),
        .rs2_data(alu_input_b),
        .alu_out(alu_result),
        .zero(zero)
    );

    // Branch target address calculation
    assign branch_target = pc + imm;

    // Branch decision
    assign branch_taken = branch & zero;

endmodule
