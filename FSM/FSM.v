module divby3(
    input wire clk,
    input wire reset,
    output reg y
);
    parameter s0 = 2'b00;
    parameter s1 = 2'b01;
    parameter s2 = 2'b10;

    reg [1:0] state;
    reg [1:0] next_state;

    // Sequential logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= s0;
            y <= 1'b0;
        end else begin
            state <= next_state;

            // Output logic (registered)
            if (next_state == s0)
                y <= 1'b1;
            else
                y <= 1'b0;
        end
    end

    // Next-state logic (combinational)
    always @(*) begin
        case (state)
            s0: next_state = s1;
            s1: next_state = s2;
            s2: next_state = s0;
            default: next_state = s0;
        endcase
    end
endmodule

