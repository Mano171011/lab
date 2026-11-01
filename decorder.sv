module instruction_decoder(input logic [31:0] instruction,
          output logic [4:0] rs1,rs2,rd,
          output logic [6:0] opcode,imm11_5,
          output logic [2:0] func3,
          output logic [12:0] imm,
          output logic func7_5, // 5th bit as only that bit changes
          output logic [19:0] imm_uj );
          
always_comb
begin
opcode=instruction[6:0];

rd = instruction[11:7];
func3 = instruction[14:12];
rs1 = instruction[19:15];
rs2 = instruction[24:20];
func7_5 = instruction[30];
imm11_5 = instruction[31:25];
case(opcode) 
                         7'b0010011, 7'b0000011, 7'b1100111: begin // I-type (ALU imm, load, jalr)
                         imm     = instruction[31:20];
                         end
                         7'b0100011: begin // S-type (store)
                         imm     = {instruction[31:25], instruction[11:7]}; // full 12-bit offset
                         end
                         7'b1100011: begin // B-type (branch)
                         imm     = {instruction[31], instruction[7], instruction[30:25], instruction[11:8]}; // imm[12:1]
                         end
                         7'b0110111, 7'b0010111: begin // U-type (lui, auipc)
                         imm_uj = instruction[31:12];  // upper 20 bits
                         end
                         7'b1101111: begin // J-type (jal)
                         imm_uj = {instruction[31], instruction[19:12], instruction[20], instruction[30:21]}; // imm[20:1]
                         end
default:begin 
            rd = 5'd0;
            func3=3'd0;
            rs1=5'd0;
            rs2=5'd0;
            imm=12'd0;
            imm_uj=20'd0;
            imm11_5=7'd0;
            func7_5=1'd0;
            end
endcase
end                    
endmodule
