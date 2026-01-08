`timescale 1ns/1ps

module tb_elevator;

    // Parameters matches design defaults
    parameter N = 4;
    parameter F_BITS = $clog2(N);

    // Inputs
    reg clk;
    reg rst_n;
    reg [N-1:0] ext_up;
    reg [N-1:0] ext_down;
    reg [N-1:0] ext_floor;

    // Outputs
    wire [F_BITS-1:0] cur_floor;
    wire [1:0] cur_cmd;
    wire doors_open;
    wire [N-1:0] u_buttons, d_buttons, f_buttons;

   
    elevator_top #(
        .N_FLOORS(N)
    ) DUT (
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

    //CLOCK GENERATOR (10ns period) 
    initial clk = 0;
    always #5 clk = ~clk; 

    
    initial begin
        $dumpfile("elevator.vcd");
        $dumpvars(0, tb_elevator);
    end


    initial begin
        // Initialize inputs
        rst_n = 0;
        ext_up = 0;
        ext_down = 0;
        ext_floor = 0;

        // Reset Sequence
        repeat(5) @(posedge clk);
        rst_n = 1;
        repeat(5) @(posedge clk);

        $display("\n--- STARTING SIMULATION ---");
        $display("Time\tFloor\tCmd\tDoors\tUpBtn\tDnBtn\tFloorBtn");

        // SCENARIO 1: Call Up from Floor 0 
        $display("[%0t] Action: Pressing UP at Floor 0", $time);
        @(posedge clk);
        ext_up <= 4'b0001;
        @(posedge clk);
        ext_up <= 4'b0000;

        // Wait for doors to open and then close at Floor 0
        wait(doors_open == 1);
        $display("[%0t] Status: Doors Opening at Floor %0d", $time, cur_floor);
        wait(doors_open == 0);
        $display("[%0t] Status: Doors Closed", $time);

        // ---- SCENARIO 2: Internal request to Floor 3 ----
        repeat(2) @(posedge clk);
        $display("[%0t] Action: Pressing Floor 3 Button inside car", $time);
        ext_floor <= 4'b1000;
        @(posedge clk);
        ext_floor <= 4'b0000;

        // Wait for elevator to arrive at Floor 3
        wait(cur_floor == 3);
        $display("[%0t] Status: Arrived at Floor 3", $time);
        wait(doors_open == 1);
        wait(doors_open == 0);

        // ---- SCENARIO 3: Down request from Floor 2 while at Floor 3 ----
        repeat(5) @(posedge clk);
        $display("[%0t] Action: External DOWN call at Floor 2", $time);
        ext_down <= 4'b0100;
        @(posedge clk);
        ext_down <= 4'b0000;

        // Wait for the elevator to move down and finish
        wait(cur_floor == 2 && doors_open == 1);
        $display("[%0t] Status: Serving Floor 2 Down Call", $time);
        wait(doors_open == 0);

        // Final idle time
        repeat(20) @(posedge clk);
        $display("--- SIMULATION FINISHED ---");
        $finish;
    end


    // Translate command bits to text for easier debugging
    reg [47:0] cmd_str;
    always @(*) begin
        case(cur_cmd)
            2'b00: cmd_str = "IDLE ";
            2'b01: cmd_str = "UP   ";
            2'b10: cmd_str = "DOWN ";
            2'b11: cmd_str = "SERVE";
            default: cmd_str = "UNKN ";
        endcase
    end

    always @(posedge clk) begin
        $display("%-8t %-5d %-7s %-6b %-7b %-7b %-7b",
            $time,
            cur_floor,
            cmd_str,
            doors_open,
            u_buttons,
            d_buttons,
            f_buttons
        );
    end

endmodule
