`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.09.2022 16:49:17
// Design Name: 
// Module Name: Reloj_top
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


module tt_um_Reloj_top(
    input wire [7:0] ui_in,
    input wire [7:0] uio_in,
    output wire [7:0] uo_out,
    output wire [7:0] uio_out,
    output wire [7:0] uio_oe,
    input wire ena, clk, rst_n
    );
    
    //configuracion antes d3 tt3.5
    //input clk, reset, up, down, center,
    //output reg [6:0] segments,
    //output reg [7:0] anodes
	
    wire up 		= ui_in[0];
    wire down		= ui_in[1];
    wire center		= ui_in[2];
    reg [6:0] segments;
    reg [7:0] anodes;
    assign uio_out 			= {1'b1, segments};
    assign uo_out 			= anodes; 
    assign uio_oe = 8'b1111_1111;
    
    
    
    wire Nreset;
    assign Nreset = ~rst_n;
    
    reg [31:0] miliseg;
    reg [31:0] seg, min, hour;
    reg [31:0] hora_out;
    reg [31:0] to_display;
    reg clk_div;
    
    reg up_seg, up_min, up_hour, down_seg, down_min, down_hour;
    
    reg up_pressed_status, up_pressed_pulse, up_released_pulse;
    PB_Debouncer_FSM #(1000000) debup(clk, Nreset, up, up_pressed_status, up_pressed_pulse, up_released_pulse);
    
    reg down_pressed_status, down_pressed_pulse, down_released_pulse;
    PB_Debouncer_FSM #(1000000) debdown(clk, Nreset, down, down_pressed_status, down_pressed_pulse, down_released_pulse);
    
    reg center_pressed_status, center_pressed_pulse, center_released_pulse;
    PB_Debouncer_FSM #(1000000) debcenter(clk, Nreset, center, center_pressed_status, center_pressed_pulse, center_released_pulse);
    
    timed_FSM timedfsm(clk, Nreset, up_pressed_status, down_pressed_status, center_pressed_pulse, up_seg, up_min, up_hour, down_seg, down_min, down_hour);
    
    miliseg_module milimod(clk, Nreset,miliseg);
    seg_module segmod(clk, Nreset, up_seg, down_seg, miliseg, seg);
    minmod minites(clk, Nreset, up_min, down_min, seg, min);
    hour_module hourmod(clk, Nreset, up_hour, down_hour, min, hour);
    
    //assign hora_out[7:0] = seg;
    //assign hora_out [15:8] = min;
    
    always @(*) begin
        hora_out = seg + min + hour;
    end
    
    reg clk_display;
    clock_divider #(49999) clkdiv(clk, Nreset, clk_display);
    
    reg idle;
    
    unsigned_to_bcd doubledabble(clk, 1, hora_out, idle, to_display);
    NumToSeven to7seg(to_display, clk_display, Nreset, segments, anodes);
    
endmodule
