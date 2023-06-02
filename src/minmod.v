`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.09.2022 15:31:57
// Design Name: 
// Module Name: minmod
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


module minmod(
    input clk, reset, up_min, down_min,
    input [31:0] seg,
    output reg [31:0] min
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
                if(seg==60) nx_state = SUM;
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
        if(reset) min <= 0;
        else if(min==6000) min <= 0;
        else if(go || up_min) min <= min + 100;
        else if(down_min) min <= min - 100;
    end
    
endmodule
