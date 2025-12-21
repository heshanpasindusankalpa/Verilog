// control.v
// Implements CurrentState and CurrentCommand as in the paper.
// Inputs: current floor, button state vectors (u_buttons, d_buttons, f_buttons).
// Outputs: command (idle/up/down/serve) and clear pulses for flipflops when service completes.
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
    input  wire served_pulse, // from body: one-cycle when serve finishes
    output reg  [1:0] command,
    output reg  [N-1:0] clear_up,    // one-cycle pulses to reset flipflops
    output reg  [N-1:0] clear_down,
    output reg  [N-1:0] clear_floor
);
    // Controller state memory (last state)
    reg [1:0] last_state; // 00 idle, 01 up, 10 down
    // helper wires
    integer i;
    function ur;
        input integer f;
        integer j;
        begin
            ur = 0;
            // ub(f) OR any request above f
            if (u_buttons[f] || f_buttons[f]) ur = 1;
            for (j=f+1; j<N; j=j+1) begin
                if (u_buttons[j] || d_buttons[j] || f_buttons[j]) ur = 1;
            end
        end
    endfunction

    function dr;
        input integer f;
        integer j;
        begin
            dr = 0;
            if (d_buttons[f] || f_buttons[f]) dr = 1;
            for (j=0; j<f; j=j+1) begin
                if (u_buttons[j] || d_buttons[j] || f_buttons[j]) dr = 1;
            end
        end
    endfunction

    function cr; // current request at this floor given assumed CS
        input integer f;
        input [1:0] cs;
        begin
            if (cs == 2'b10) // down
                cr = (d_buttons[f] || f_buttons[f]);
            else
                cr = (u_buttons[f] || f_buttons[f]);
        end
    endfunction

    // Synchronous update of control state and outputs
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            last_state <= 2'b00; // idle
            command <= 2'b00;
            clear_up <= 0;
            clear_down <= 0;
            clear_floor <= 0;
        end else begin
            // default clears are 0 (one-cycle pulses when service complete)
            clear_up <= {N{1'b0}};
            clear_down <= {N{1'b0}};
            clear_floor <= {N{1'b0}};

            // compute UR/DR/CR per floor index
            // convert cur_floor to int index
            integer f_int;
            f_int = cur_floor;

            // determine candidate CS (CurrentState)
            reg UR_w, DR_w;
            UR_w = ur(f_int);
            DR_w = dr(f_int);

            reg [1:0] CS;
            // CurrentState rule from paper:
            // up if UR AND (last != down OR not DR)
            // down if (not UR and f>0) OR (DR and last=down)
            if (UR_w && (last_state != 2'b10 || !DR_w)) CS = 2'b01; // up
            else if ((!UR_w && f_int > 0) || (DR_w && last_state == 2'b10)) CS = 2'b10; // down
            else CS = 2'b00; // idle

            // CurrentRequest at this floor:
            reg CR_here;//Is there a request at this floor that matches our current direction?
            CR_here = cr(f_int, CS);

            // output CC
            if (CR_here) command <= 2'b11; // serve
            else command <= CS;

            // update last_state (latched)
            last_state <= CS;

            // when a serve completes (served_pulse), clear appropriate buttons at cur_floor
            if (served_pulse) begin
                // Clear f_button always
                clear_floor[f_int] <= 1'b1;
                // Clear up or down depending on direction when served (paper: ClearBoard resets external button with same dir)
                if (CS == 2'b10) begin // down
                    clear_down[f_int] <= 1'b1;
                end else begin // up or idle treat as up direction for clearing external up
                    clear_up[f_int] <= 1'b1;
                end
            end
        end
    end
endmodule
