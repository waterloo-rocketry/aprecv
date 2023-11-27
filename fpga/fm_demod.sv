module fm_demod #(
   WIDTH = 10
) (
   input              clk,
   input              clken_i,
   input              rst_i,
   input [WIDTH-1:0]  I_i,
   input [WIDTH-1:0]  Q_i,
   input              dvalid_i,
   output [WIDTH-1:0] data_o
);

wire [WIDTH-1:0] result;

differentiate #(
   .INPUT_WIDTH  (WIDTH),
   .OUTPUT_WIDTH (8)
) differentiate_u1 (
   .clk       (clk),
   .clken_i   (1),
   .dvalid_i  (dvalid_i),
   .rst_i     (rst_i),
   .x_i       (I_i),
   .dx_o      ()
);

//divide divide_u1 (
//   .numer     (I_i),
//   .denom     (Q_i),
//   .clken     (clken_i),
//   .clk       (clk),
//   .reset     (rst_i),
//   .quotient  (result),
//   .remain    ()
//);

assign data_o = result;

endmodule
