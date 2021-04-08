package riscv_pkg;

typedef enum logic [1:0] {
    MULL   = 2'b00,
    MULH   = 2'b01,
    MULHSU = 2'b10,
    MULHU  = 2'b11
} mul_ope_e;

endpackage
