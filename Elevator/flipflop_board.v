// flipflop_board.v
// N-bit set/reset flipflop array. set_i is pulse to set bit i, reset_i pulses clear.
// Inputs are one-hot pulses (vectors) where a '1' on a bit sets/resets that flipflop.
`timescale 1ns/1ps
module flipflop_board #(
    parameter N = 4
)(
    input  wire clk,
    input  wire rst_n,
    input  wire [N-1:0] set_pulse,   // pulse to set bit
    input  wire [N-1:0] reset_pulse, // pulse to reset bit (higher priority)
    output reg  [N-1:0] state_out
);
    integer i;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state_out <= {N{1'b0}};
        end else begin
            for (i=0; i<N; i=i+1) begin
                if (reset_pulse[i]) state_out[i] <= 1'b0;
                else if (set_pulse[i]) state_out[i] <= 1'b1;
                // else retain
            end
        end
    end
endmodule
