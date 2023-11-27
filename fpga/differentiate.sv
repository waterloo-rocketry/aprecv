// TODO: add low-pass to the filter https://ieeexplore.ieee.org/document/8624664
// I. W. Selesnick, "Maximally flat low-pass digital differentiators", http://eeweb.poly.edu/iselesni/lowdiff/lowdiff.m

/*
 * Simple differntiator from https://en.wikipedia.org/wiki/Five-point_stencil
 * the output is scaled by factor of 12
 */

// helper macros
`define sign_extend(x, n) {{(n-$bits(x)){x[$bits(x)-1]}}, x}
`define negate(x) (~x + 1)

module differentiate #(
   parameter INPUT_WIDTH  = 12,
   parameter OUTPUT_WIDTH = 12
) (
   input                     clk,
   input                     clken_i,
   input                     rst_i,
   input                     dvalid_i,
   input  [INPUT_WIDTH-1:0]  x_i,
   output [OUTPUT_WIDTH-1:0] dx_o
);

reg [INPUT_WIDTH-1:0] x[4:0];
reg [INPUT_WIDTH+2:0] intermediate[1:0];
reg [INPUT_WIDTH+2:0] dx;

always @(posedge clk, posedge rst_i) begin
   if(rst_i) begin
      x            <= '{default: 0};
      intermediate <= '{default: 0};
      dx           <= 0;
   end else if(clken_i) begin

      // shift in input
      if(dvalid_i) begin
         x[0] <= x_i;
         for(integer i = 1; i <= 4; i = i+1) begin
            x[i] <= x[i-1];
         end
      end

      // calculate output
      intermediate[0] <= {x[1], 3'b0} + `negate(`sign_extend(x[0], INPUT_WIDTH+3));
      intermediate[1] <= `sign_extend(x[4], INPUT_WIDTH+3) + `negate({x[3], 3'b0});
      dx <= intermediate[1] + intermediate[0];
   end
end

assign dx_o = dx[OUTPUT_WIDTH-1:0];

endmodule
