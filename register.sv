module register_file(input logic [4:0] rs1_sel,rs2_sel,rd_sel,
                          input logic [31:0]wb_data,input logic reg_write,
                          input logic clk,reset,
                          output logic [31:0]rs1_data,rs2_data);
logic[31:0]registerfile[31:0];
logic i;
always_ff @(posedge clk or posedge reset) 
begin
if(reset)begin
registerfile <= '{default : 0};
end
else if(reg_write && (rd_sel!=0)) begin
registerfile[rd_sel]<=wb_data;
end
end
assign rs1_data = registerfile[rs1_sel];
assign rs2_data = registerfile[rs2_sel];
endmodule
