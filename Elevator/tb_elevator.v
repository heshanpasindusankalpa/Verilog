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

    // ================= DUT =================
    elevator_top #(.N_FLOORS(N)) DUT (
        .clk(clk),
        .rst_n(rst_n),
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

    // ================= CLOCK =================
    initial clk = 0;
    always #50 clk = ~clk;   // 10ns clock period

    // ================= WAVEFORM DUMP =================
    initial begin
        $dumpfile("elevator.vcd");   // waveform file
        $dumpvars(0, tb_elevator);   // dump everything
    end

    // ================= STIMULUS =================
    initial begin
        rst_n = 0;
        ext_up = 0;
        ext_down = 0;
        ext_floor = 0;

        #20;
        rst_n = 1;

        $display("Time\tFloor\tCmd\tDoors\tUpBtn\tDnBtn\tFloorBtn");

        // ---- Outside UP call at floor 0 ----
        @(posedge clk);
        ext_up = 4'b0001;
        @(posedge clk);
        ext_up = 4'b0000;

        // ---- Inside request to go to floor 3 ----
        #600;
        @(posedge clk);
        ext_floor = 4'b1000;
        @(posedge clk);
        ext_floor = 4'b0000;

        // ---- Down request from top floor ----
        #800;
        @(posedge clk);
        ext_down = 4'b1000;
        @(posedge clk);
        ext_down = 4'b0000;

        #800;
        $finish;
    end

    // ================= MONITOR =================
    always @(posedge clk) begin
        $display("%-8t %-5d %-7b %-6b %-7b %-7b %-7b",
            $time,
            cur_floor,
            cur_cmd,
            doors_open,
            u_buttons,
            d_buttons,
            f_buttons
        );
    end

endmodule
