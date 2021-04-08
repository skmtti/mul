`timescale 1ns/1ps

module tb import riscv_pkg::*; ();
  localparam int unsigned DATA_WIDTH=32;
  localparam int unsigned D1 = 1;
  logic [DATA_WIDTH-1:0] a;
  logic [DATA_WIDTH-1:0] b;
  mul_ope_e ope;
  logic [DATA_WIDTH*2-1:0] out;

  mul mul(.*);

  bit   fail = 0;

  initial begin
    $dumpfile("wave.fst");
    $dumpvars(0, tb);
  end

  `include "test.h"

endmodule

