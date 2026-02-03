`timescale 1ns/1ps
module sha256_datapath (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        init_regs,
    input  wire        round_en,
    input  wire        done,

    input  wire [31:0] T1,
    input  wire [31:0] T2,

    input  wire [31:0] H0,
    input  wire [31:0] H1,
    input  wire [31:0] H2,
    input  wire [31:0] H3,
    input  wire [31:0] H4,
    input  wire [31:0] H5,
    input  wire [31:0] H6,
    input  wire [31:0] H7,

    output reg  [31:0] A,
    output reg  [31:0] B,
    output reg  [31:0] C,
    output reg  [31:0] D,
    output reg  [31:0] E,
    output reg  [31:0] F,
    output reg  [31:0] G,
    output reg  [31:0] H,

    output wire [255:0] hash_out
);
reg [31:0] H0_reg, H1_reg, H2_reg, H3_reg, H4_reg, H5_reg, H6_reg, H7_reg;

reg [255:0] hash_reg;
assign hash_out= hash_reg;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            A <= 32'd0;
            B <= 32'd0;
            C <= 32'd0;
            D <= 32'd0;
            E <= 32'd0;
            F <= 32'd0;
            G <= 32'd0;
            H <= 32'd0;

            H0_reg <= 32'd0;
            H1_reg <= 32'd0;
            H2_reg <= 32'd0;
            H3_reg <= 32'd0;
            H4_reg <= 32'd0;
            H5_reg <= 32'd0;
            H6_reg <= 32'd0;
            H7_reg <= 32'd0;
        end

        else if (init_regs) begin
            A <= H0;
            B <= H1;
            C <= H2;
            D <= H3;
            E <= H4;
            F <= H5;
            G <= H6;
            H <= H7;

            H0_reg <= H0;
            H1_reg <= H1;
            H2_reg <= H2;
            H3_reg <= H3;
            H4_reg <= H4;
            H5_reg <= H5;
            H6_reg <= H6;
            H7_reg <= H7;
        end

        else if (round_en) begin
            A <= T1 + T2;
            B <= A;
            C <= B;
            D <= C;
            E <= D + T1;
            F <= E;
            G <= F;
            H <= G;
        end
    end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        hash_reg <= 256'd0;
    end
    else if (done) begin
        hash_reg <= {
            H0_reg + A,
            H1_reg + B,
            H2_reg + C,
            H3_reg + D,
            H4_reg + E,
            H5_reg + F,
            H6_reg + G,
            H7_reg + H
        };
    end
end

endmodule