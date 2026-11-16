module alu_control(input logic [2:0]alu_op,
                      input logic [2:0]fn3,
                      input logic fn7_5,
                      input logic [6:0] imm11_5,
                      output logic [4:0]control_out);
always_comb begin

control_out=5'b00000;

case(alu_op)
3'b000 : begin //R-type
       case(fn3)
       3'b000: begin
              if(fn7_5==0)
              control_out=5'b00000;
              else if(fn7_5==1)
              control_out=5'b00001;
              end
       3'b001: control_out=5'b00101;
       3'b010: control_out=5'b01000;
       3'b011: control_out=5'b01001;
       3'b100: control_out=5'b00010;
                
       3'b101: begin
              if(fn7_5==0)
              control_out=5'b00110;
              else if(fn7_5==1)
              control_out=5'b00111;
              end   
        3'b110: control_out=5'b00011;
        3'b111: control_out=5'b00100;
              
endcase
end

3'b001 : begin //I type-alu
       case(fn3)

        3'b000: control_out = 5'b00000; // ADDI

        3'b001: begin
            if(imm11_5 == 7'b0000000)
            control_out=5'b00101; // SLLI
            end

        3'b010: control_out=5'b01000; // SLTI
        3'b011: control_out=5'b01001; // SLTIU
        3'b100: control_out=5'b00010; // XORI

        3'b101: begin
            if(imm11_5 == 7'b0000000)
            control_out = 5'b00110; // SRLI
            else if(imm11_5 == 7'b0100000)
            control_out = 5'b00111; // SRAI
            end

        3'b110: control_out=5'b00011; // ORI
        3'b111: control_out=5'b00100; // ANDI
endcase
end
      
3'b010,3'b011 : control_out=5'b00000;
    
3'b100 : begin //branch
       case(fn3)
       3'b000: control_out=5'b01010;
       3'b001: control_out=5'b01011;
       3'b100: control_out=5'b01100;
       3'b101: control_out=5'b01101;
       3'b110: control_out=5'b01110;
       3'b111: control_out=5'b01111;
    
endcase
end

3'b110 : control_out=5'b00000;

default: control_out=5'b00000;
endcase
end
endmodule
