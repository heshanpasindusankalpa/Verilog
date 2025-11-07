# Verilog
Design a simple FSM-based memory module in Verilog.

You are required to design a small 16×8 memory system controlled by a finite state machine (FSM).
The memory should perform read and write operations based on control signals.

The memory has 16 locations, each 8 bits wide.

It supports two main operations:

Write: Store the value din at address addr when write = 1.

Read: Output the value stored at address addr when read = 1.

The FSM must manage the memory operation using the following states:

IDLE: Waiting for a read or write request.

WRITE: Writing data into memory.

READ: Reading data from memory.

DONE: Indicate that the operation is complete.

The module should assert ready = 1 when the operation finishes.

A synchronous (clocked) design must be used with a positive-edge-triggered clock and active-high reset.

VPL
Academi
The Department of Electrical and Information Engineering offers BScEng (Hons) degree, specializing in Electrical and Information Engineering from the commencement of the faculty in the year 2000. The degree program received the IESL Recognition status from its inception and has been fully accredited since 2010 by IESL, a signatory to the Washington Accord.

Contact Us
Faculty of Engineering,Hapugala,Galle,Sri Lanka.

 Phone : +(94)0 91 2245765/6

 Email : webmaster@eng.ruh.ac.lk
