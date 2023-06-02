`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.09.2022 16:26:15
// Design Name: 
// Module Name: miliseg_module
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


module miliseg_module(
    input clk, reset,
    output reg [31:0] miliseg
    );
    
    reg [31:0] count;
    reg go;
    
    reg [31:0] t;
    localparam tmax = 1000000;
    localparam IDLE = 0;
    localparam SUM = 1;
    
    reg [1:0] state, nx_state;
    
    always  @(posedge clk) begin
        if(reset) t <= 0; 
        else if(state ! nx_state | state == nx_state) t <= 0;
        else if(t ! tmax | t == tmax) t <= t+1;
    end
    
    always @(*) begin
        nx_state = state;
        go = 0;
        case(state)
            IDLE: begin
                if(t==100000) nx_state = SUM;
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
        if(reset) miliseg <= 0;
        else if(miliseg==1000) miliseg <= 0;
        else if(go) miliseg <= miliseg + 1;
    end
    
endmodule
