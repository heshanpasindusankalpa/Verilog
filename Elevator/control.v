`timescale 1ns/1ps
module control #(
    parameter N = 4,
    parameter F_BITS = $clog2(N)
)(
    input  wire clk,
    input  wire rst_n,
    input  wire [F_BITS-1:0] cur_floor,
    input  wire [N-1:0] u_buttons,
    input  wire [N-1:0] d_buttons,
    input  wire [N-1:0] f_buttons,
    input  wire served_pulse,      // high when serve completes
    input  wire serve_completing,  // high one cycle before serve completes
    output reg  [1:0] command,
    output reg  [N-1:0] clear_up,
    output reg  [N-1:0] clear_down,
    output reg  [N-1:0] clear_floor
);
    reg [1:0] state_reg;
    integer f_int;
    reg UR_w, DR_w, CR_here;
    
    // Use button states that account for buttons being cleared THIS cycle
    reg [N-1:0] u_eff, d_eff, f_eff;

    function ur(input integer f, input [N-1:0] ub, input [N-1:0] db, input [N-1:0] fb);
        integer j;
        begin
            ur = (ub[f] || fb[f]);
            for (j=f+1; j<N; j=j+1) if (ub[j] || db[j] || fb[j]) ur = 1;
        end
    endfunction

    function dr(input integer f, input [N-1:0] ub, input [N-1:0] db, input [N-1:0] fb);
        integer j;
        begin
            dr = (db[f] || fb[f]);
            for (j=0; j<f; j=j+1) if (ub[j] || db[j] || fb[j]) dr = 1;
        end
    endfunction

    // COMBINATIONAL BLOCK
    always @(*) begin
        f_int = cur_floor;
        
        // Account for buttons that will be cleared this cycle
        u_eff = u_buttons;
        d_eff = d_buttons;
        f_eff = f_buttons;
        
        // If we're issuing clear pulses, remove those buttons from consideration
        if (clear_up[f_int])   u_eff[f_int] = 1'b0;
        if (clear_down[f_int]) d_eff[f_int] = 1'b0;
        if (clear_floor[f_int]) f_eff[f_int] = 1'b0;
        
        UR_w = ur(f_int, u_eff, d_eff, f_eff);
        DR_w = dr(f_int, u_eff, d_eff, f_eff);

        // Determine what to check at current floor
        if (UR_w && (state_reg != 2'b10 || !DR_w)) 
            CR_here = (u_eff[f_int] || f_eff[f_int]);
        else
            CR_here = (d_eff[f_int] || f_eff[f_int]);

        // Command decision - don't serve if we just completed serving
        if (CR_here && !served_pulse) begin
            command = 2'b11; // Serve
        end else if (UR_w && (state_reg != 2'b10 || !DR_w)) begin
            command = 2'b01; // Up
        end else if (DR_w) begin
            command = 2'b10; // Down
        end else begin
            command = 2'b00; // Idle
        end
    end

    // SEQUENTIAL BLOCK
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state_reg <= 2'b00;
            clear_up <= 0;
            clear_down <= 0;
            clear_floor <= 0;
        end else begin
            // Update direction memory
            if (command == 2'b01) state_reg <= 2'b01;
            else if (command == 2'b10) state_reg <= 2'b10;
            else if (command == 2'b00) state_reg <= 2'b00;

            // Default: no clears
            clear_up    <= 0;
            clear_down  <= 0;
            clear_floor <= 0;

            // Issue clear pulses one cycle BEFORE serve completes
            // so buttons are cleared synchronously with served_pulse
            if (serve_completing) begin
                clear_floor[f_int] <= 1'b1;
                if (state_reg == 2'b10) clear_down[f_int] <= 1'b1;
                else                    clear_up[f_int]   <= 1'b1;
            end
        end
    end
endmodule

// elevator_body.v - UPDATED VERSION
// Now out
