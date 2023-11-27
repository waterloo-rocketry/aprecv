module const_multiplier #(
   parameter CONST_FACTOR,
   parameter INPUT_WIDTH  = 10,
   parameter OUTPUT_WIDTH = 10
) (
   input                         clk,
   input      [INPUT_WIDTH-1:0]  data_i,
   output reg [OUTPUT_WIDTH-1:0] product_o
);

reg [OUTPUT_WIDTH-1:0] product_lut[2**INPUT_WIDTH-1:0];

initial begin
   for(integer i = 0; i < 2**INPUT_WIDTH; i = i+1) begin
      integer product = i * CONST_FACTOR;
      product_lut[i] = product[OUTPUT_WIDTH-1:0];
   end
end

always @(posedge clk) begin
   product_o <= product_lut[data_i];
end

endmodule
