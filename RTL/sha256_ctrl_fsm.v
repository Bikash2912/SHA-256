`timescale 1ns/1ps

module sha256_ctrl_fsm (
    input  wire       clk,
    input  wire       rst_n,
    input  wire       start,
    input  wire [5:0] round_cnt,

    output reg        init_regs,
    output reg        round_en,
    output reg        round_cnt_en,
    output reg        round_cnt_clr,
    output reg        done
);

    localparam [2:0]
        IDLE     = 3'b000,
        INIT     = 3'b001,
        ROUND    = 3'b010,
        FINALIZE = 3'b011,
        DONE     = 3'b100;

    reg [2:0] state, next_state;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next-state logic
    always @(*) begin
        next_state = state;
        case (state)

            IDLE: begin
                if (start)
                    next_state = INIT;
            end

            INIT: begin
                next_state = ROUND;
            end

            ROUND: begin
                if (round_cnt == 6'd63)
                    next_state = FINALIZE;   // last round just executed
                else
                    next_state = ROUND;
            end

            FINALIZE: begin
                next_state = DONE;           // wait one full cycle
            end

            DONE: begin
                next_state = IDLE;           // ready for next block
            end

            default: next_state = IDLE;
        endcase
    end

    // Output logic
    always @(*) begin
        // defaults
        init_regs     = 1'b0;
        round_en      = 1'b0;
        round_cnt_en  = 1'b0;
        round_cnt_clr = 1'b0;
        done          = 1'b0;

        case (state)

            INIT: begin
                init_regs     = 1'b1;   // one cycle only
                round_cnt_clr = 1'b1;
            end

            ROUND: begin
                round_en      = 1'b1;   // execute round
                round_cnt_en  = 1'b1;   // increment counter
            end

            FINALIZE: begin
                // NO round_en here
                // datapath  holds FINAL state
            end

            DONE: begin
                done = 1'b1;            // capture hash here
            end

        endcase
    end

endmodule
