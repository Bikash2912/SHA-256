`timescale 1ns/1ps

module sha256_round_counter (
    input  wire       clk,
    input  wire       rst_n,
    input  wire       enable,
    input  wire       clear,
    output reg  [5:0] round_cnt
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            round_cnt <= 6'd0;
        end
        else if (clear) begin
            round_cnt <= 6'd0;
        end
        else if (enable) begin
            round_cnt <= round_cnt + 6'd1;
        end
    end

endmodule
