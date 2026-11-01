module instruction_fetch(input logic clk,reset,stall,pc_src,
input logic[31:0]pc_signed_offset,
output logic[31:0] address,
output logic[31:0] pc_new );
logic [31:0]pc_next;
assign pc_new = address+32'h00000004;
always_comb begin 
if(pc_src)
pc_next= address + pc_signed_offset;
else
pc_next= pc_new;
end
always_ff @(posedge clk or posedge reset)
begin
if(reset)
address <= 32'h80000000;
else if(!stall)//so that next instruction comes after proccessing current instruction only
address <= pc_next;
end
endmodule
