module immgenerator(input logic [11:0]imm_input,
                    input logic [2:0]fn3,
                    input logic [6:0]opcode,
                    input logic [19:0]imm_input_uj,
                    output logic [31:0]imm_output);
                   
always_comb 
begin
imm_output=32'b0;

case(opcode)
        7'b0010011: begin  // I-type: ALU immediate
            if (fn3 == 3'b001) begin // SLLI 
                imm_output = {27'b0, imm_input[4:0]}; 
            end 
            else if (fn3 == 3'b101) begin  // SRLI / SRAI
                imm_output = {27'b0, imm_input[4:0]}; 
            end 
            else begin // ADDI, ANDI, ORI, XORI, SLTI, SLTIU 
                imm_output = {{20{imm_input[11]}}, imm_input}; 
            end
        end
        7'b0000011: begin // Load
            imm_output = {{20{imm_input[11]}}, imm_input};
        end
        7'b1100111: begin // JALR
            imm_output = {{20{imm_input[11]}}, imm_input};
        end
        7'b0100011: begin // S-type: Store
            imm_output = {{20{imm_input[11]}}, imm_input};
        end
        7'b1100011: begin // B-type: Branch
            imm_output = {{20{imm_input[11]}}, imm_input} << 1;
        end
        7'b0110111: begin // U-type: LUI
            imm_output = {imm_input_uj, 12'b0};
        end
        7'b0010111: begin // U-type: AUIPC
            imm_output = {imm_input_uj, 12'b0};
        end
        7'b1101111: begin // J-type: JAL
            imm_output = {{12{imm_input_uj[19]}}, imm_input_uj} << 1;
        end
        default: begin
            imm_output = 32'b0;
        end
    endcase
end
endmodule
