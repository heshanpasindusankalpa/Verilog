// tb_elevator.v
`timescale 1ns/1ps
module tb_elevator;
    parameter N = 4;
    parameter F_BITS = $clog2(N);

    reg clk;
    reg rst_n;
    reg [N-1:0] ext_up;
    reg [N-1:0] ext_down;
    reg [N-1:0] ext_floor;

    wire [F_BITS-1:0] cur_floor;
    wire [1:0] cur_cmd;
    wire doors_open;
    wire [N-1:0] u_buttons, d_buttons, f_buttons;

    elevator_top #(.N_FLOORS(N)) DUT (
        .clk(clk), .rst_n(rst_n),
        .ext_up(ext_up),
        .ext_down(ext_down),
        .ext_floor(ext_floor),
        .cur_floor(cur_floor),
        .cur_cmd(cur_cmd),
        .doors_open(doors_open),
        .u_buttons(u_buttons),
        .d_buttons(d_buttons),
        .f_buttons(f_buttons)
    );

    // clock
    initial clk = 0;
    always #5 clk = ~clk; // 10ns period

    // helper to pulse an external button
    task pulse(input integer idx, input reg [N-1:0] which);
        begin
            which = {N{1'b0}};
            which[idx] = 1'b1;
            @(posedge clk);
            which = {N{1'b0}};
        end
    endtask

    // but tasks cannot write to top-level regs by reference easily; just manually drive
    initial begin
        rst_n = 0;
        ext_up = 0;
        ext_down = 0;
        ext_floor = 0;
        #20;
        rst_n = 1;
        #20;

        $display("Time\tFloor\tCmd\tDoors\tuButtons\tdButtons\tfButtons");

        // At t=40ns press outside call up at floor 0
        @(posedge clk);
        ext_up = 4'b0001;
        @(posedge clk);
        ext_up = 4'b0000;

        // after some time press inside floor button to go to 3
        #600; // allow elevator to service or move
        @(posedge clk);
        ext_floor = 4'b1000; // request floor 3 (index 3)
        @(posedge clk);
        ext_floor = 4'b0000;

        // Another call down at top floor later
        #800;
        @(posedge clk);
        ext_down = 4'b1000; // top floor down
        @(posedge clk);
        ext_down = 4'b0000;

        // simulate long enough
        #5000;
        $finish;
    end

    // monitor
    always @(posedge clk) begin
        $display("%0t\t%0d\t%b\t%b\t%b\t%b\t%b",
            $time, cur_floor, cur_cmd, doors_open,
            u_buttons, d_buttons, f_buttons);
    end

endmodule
