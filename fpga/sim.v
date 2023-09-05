`timescale 1ns/1ps

module sim;

localparam CAPTURE_FILE = "../gnuradio/capture.data"; // in IQIQIQ format
localparam DUMP_FILE = "outflow/sim.vcd";

localparam MAIN_FREQ  = 200e6;
localparam SAMP_FREQ = 1e6;

reg main_clk      = 0;
reg reset         = 0;

reg [9:0] I            = 0;
reg [9:0] Q            = 0;
reg       sample_event = 0;
reg       dvalid       = 0;

always #(500e6 / MAIN_FREQ) main_clk = ~main_clk;

fm_demod fm_demod_u1 (
   .clk       (main_clk),
   .clken_i   (1'b1),
   .rst_i     (reset),
   .I_i       (I),
   .Q_i       (Q),
   .dvalid_i  (dvalid),
   .data_o    ()
);

reg sample_event_d1;
always @(posedge main_clk) begin
   if(sample_event != sample_event_d1) begin
      dvalid = 1;
   end else begin
      dvalid = 0;
   end

   sample_event_d1 <= sample_event;
end

integer fd, r;
reg [15:0] sample;
initial begin
   $dumpfile(DUMP_FILE);
   $dumpvars;

   reset = 1;
   #1000
   reset = 0;

   fd = $fopen(CAPTURE_FILE, "rb");

   if(fd == 0) begin
      $display("open capture file failed");
      $finish;
   end

   while(!$feof(fd)) begin
      r = $fread(sample, fd);
      Q = {sample[7:0], sample[15:14]};

      r = $fread(sample, fd);
      I = {sample[7:0], sample[15:14]};

      sample_event = ~sample_event;

      #(1e9 / SAMP_FREQ);
   end

   $fclose(fd);
   $finish;
end

endmodule;
