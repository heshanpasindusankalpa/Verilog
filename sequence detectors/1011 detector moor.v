module moore_seq_detector_1011(
    input  wire clk,
    input  wire reset,
    input  wire x,
    output wire y
);

    // --- State encoding ---
    localparam S0_IDLE      = 3'b000;
    localparam S1_GOT_1     = 3'b001;
    localparam S2_GOT_10    = 3'b010;
    localparam S3_GOT_101   = 3'b011;
    localparam S4_GOT_1011  = 3'b100;

    // --- State registers ---
    reg [2:0] current_state, next_state;

    // --- State transition on clock or reset ---
    always @(posedge clk or posedge reset) begin
        if (reset)
            current_state <= S0_IDLE;
        else
            current_state <= next_state;
    end

    // --- Next state logic ---
    always @(*) begin
        case (current_state)
            S0_IDLE: begin
                if (x)
                    next_state = S1_GOT_1;
                else
                    next_state = S0_IDLE;
            end

            S1_GOT_1: begin
                if (x)
                    next_state = S1_GOT_1;  // still 1
                else
                    next_state = S2_GOT_10;
            end

            S2_GOT_10: begin
                if (x)
                    next_state = S3_GOT_101;
                else
                    next_state = S0_IDLE;
            end

            S3_GOT_101: begin
                if (x)
                    next_state = S4_GOT_1011; // sequence detected
                else
                    next_state = S2_GOT_10;   // back to 10
            end

            S4_GOT_1011: begin
                if (x)
                    next_state = S1_GOT_1;   // overlap case: last 1 can start new sequence
                else
                    next_state = S2_GOT_10;
            end

            default: next_state = S0_IDLE;
        endcase
    end

    // --- Output logic (Moore output depends on state only) ---
    assign y = (current_state == S4_GOT_1011);

endmodule
