// elevator_body.v
// Models elevator motion and door serving (behavioral).
// command: 00 idle, 01 up, 10 down, 11 serve
`timescale 1ns/1ps
module elevator_body #(
    parameter N_FLOORS = 4,
    parameter FLOOR_BITS = $clog2(N_FLOORS),
    parameter MOVE_CYCLES = 50,  // cycles to move one floor
    parameter DOOR_CYCLES = 40   // cycles to serve (door open) at a floor
)(
    input  wire clk,
    input  wire rst_n,
    input  wire [1:0] command,
    input  wire [FLOOR_BITS-1:0] init_floor,
    output reg  [FLOOR_BITS-1:0] cur_floor,
    output reg  doors_open,
    output reg  served_pulse  // high for one cycle when a serve completes at a floor
);
    // internal
    reg [31:0] move_cnt;
    reg [31:0] door_cnt;
    reg moving; // 1 when moving between floors
    reg [1:0] last_cmd;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cur_floor <= init_floor;
            move_cnt <= 0;
            door_cnt <= 0;
            doors_open <= 0;
            moving <= 0;
            served_pulse <= 0;
            last_cmd <= 2'b00;
        end else begin
            served_pulse <= 0; // default
            case (command)
                2'b01: begin // UP
                    doors_open <= 0;
                    if (!moving) begin
                        moving <= 1;
                        move_cnt <= 1;
                        last_cmd <= 2'b01;
                    end else begin
                        if (move_cnt < MOVE_CYCLES) move_cnt <= move_cnt + 1;
                        else begin
                            // reach next floor
                            if (cur_floor < N_FLOORS-1) cur_floor <= cur_floor + 1;
                            moving <= 0;
                            move_cnt <= 0;
                        end
                    end
                end
                2'b10: begin // DOWN
                    doors_open <= 0;
                    if (!moving) begin
                        moving <= 1;
                        move_cnt <= 1;
                        last_cmd <= 2'b10;
                    end else begin
                        if (move_cnt < MOVE_CYCLES) move_cnt <= move_cnt + 1;
                        else begin
                            if (cur_floor > 0) cur_floor <= cur_floor - 1;
                            moving <= 0;
                            move_cnt <= 0;
                        end
                    end
                end
                2'b11: begin // SERVE
                    // start door timer if not already
                    if (!doors_open) begin
                        doors_open <= 1;
                        door_cnt <= 1;
                    end else begin
                        if (door_cnt < DOOR_CYCLES) door_cnt <= door_cnt + 1;
                        else begin
                            doors_open <= 0;
                            door_cnt <= 0;
                            served_pulse <= 1; // indicate serving finished (one-cycle)
                        end
                    end
                    moving <= 0;
                    move_cnt <= 0;
                    last_cmd <= 2'b11;
                end
                default: begin // IDLE
                    moving <= 0;
                    move_cnt <= 0;
                    door_cnt <= doors_open ? (door_cnt + 1) : 0;
                    if (doors_open && door_cnt != 0 && door_cnt >= DOOR_CYCLES) begin
                        doors_open <= 0;
                        served_pulse <= 1;
                        door_cnt <= 0;
                    end
                    last_cmd <= 2'b00;
                end
            endcase
        end
    end
endmodule
