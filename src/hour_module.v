`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.09.2022 17:41:15
// Design Name: 
// Module Name: hour_module
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


module hour_module(
    input clk, reset, up_hour, down_hour,
    input [31:0] min,
    output reg [31:0] hour
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
                if(min==6000) nx_state = SUM;
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
        if(reset) hour <= 0;
        else if(hour==240000) hour <= 0;
        else if(go || up_hour) hour <= hour + 10000;
        else if(down_hour) hour <= hour - 10000;
    end
endmodule
