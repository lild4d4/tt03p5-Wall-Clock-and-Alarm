`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.09.2022 20:01:45
// Design Name: 
// Module Name: Actividad2_timed_FSM_v2
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Actividad2_timed_FSM_v2(
    input clk, reset, boton,
    output reg [6:0] segments,
    output reg [7:0] anodes
    );
    
    reg Nreset;
    assign Nreset = ~reset;
    
    reg [31:0] to_display;
    reg boton_pressed_status, boton_pressed_pulse, boton_released_pulse;
    
    // debouncer
    PB_Debouncer_FSM #(1000000) debouncer(clk, Nreset, boton, boton_pressed_status, boton_pressed_pulse, boton_released_pulse);
    // maquina de estados
    timed_FSM timedFSM(clk, Nreset, boton_pressed_status, to_display);
    //seven segments decoder
    reg clk_display;
    
    clock_divider #(49999) clkdiv(clk, Nreset, clk_display);
    NumToSeven numseven(to_display, clk_display, Nreset, segments, anodes);
    
endmodule
