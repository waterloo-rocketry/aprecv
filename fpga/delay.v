module delay #(
   parameter DELAY_CYCLES,
   parameter WIDTH = 12
) (
   input             clk,
   input             clken_i,
   input             rst_i,
   input             dvalid_i,
   input [WIDTH-1:0] data_i,
   ouput [WIDTH-1:0] data_o
);

reg [WIDTH-1:0] delay_regs [DELAY_CYCLES-1:0];

always @(posedge clk, posedge rst_i) begin
   if(rst_i) begin
      delay_regs <= '{default: 0};
   end else if(dvalid_i) begin
      x[0] <= x_i;
      for(integer i = 1; i <= DELAY_CYCLES; i = i+1) begin
         x[i] <= x[i-1];
      end
   end
end

assign data_o = delay_regs[DELAY_CYCLES-1];

endmodule
