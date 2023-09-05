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

wire data;
wire rst = ~nrst_i;

reg [7:0] counter;

fm_demod fm_demod_u1 (
   .clk       (main_clk),
   .rst_i     (rst),
   .I_i       (0),
   .Q_i       (0),
   .dvalid_i  (0),
   .data_o    ()
);

always @(posedge main_clk, posedge rst) begin
   if(rst) begin
      counter <= 0;
   end else begin
      counter <= counter + 1;
   end
end

assign pll_rst_o = rst;

endmodule
