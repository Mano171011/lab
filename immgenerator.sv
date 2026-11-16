
module immgenerator(
    input logic [12:0] imm_input,
    input logic [2:0] fn3,
    input logic [6:0] opcode,
    input logic [19:0] imm_input_uj,
    output logic [31:0] imm_output
);

always_comb begin
    imm_output = 32'b0;
    case(opcode)
        // I-type: ALU immediate
        7'b0010011: begin
            if (fn3 == 3'b001 || fn3 == 3'b101) begin
                imm_output = {27'b0, imm_input[4:0]};
            end
            else begin
                imm_output = {{20{imm_input[11]}}, imm_input[11:0]};
            end
        end
        // Load
        7'b0000011: begin
            imm_output = {{20{imm_input[11]}}, imm_input[11:0]};
        en
        // JALR
        7'b1100111: begin
            imm_output = {{20{imm_input[11]}}, imm_input[11:0]};
        end
        // S-type: Store
        7'b0100011: begin
            imm_output = {{20{imm_input[11]}}, imm_input[11:0]};
        end
        // B-type: Branch
        7'b1100011: begin
            imm_output = {{19{imm_input[12]}}, imm_input};
        end
        // U-type: LUI
        7'b0110111: begin
            imm_output = {imm_input_uj, 12'b0};
        end
        // U-type: AUIPC
        7'b0010111: begin
            imm_output = {imm_input_uj, 12'b0};
        end
        // J-type: JAL
        7'b1101111: begin
            imm_output = {{11{imm_input_uj[19]}},
                          imm_input_uj, 1'b0};
        end
        default: begin
            imm_output = 32'b0;
        end
    endcase
end
endmodule
