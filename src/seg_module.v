`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.09.2022 16:55:01
// Design Name: 
// Module Name: seg_module
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


module seg_module(
    input clk, reset, up_seg, down_seg,
    input [31:0] miliseg,
    output reg [31:0] seg
    );
    
    reg [2:0] state, nx_state;
    reg go;
    
    localparam IDLE = 0;
    localparam SUM = 1;
    
    always @(*) begin
        nx_state = state;
        go = 0;
        case(state)
            IDLE: begin
                if(miliseg==1000) nx_state = SUM;
            end
            SUM: begin
                go = 1;
                nx_state = IDLE;
            end
        endcase
    end
    
    always @(posedge clk) begin
        if(reset) 
            state <= IDLE;
        else 
            state <= nx_state;
    end
    
    // Contador
    always @(posedge clk) begin
        if(reset) seg <= 0;
        else if(seg==60) seg <= 0;
        else if(go || up_seg) seg <= seg + 1;
        else if(down_seg) seg <= seg - 1;
    end
    
endmodule
