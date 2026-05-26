`timescale 1ns/1ps
module sha256_top (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        start,
    input  wire [511:0] message_block,

    output wire [255:0] hash_out,
    output wire        done
);
    wire init_regs;
    wire round_en;
    wire round_cnt_en;
    wire round_cnt_clr;
    wire [5:0] round_cn
    wire [31:0] K_t;
    wire [31:0] H0, H1, H2, H3, H4, H5, H6, H7;
    wire [31:0] W_t;
    wire [31:0] A, B, C, D, E, F, G, H;
    wire [31:0] T1, T2;
    reg [5:0] round_cnt_d;

    sha256_ctrl_fsm u_ctrl_fsm (
        .clk          (clk),
        .rst_n        (rst_n),
        .start        (start),
        .round_cnt    (round_cnt),
        .init_regs    (init_regs),
        .round_en     (round_en),
        .round_cnt_en (round_cnt_en),
        .round_cnt_clr(round_cnt_clr),
        .done         (done)
    );

    sha256_round_counter u_round_counter (
        .clk       (clk),
        .rst_n     (rst_n),
        .enable    (round_cnt_en),
        .clear     (round_cnt_clr),
        .round_cnt (round_cnt)
    );

    sha256_constants u_constants (
        .round_cnt (round_cnt),
        .K_t       (K_t),
        .H0        (H0),
        .H1        (H1),
        .H2        (H2),
        .H3        (H3),
        .H4        (H4),
        .H5        (H5),
        .H6        (H6),
        .H7        (H7)
    );

    sha256_message_schedule u_msg_schedule (
        .clk           (clk),
        .rst_n         (rst_n),
        .init          (init_regs),
        .round_cnt     (round_cnt),
        .message_block (message_block),
        .W_t           (W_t));
    
    sha256_round_function u_round_function (
        .A   (A),
        .B   (B),
        .C   (C),
        .D   (D),
        .E   (E),
        .F   (F),
        .G   (G),
        .H   (H),
        .W_t (W_t),
        .K_t (K_t),
        .T1  (T1),
        .T2  (T2)
    );

    sha256_datapath u_datapath (
        .clk       (clk),
        .rst_n     (rst_n),
        .init_regs (init_regs),
        .round_en  (round_en),
        .done      (done), 
        .T1        (T1),
        .T2        (T2),
        .H0        (H0),
        .H1        (H1),
        .H2        (H2),
        .H3        (H3),
        .H4        (H4),
        .H5        (H5),
        .H6        (H6),
        .H7        (H7),
        .A         (A),
        .B         (B),
        .C         (C),
        .D         (D),
        .E         (E),
        .F         (F),
        .G         (G),
        .H         (H),
        .hash_out  (hash_out)
    );
// always @(posedge clk or negedge rst_n) begin
//     if (!rst_n)
//         W_t_reg <= 32'd0;
//     else
//         W_t_reg <= W_t;
// end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        round_cnt_d <= 6'd0;
    else
        round_cnt_d <= round_cnt;
end

endmodule
