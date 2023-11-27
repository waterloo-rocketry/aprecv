module top (
   input  main_clk,
   input  nrst_i,
   input  rf_i,
   input  sclk_i,
   input  cs_i,
   output sdo_o,
   output pll_rst_o,
   input  pll_locked_i
);

wire [9:0] data;
wire rst = ~nrst_i;

reg [9:0] counter;

const_multiplier #(
   .CONST_FACTOR(3)
) const_multiplier_u1 (
   .clk(main_clk),
   .data_i(counter),
   .product_o(data)
);

always @(posedge main_clk, posedge rst) begin
   if(rst) begin
      counter <= 0;
   end else begin
      counter <= counter + 1;
   end
end

assign pll_rst_o = rst;
assign sdo_o = ^data;

endmodule
