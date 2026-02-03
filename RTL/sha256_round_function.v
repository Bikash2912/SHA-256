`timescale 1ns/1ps
module sha256_round_function (
    input  wire [31:0] A,
    input  wire [31:0] B,
    input  wire [31:0] C,
    input  wire [31:0] D,
    input  wire [31:0] E,
    input  wire [31:0] F,
    input  wire [31:0] G,
    input  wire [31:0] H,
    input  wire [31:0] W_t,
    input  wire [31:0] K_t,
    output wire [31:0] T1,
    output wire [31:0] T2,
    output wire [31:0] dbg_sigma1_e,
    output wire [31:0] dbg_ch,
    output wire [31:0] dbg_H,
    output wire [31:0] dbg_K,
    output wire [31:0] dbg_W

);
wire [31:0] Sigma1_E_dbg;
wire [31:0] Ch_EFG_dbg;

    wire [31:0] ROTR_A_2  = {A[1:0],  A[31:2]};
    wire [31:0] ROTR_A_13 = {A[12:0], A[31:13]};
    wire [31:0] ROTR_A_22 = {A[21:0], A[31:22]};

    wire [31:0] ROTR_E_6  = {E[5:0],  E[31:6]};
    wire [31:0] ROTR_E_11 = {E[10:0], E[31:11]};
    wire [31:0] ROTR_E_25 = {E[24:0], E[31:25]};

    // -------- Σ functions --------
    wire [31:0] Sigma0_A = ROTR_A_2  ^ ROTR_A_13 ^ ROTR_A_22;
    wire [31:0] Sigma1_E = ROTR_E_6  ^ ROTR_E_11 ^ ROTR_E_25;

    // -------- Choice & Majority --------
    wire [31:0] ch_EFG  = (E & F) ^ (~E & G);
    wire [31:0] maj_ABC = (A & B) ^ (A & C) ^ (B & C);

    // -------- T1 / T2 --------
    // assign T1 = H + Sigma1_E + ch_EFG + K_t + W_t;
    // assign T2 = Sigma0_A + maj_ABC;
    assign T1 = (H + Sigma1_E + ch_EFG + K_t + W_t) & 32'hFFFFFFFF;
    assign T2 = (Sigma0_A + maj_ABC) & 32'hFFFFFFFF;



assign Sigma1_E_dbg = ROTR_E_6 ^ ROTR_E_11 ^ ROTR_E_25;
assign Ch_EFG_dbg   = (E & F) ^ (~E & G);

assign dbg_sigma1_e = Sigma1_E_dbg;
assign dbg_ch       = Ch_EFG_dbg;

assign dbg_H = H;
assign dbg_K = K_t;
assign dbg_W = W_t;

endmodule
