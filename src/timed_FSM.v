`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.09.2022 11:20:20
// Design Name: 
// Module Name: timed_FSM
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


module timed_FSM(
    input clk, reset, up, down, center,
    output reg up_seg, up_min, up_hour, down_seg, down_min, down_hour
    );
    
    reg [2:0] count;
    
    // timed control strategy #1 (generic)
    localparam tmax = 100000001;
    localparam IDLE = 0;
    localparam SUM = 1;
    localparam KEEP_SUM = 2;
    localparam FAST_SUM = 3;
    localparam RESET = 4;
    localparam SUB = 5;
    localparam KEEP_SUB = 6;
    localparam FAST_SUB = 7;
    localparam RESET_SUB = 8;
    
    reg [31:0] t;
    
    reg [3:0] state, nx_state;
    
    always @(posedge clk) begin
        if(reset) t <= 0; 
        else if(state != nx_state) t <= 0;
        else if(t != tmax) t <= t+1;
    end
    
    // Maquina de estados
    always @(*) begin
        nx_state = state;
        up_seg = 0;
        down_seg = 0;
        up_min = 0;
        down_min = 0;
        up_hour = 0;
        down_hour = 0;
        case(state)
            IDLE: begin
                if(up) nx_state = SUM;
                else if(down) nx_state = SUB;
            end
            SUM: begin
                case(count)
                    1: up_seg = 1;
                    2: up_min = 1;
                    3: up_hour = 1;
                    default: begin
                        up_seg = 0;
                        down_seg = 0;
                        up_min = 0;
                        down_min = 0;
                        up_hour = 0;
                        down_hour = 0;
                    end
                endcase
                nx_state = KEEP_SUM;
            end
            SUB: begin
                case(count)
                    1: down_seg = 1;
                    2: down_min = 1;
                    3: down_hour = 1;
                    default: begin
                        up_seg = 0;
                        down_seg = 0;
                        up_min = 0;
                        down_min = 0;
                        up_hour = 0;
                        down_hour = 0;
                    end
                endcase
                nx_state = KEEP_SUB;
            end
            KEEP_SUM: begin
                up_seg = 0;
                if(!up) nx_state = IDLE;
                else if(t==100000000) begin
                    nx_state = FAST_SUM;
                end
            end
            KEEP_SUB: begin
                down_seg = 0;
                if(!down) nx_state = IDLE;
                else if(t==100000000) begin
                    nx_state = FAST_SUB;
                end
            end
            FAST_SUM: begin
                if(!up) nx_state = IDLE;
                else if(t==10000000) begin
                    case(count)
                        1: up_seg = 1;
                        2: up_min = 1;
                        3: up_hour = 1;
                    default: begin
                        up_seg = 0;
                        down_seg = 0;
                        up_min = 0;
                        down_min = 0;
                        up_hour = 0;
                        down_hour = 0;
                    end
                endcase
                    nx_state = RESET;
                end
            end
            FAST_SUB: begin
                if(!down) nx_state = IDLE;
                else if(t==10000000) begin
                    case(count)
                        1: down_seg = 1;
                        2: down_min = 1;
                        3: down_hour = 1;
                        default: begin
                        up_seg = 0;
                        down_seg = 0;
                        up_min = 0;
                        down_min = 0;
                        up_hour = 0;
                        down_hour = 0;
                    end
                    endcase
                    nx_state = RESET;
                end
            end
            RESET: begin
                nx_state = FAST_SUM;
            end
            RESET_SUB: begin
                nx_state = FAST_SUB;
            end
        endcase
    end
    
    always @(posedge clk) begin
        if(reset) 
            state <= IDLE;
        else 
            state <= nx_state;
    end
    
    always @(posedge clk) begin
        if(reset) count <= 0;
        else if(center) count <= count + 1;
        else if(count==4) count <= 0;
    end
    
endmodule
