`timescale 1ns / 1ps
module clkd16#(
parameter N = 8,
    WIDTH = 2
)(

    input clk,
    input rst,
    output reg clk_out
    );

reg [WIDTH:0]counter;
always @(posedge clk or posedge rst) begin
    if (rst) begin
        // reset
        counter <= 0;
    end
    else begin
        counter <= counter + 1;
    end
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        // reset
        clk_out <= 0;
    end
    else if (counter == N-1) begin
        clk_out <= !clk_out;
    end
end

endmodule
