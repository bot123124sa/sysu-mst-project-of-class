`timescale 1ns / 1ps
module decoder(
    input clock,
    input reset,
    input [15: 0] y,
    output reg [6: 0] select_segment,
    output reg [3: 0] select_bit
    );

    wire [1: 0] s;
    reg [3: 0] digit;
    reg [20: 0] clkdiv;

    assign s = clkdiv[20: 19];

    
    always @(posedge clock)
        case(s)
            0: digit = y[3: 0];
            1: digit = y[7: 4];
            2: digit = y[11: 8];
            3: digit = y[15: 12];
            default: digit = y[3: 0];
        endcase

    always @(posedge clock) begin
        case(digit)  // 十六进制数
            0: select_segment = 7'b1111_110;  // 1
            1: select_segment = 7'b0110_000;  // 1
            2: select_segment = 7'b1101_101;  // 2
            3: select_segment = 7'b1111_001;  // 3
            4: select_segment = 7'b0110_011;  // 4
            5: select_segment = 7'b1011_011;  // 5
            6: select_segment = 7'b1011_111;  // 6
            7: select_segment = 7'b1110_000;  // 7
            8: select_segment = 7'b1111_111;  // 8
            9: select_segment = 7'b1111_011;  // 9
            10: select_segment = 7'b1110_111;  // A
            11: select_segment = 7'b0011_111;  // b
            12: select_segment = 7'b0001_101;  // c
            13: select_segment = 7'b0111_101;  // d
            14: select_segment = 7'b1001_111;  // E
            15: select_segment = 7'b1000_111;  // F
            default: select_segment = 7'b1111_110;
        endcase
    end

    always @(posedge clock) begin
        select_bit = 4'b0000;
        select_bit[s] = 1'b1;
    end

    always @(posedge clock or posedge reset) begin
        if (reset) begin
            clkdiv <= 0;
        end

        else begin
            clkdiv <= clkdiv + 1;
        end
    end

endmodule
