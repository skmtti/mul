## 32bit integer multiplier

Since this multiplier is intended to be built into a RISC-V processor, 
it supports unsigned x unsigned, signed x unsigned, and singed x signed 
operations

### Interface signals


signal|I/O|width|discription
---|---|---|---
a|I|[31:0]|operand a
b|I|[31:0]|operand b
ope|I|[1:0]|00b: unsigned x unsigned <br>01b: unsigned x unsigned <br>10b: signed x unsigned <br>11b: unsigned x unsigned|
out|O|[63:0]|multiplier output

