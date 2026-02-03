`timescale 1ns/1ps

module sha256_message_schedule (
    input  wire         clk,
    input  wire         rst_n,
    input  wire         init,
    input  wire [5:0]   round_cnt,
    input  wire [511:0] message_block,
    output reg  [31:0]  W_t
);

    // 16-word sliding window
    reg [31:0] W [0:15];
    reg [31:0] new_W;

    integer i;

    // ----------- σ functions ----------- 
    function [31:0] sigma0;
        input [31:0] x;
        begin
            sigma0 = {x[6:0],  x[31:7]} ^
                     {x[17:0], x[31:18]} ^
                     (x >> 3);
        end
    endfunction

    function [31:0] sigma1;
        input [31:0] x;
        begin
            sigma1 = {x[16:0], x[31:17]} ^
                     {x[18:0], x[31:19]} ^
                     (x >> 10);
        end
    endfunction

    // ----------- Precompute next word ----------- 
    always @(*) begin
        new_W = sigma1(W[14]) + W[9] + sigma0(W[1]) + W[0];
    end

    // ----------- Sequential logic ----------- 
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < 16; i = i + 1)
                W[i] <= 32'd0;
        end
        else if (init) begin
            // Load first 16 words from message block
            for (i = 0; i < 16; i = i + 1) begin
                W[i] <= {
                    message_block[511 - (i*32)     -: 8],
                    message_block[511 - (i*32 + 8) -: 8],
                    message_block[511 - (i*32 +16) -: 8],
                    message_block[511 - (i*32 +24) -: 8]
                };
            end
        end
        else if (round_cnt >= 6'd16) begin
            W[0]  <= W[1];
            W[1]  <= W[2];
            W[2]  <= W[3];
            W[3]  <= W[4];
            W[4]  <= W[5];
            W[5]  <= W[6];
            W[6]  <= W[7];
            W[7]  <= W[8];
            W[8]  <= W[9];
            W[9]  <= W[10];
            W[10] <= W[11];
            W[11] <= W[12];
            W[12] <= W[13];
            W[13] <= W[14];
            W[14] <= W[15];
            W[15] <= new_W;
        end
    end

    // ----------- Output selection ----------- 
    always @(*) begin
        if (round_cnt < 6'd16)
            W_t = W[round_cnt];
        else
            W_t = new_W;
    end

endmodule
