
module maincontrol(
    input logic [31:0] instruction,

    output logic [4:0] rs1, rs2, rd,
    output logic [6:0] opcode, imm11_5,
    output logic [2:0] func3,
    output logic func7_5,
    output logic [31:0] imm_output,

    output logic reg_write,
    output logic alu_src,
    output logic [2:0] alu_op,
    output logic mem_read,
    output logic mem_write,
    output logic mem_to_reg,
    output logic branch,
    output logic auipc,
    output logic jump
);
    logic [12:0] imm;
    logic [19:0] imm_uj;
    // Instruction decoder
    instruction_decoder DEC (
        .instruction(instruction),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .opcode(opcode),
        .imm11_5(imm11_5),
        .func3(func3),
        .imm(imm),
        .func7_5(func7_5),
        .imm_uj(imm_uj)
    );
    // Immediate generator
    immgenerator IMM (
        .imm_input(imm),
        .imm_input_uj(imm_uj),
        .fn3(func3),
        .opcode(opcode),
        .imm_output(imm_output)
    );
    // Main control signal generation
    always_comb begin
        // Default control signals
        reg_write = 1'b0;
        alu_src   = 1'b0;
        alu_op    = 3'b000;
        mem_read  = 1'b0;
        mem_write = 1'b0;
        mem_to_reg = 1'b0;
        branch    = 1'b0;
        auipc     = 1'b0;
        jump      = 1'b0;
        case(opcode)
            // R-type: ADD, SUB, AND, OR, XOR, etc.
            7'b0110011: begin
                reg_write = 1'b1;
                alu_src   = 1'b0;
                alu_op    = 3'b010;
            end
            // I-type: ADDI, ANDI, ORI, XORI, SLTI, shifts
            7'b0010011: begin
                reg_write = 1'b1;
                alu_src   = 1'b1;
                alu_op    = 3'b011;
            end
            // Load instructions
            7'b0000011: begin
                reg_write = 1'b1;
                alu_src   = 1'b1;
                alu_op    = 3'b000;
                mem_read  = 1'b1;
                mem_to_reg = 1'b1;
            end
            // Store instructions
            7'b0100011: begin
                alu_src   = 1'b1;
                alu_op    = 3'b000;
                mem_write = 1'b1;
            end
            // Branch instructions
            7'b1100011: begin
                alu_src = 1'b0;
                alu_op  = 3'b001;
                branch  = 1'b1;
            end
            // LUI
            7'b0110111: begin
                reg_write = 1'b1;
                alu_src   = 1'b1;
                alu_op    = 3'b011;
            end
            // AUIPC
            7'b0010111: begin
                reg_write = 1'b1;
                alu_src   = 1'b1;
                alu_op    = 3'b011;
                auipc     = 1'b1;
            end
            // JAL
            7'b1101111: begin
                reg_write = 1'b1;
                jump      = 1'b1;
            end
            // JALR
            7'b1100111: begin
                reg_write = 1'b1;
                jump      = 1'b1;
                alu_src   = 1'b1;
            end
            default: begin
                // All control signals remain at defaults
            end
        endcase
    end

endmodule
