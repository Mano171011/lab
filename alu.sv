module alu(input logic [4:0]alu_control,
           input logic [31:0]rs1_data,
           input logic [31:0]rs2_data,
           output logic [31:0]alu_out,
           output logic zero);
           
logic signed [31:0]rs1_signed;
logic signed [31:0]rs2_signed;

assign rs1_signed=$signed(rs1_data);
assign rs2_signed=$signed(rs2_data);

always_comb begin

alu_out=32'b0;
zero=1'b0;

case(alu_control)

5'b00000: alu_out = rs1_data + rs2_data;
5'b00001: alu_out = rs1_data - rs2_data;

5'b00010: alu_out = rs1_data ^ rs2_data;
5'b00011: alu_out = rs1_data | rs2_data;
5'b00100: alu_out = rs1_data & rs2_data;

5'b00101: alu_out = rs1_data << rs2_data;
5'b00110: alu_out = rs1_data >> rs2_data;
5'b00111: alu_out = rs1_data >>> rs2_data;

5'b01000: alu_out = (rs1_signed < rs2_signed) ? 32'd1 : 32'd0;
5'b01001: alu_out = (rs1_data < rs2_data) ? 32'd1 : 32'd0;

5'b01010: zero = (rs1_data == rs2_data);
5'b01011: zero = (rs1_data != rs2_data);
5'b01100: zero = (rs1_signed < rs2_signed);
5'b01101: zero = (rs1_signed >= rs2_signed);
5'b01110: zero = (rs1_data < rs2_data);
5'b01111: zero = (rs1_data >= rs2_data);

default: begin
        alu_out=32'b0;
        zero=1'b0;
        end
endcase
end         
endmodule
