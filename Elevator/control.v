// elevator_top.v
// Top-level wiring: flipflop boards for 3 button types, control and body.
`timescale 1ns/1ps
module elevator_top #(
    parameter N_FLOORS = 4,
    parameter F_BITS = $clog2(N_FLOORS)
)(
    input  wire clk,
    input  wire rst_n,
    // external push buttons (single-cycle pulses)
    input  wire [N_FLOORS-1:0] ext_up,    // outside up requests
    input  wire [N_FLOORS-1:0] ext_down,  // outside down requests
    input  wire [N_FLOORS-1:0] ext_floor, // inside elevator floor buttons
    output wire [F_BITS-1:0] cur_floor,
    output wire [1:0] cur_cmd,
    output wire doors_open,
    // expose latched request bits for debug/LED
    output wire [N_FLOORS-1:0] u_buttons,
    output wire [N_FLOORS-1:0] d_buttons,
    output wire [N_FLOORS-1:0] f_buttons
);
    // flipflop boards
    wire [N_FLOORS-1:0] clear_up, clear_down, clear_floor;
    wire served_pulse;

    flipflop_board #(.N(N_FLOORS)) ff_up (
        .clk(clk), .rst_n(rst_n),
        .set_pulse(ext_up),
        .reset_pulse(clear_up),
        .state_out(u_buttons)
    );

    flipflop_board #(.N(N_FLOORS)) ff_down (
        .clk(clk), .rst_n(rst_n),
        .set_pulse(ext_down),
        .reset_pulse(clear_down),
        .state_out(d_buttons)
    );

    flipflop_board #(.N(N_FLOORS)) ff_floor (
        .clk(clk), .rst_n(rst_n),
        .set_pulse(ext_floor),
        .reset_pulse(clear_floor),
        .state_out(f_buttons)
    );

    control #(.N(N_FLOORS), .F_BITS(F_BITS)) ctrl (
        .clk(clk), .rst_n(rst_n),
        .cur_floor(cur_floor),
        .u_buttons(u_buttons),
        .d_buttons(d_buttons),
        .f_buttons(f_buttons),
        .served_pulse(served_pulse),
        .command(cur_cmd),
        .clear_up(clear_up),
        .clear_down(clear_down),
        .clear_floor(clear_floor)
    );

    elevator_body #(.N_FLOORS(N_FLOORS)) body (
        .clk(clk), .rst_n(rst_n),
        .command(cur_cmd),
        .init_floor({F_BITS{1'b0}}),
        .cur_floor(cur_floor),
        .doors_open(doors_open),
        .served_pulse(served_pulse)
    );
endmodule
