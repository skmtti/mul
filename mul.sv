module mul import riscv_pkg::*; (
input logic [DATA_WIDTH-1:0]a,
input logic [DATA_WIDTH-1:0]b,
input mul_ope_e ope,
output logic [DATA_WIDTH*2-1:0]out
);

localparam int unsigned DATA_WIDTH = 32;

logic [DATA_WIDTH*2-1:0]p[DATA_WIDTH:0];
logic [DATA_WIDTH:0]x[DATA_WIDTH-1:0];

genvar i, j;
generate
for (i = 0; i < DATA_WIDTH; i++) begin
    always_comb begin
        p[i] = '0;

        // create partial product
        x[i] = {1'b0, a & {DATA_WIDTH{b[i]}}}; 

        unique case(ope)
         MULL, MULHU : ;
         MULH : 
            if (i == 0) begin
                x[i][DATA_WIDTH] = 1'b1;
                x[i][DATA_WIDTH-1] = ~x[i][DATA_WIDTH-1];
            end else if (i == DATA_WIDTH-1) begin
                x[i][DATA_WIDTH] = 1'b1;
                x[i][DATA_WIDTH-2:0] = ~x[i][DATA_WIDTH-2:0];
            end else begin
                x[i][DATA_WIDTH-1] = ~x[i][DATA_WIDTH-1];
            end  
         MULHSU : 
            if (i == DATA_WIDTH-1) begin
                x[i][DATA_WIDTH] = 1'b1;
                x[i][DATA_WIDTH-1] = ~x[i][DATA_WIDTH-1];
            end else begin
                x[i][DATA_WIDTH-1] = ~x[i][DATA_WIDTH-1];
            end  
        endcase

        p[i][DATA_WIDTH+i:i] = x[i];
    end
end
endgenerate

always_comb begin
    p[DATA_WIDTH] = '0;
    if (ope == MULHSU) begin
        p[DATA_WIDTH][DATA_WIDTH-1] = 1'b1;
    end
end


//level 1

wire [64:0]p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12,p13,p14,p15,p16,p17,p18,p19,p20,p21,p22;

csa l11(p[0],p[1],p[2],p1,p2);
csa l12(p[3],p[4],p[5],p3,p4);
csa l13(p[6],p[7],p[8],p5,p6);
csa l14(p[9],p[10],p[11],p7,p8);
csa l15(p[12],p[13],p[14],p9,p10);
csa l16(p[15],p[16],p[17],p11,p12);
csa l17(p[18],p[19],p[20],p13,p14);
csa l18(p[21],p[22],p[23],p15,p16);
csa l19(p[24],p[25],p[26],p17,p18);
csa l110(p[27],p[28],p[29],p19,p20);
csa l111(p[30],p[31],p[32],p21,p22);



//level 2
wire [64:0]q1,q2,q3,q4,q5,q6,q7,q8,q9,q10,q11,q12,q13,q14,q15;

csa  l21(p1[63:0],p2[63:0],p3[63:0],q1,q2);
csa  l22(p4[63:0],p5[63:0],p6[63:0],q3,q4);
csa  l23(p7[63:0],p8[63:0],p9[63:0],q5,q6);
csa  l24(p10[63:0],p11[63:0],p12[63:0],q7,q8);
csa  l25(p13[63:0],p14[63:0],p15[63:0],q9,q10);
csa  l26(p16[63:0],p17[63:0],p18[63:0],q11,q12);
csa  l27(p19[63:0],p20[63:0],p21[63:0],q13,q14);

assign q15=p22;

//level 3
wire [64:0]r1,r2,r3,r4,r5,r6,r7,r8,r9,r10;

csa  l31(q1[63:0],q2[63:0],q3[63:0],r1,r2);
csa  l32(q4[63:0],q5[63:0],q6[63:0],r3,r4);
csa  l33(q7[63:0],q8[63:0],q9[63:0],r5,r6);
csa  l34(q10[63:0],q11[63:0],q12[63:0],r7,r8);
csa  l35(q13[63:0],q14[63:0],q15[63:0],r9,r10);


//level 4
wire [64:0]s1,s2,s3,s4,s5,s6,s7;

csa  l41(r1[63:0],r2[63:0],r3[63:0],s1,s2);
csa  l42(r4[63:0],r5[63:0],r6[63:0],s3,s4);
csa  l43(r7[63:0],r8[63:0],r9[63:0],s5,s6);
assign s7=r10;


//level 5
wire [64:0]t1,t2,t3,t4,t5;

csa  l51(s1[63:0],s2[63:0],s3[63:0],t1,t2);
csa  l52(s4[63:0],s5[63:0],s6[63:0],t3,t4);
assign t5=s7;


//level 6
wire [64:0]u1,u2,u3,u4;

csa  l61(t1[63:0],t2[63:0],t3[63:0],u1,u2);
assign u3=t4;
assign u4=t5;


//level 7
wire [64:0]v1,v2,v3;

csa  l71(u1[63:0],u2[63:0],u3[63:0],v1,v2);
assign v3=u4;


//level 8
wire [64:0]w1,w2;

csa  l81(v1[63:0],v2[63:0],v3[63:0],w1,w2);


//level 9 prefix adder call
wire [64:0]mult;

//prefix_pipe pre(w1[31:0],w2[31:0],0,mult[31:0],cout,clk);
//prefix_pipe pre1(w1[63:32],w2[63:32],cout,mult[63:32],Cout,clk);
assign mult = w1 + w2;
assign out=mult[63:0];


endmodule // multiplier



module csa(a,b,c,sum,carry);

input [63:0]a,b,c;
output [64:0]sum,carry;

assign sum[63:0]=a^b^c;
assign carry[64:1]= a&b | b&c | c&a;
assign carry[0]=0;
assign sum[64]=0;

endmodule // csa

