`timescale 1ns / 1ps
`include "headfile.v"
module I_mem(
input wire [7:0] addr,
 input clk,
 output reg [15:0] douta
);

always @(posedge clk)
begin
    case(addr)
  0:douta={`ADDI,`gr7,4'd1,4'd0};              // gr7 <= 16'h0010 for store address
        1:douta={`LDIH,`gr1,4'b1011,4'b0110};        // test for LDIH  gr1<="16'hb600"
        2:douta={`STORE,`gr1,1'b0,`gr7,4'h0};        // store to mem10
        3:douta={`LOAD,`gr1,1'b0,`gr0,4'h0};         // gr1 <= fffd
        4:douta={`LOAD,`gr2,1'b0,`gr0,4'h1};         // gr2 <= 4
        5:douta={`ADDC,`gr3,1'b0,`gr1,1'b0,`gr2};    // gr3 <= fffd + 4 + cf(=0) = 1, cf<=1
        6:douta={`STORE,`gr3,1'b0,`gr7,4'h1};        // store to mem11
        7:douta={`ADDC,`gr3,1'b0,`gr0,1'b0,`gr2};    // gr3 <= 0 + 4 + cf(=1) = 5, cf<=0
        8:douta={`STORE,`gr3,1'b0,`gr7,4'h2};        // store to mem12
        9:douta={`LOAD,`gr1,1'b0,`gr0,4'h2};          // gr1 <= 5
        10:douta={`SUBC,`gr3,1'b0,`gr1,1'b0,`gr2};    // gr3 <= 5 - 4 + cf(=0) =1, cf<=0
        11:douta={`STORE,`gr3,1'b0,`gr7,4'h3};        // store to mem13
        12:douta={`SUB,`gr3,1'b0,`gr2,1'b0,`gr1};     // gr3 <= 4 - 5 = -1, cf<=1
        13:douta={`STORE,`gr3,1'b0,`gr7,4'h4};        // store to mem14
        14:douta={`SUBC,`gr3,1'b0,`gr2,1'b0,`gr1};    // gr3 <= 5 - 4 - cf(=1) =2, cf<=0
        15:douta={`STORE,`gr3,1'b0,`gr7,4'h5};        // store to mem15
        16:douta={`LOAD,`gr1,1'b0,`gr0,4'h3};         // gr1 <= c369
        17:douta={`LOAD,`gr2,1'b0,`gr0,4'h4};         // gr2 <= 69c3
        18:douta={`AND,`gr3,1'b0,`gr1,1'b0,`gr2};     // gr3 <= gr1 & gr2 = 4141
        19:douta={`STORE,`gr3,1'b0,`gr7,4'h6};        // store to mem16
        20:douta={`OR,`gr3,1'b0,`gr1,1'b0,`gr2};      // gr3 <= gr1 | gr2 = ebeb
        21:douta={`STORE,`gr3,1'b0,`gr7,4'h7};        // store to mem17
        22:douta={`XOR,`gr3,1'b0,`gr1,1'b0,`gr2};     // gr3 <= gr1 ^ gr2 = aaaa
        23:douta={`STORE,`gr3,1'b0,`gr7,4'h8};        // store to mem18
        24:douta={`SLL,`gr3,1'b0,`gr1,4'h0};          // gr3 <= gr1 < 0
        25:douta={`STORE,`gr3,1'b0,`gr7,4'h9};        // store to mem19
        26:douta={`SLL,`gr3,1'b0,`gr1,4'h1};          // gr3 <= gr1 < 1
        27:douta={`STORE,`gr3,1'b0,`gr7,4'ha};        // store to mem1a
        28:douta={`SLL,`gr3,1'b0,`gr1,4'h4};          // gr3 <= gr1 < 8
        29:douta={`STORE,`gr3,1'b0,`gr7,4'hb};        // store to mem1b
        30:douta={`SLL,`gr3,1'b0,`gr1,4'hf};          // gr3 <= gr1 < 15
        31:douta={`STORE,`gr3,1'b0,`gr7,4'hc};        // store to mem1c
        32:douta={`SRL,`gr3,1'b0,`gr1,4'h0};          // gr3 <= gr1 > 0
        33:douta={`STORE,`gr3,1'b0,`gr7,4'hd};        // store to mem1d
        34:douta={`SRL,`gr3,1'b0,`gr1,4'h1};          // gr3 <= gr1 > 1
        35:douta={`STORE,`gr3,1'b0,`gr7,4'he};        // store to mem1e
        36:douta={`SRL,`gr3,1'b0,`gr1,4'h8};          // gr3 <= gr1 > 8
        37:douta={`STORE,`gr3,1'b0,`gr7,4'hf};        // store to mem1f
        38:douta={`SRL,`gr3,1'b0,`gr1,4'hf};          // gr3 <= gr1 > 15
        39:douta={`ADDI,`gr7,4'd1,4'd0};              // gr7 <= 16'h20 for store address
        40:douta={`STORE,`gr3,1'b0,`gr7,4'h0};        // store to mem20
        41:douta={`SLA,`gr3,1'b0,`gr1,4'h0};          // gr3 <= gr1 < 0
        42:douta={`STORE,`gr3,1'b0,`gr7,4'h1};        // store to mem21
        43:douta={`SLA,`gr3,1'b0,`gr1,4'h1};          // gr3 <= gr1 < 1
        44:douta={`STORE,`gr3,1'b0,`gr7,4'h2};        // store to mem22
        45:douta={`SLA,`gr3,1'b0,`gr1,4'h8};          // gr3 <= gr1 < 8
        46:douta={`STORE,`gr3,1'b0,`gr7,4'h3};        // store to mem23
        47:douta={`SLA,`gr3,1'b0,`gr1,4'hf};          // gr3 <= gr1 < 15
        48:douta={`STORE,`gr3,1'b0,`gr7,4'h4};        // store to mem24
        49:douta={`SLA,`gr3,1'b0,`gr2,4'h0};          // gr3 <= gr1 < 0
        50:douta={`STORE,`gr3,1'b0,`gr7,4'h5};        // store to mem25
        51:douta={`SLA,`gr3,1'b0,`gr2,4'h1};          // gr3 <= gr1 < 1
        52:douta={`STORE,`gr3,1'b0,`gr7,4'h6};        // store to mem26
        53:douta={`SLA,`gr3,1'b0,`gr2,4'h8};          // gr3 <= gr1 < 8
        54:douta={`STORE,`gr3,1'b0,`gr7,4'h7};        // store to mem27
        55:douta={`SLA,`gr3,1'b0,`gr2,4'hf};          // gr3 <= gr1 < 15
        56:douta={`STORE,`gr3,1'b0,`gr7,4'h8};        // store to mem28
        57:douta={`SRA,`gr3,1'b0,`gr1,4'h0};          // gr3 <= gr1 > 0
        58:douta={`STORE,`gr3,1'b0,`gr7,4'h9};        // store to mem29
        59:douta={`SRA,`gr3,1'b0,`gr1,4'h1};          // gr3 <= gr1 > 1
        60:douta={`STORE,`gr3,1'b0,`gr7,4'ha};        // store to mem2a
        61:douta={`SRA,`gr3,1'b0,`gr1,4'h8};          // gr3 <= gr1 > 8
        62:douta={`STORE,`gr3,1'b0,`gr7,4'hb};        // store to mem2b
        63:douta={`SRA,`gr3,1'b0,`gr1,4'hf};          // gr3 <= gr1 > 15
        64:douta={`STORE,`gr3,1'b0,`gr7,4'hc};        // store to mem2c
        65:douta={`SRA,`gr3,1'b0,`gr2,4'h0};          // gr3 <= gr1 > 0
        66:douta={`STORE,`gr3,1'b0,`gr7,4'hd};        // store to mem2d
        67:douta={`SRA,`gr3,1'b0,`gr2,4'h1};          // gr3 <= gr1 > 1
        68:douta={`STORE,`gr3,1'b0,`gr7,4'he};        // store to mem2e
        69:douta={`SRA,`gr3,1'b0,`gr2,4'h8};          // gr3 <= gr1 > 8
        70:douta={`STORE,`gr3,1'b0,`gr7,4'hf};        // store to mem2f
        71:douta={`ADDI,`gr7,4'd1,4'd0};              // gr7 <= 16'h30 for store address
        72:douta={`SRA,`gr3,1'b0,`gr2,4'hf};          // gr3 <= gr1 > 15
        73:douta={`STORE,`gr3,1'b0,`gr7,4'h0};        // store to mem30
        74:douta={`LOAD,`gr1,1'b0,`gr0,4'h5};         // gr1 <= 41
        75:douta={`LOAD,`gr2,1'b0,`gr0,4'h6};         // gr2 <= ffff
        76:douta={`LOAD,`gr3,1'b0,`gr0,4'h7};         // gr3 <= 1
        77:douta={`JUMP, 3'd0,8'h4f};                 // jump to 4f
        78:douta={`STORE,`gr7,1'b0,`gr7,4'h1};        // store to mem31
        79:douta={`JMPR, `gr1,8'h10};                 // jump to 41+10 = 51
        80:douta={`STORE,`gr7,1'b0,`gr7,4'h2};        // store to mem32
        81:douta={`ADD, `gr4,1'b0,`gr2,1'b0,`gr3};    // gr4<= ffff + 1,cf<=1
        82:douta={`BNC,`gr1,8'h28};                   // if(cf==0) jump to 69
        83:douta={`BC,`gr1,8'h14};                    // if(cf==1) jump to 55
        84:douta={`STORE,`gr7,1'b0,`gr7,4'h3};        // store to mem33
        85:douta={`ADD, `gr4,1'b0,`gr3,1'b0,`gr3};    // gr4<= 1 + 1 , cf<=0
        86:douta={`BC,`gr1,8'h28};                    // if(cf==1) jump to 69
        87:douta={`BNC,`gr1,8'h18};                   // if(cf==0) jump to 59
        88:douta={`STORE,`gr7,1'b0,`gr7,4'h4};        // store to mem34
        89:douta={`CMP, 3'd0,1'b0,`gr3,1'b0,`gr3};    // 1-1=0 , zf<=1,nf<=0
        90:douta={`BNZ,`gr1,8'h28};                   // if(zf==0) jump to 69
        91:douta={`BZ,`gr1,8'h1c};                    // if(zf==1) jump to 5d
        92:douta={`STORE,`gr7,1'b0,`gr7,4'h5};        // store to mem35
        93:douta={`CMP, 3'd0,1'b0,`gr4,1'b0,`gr3};    // 2-1=1 , zf<=0,nf<=0
        94:douta={`BZ,`gr1,8'h28};                    // if(zf==1) jump to 69
        95:douta={`BNZ,`gr1,8'h20};                   // if(zf==0) jump to 61
        96:douta={`STORE,`gr7,1'b0,`gr7,4'h6};        // store to mem36
        97:douta={`CMP, 3'd0,1'b0,`gr3,1'b0,`gr4};    // 1-2=-1, nf<=1,zf<=0
        98:douta={`BNN,`gr1,8'h28};                   // if(nf==0) jump to 69
        99:douta={`BN,`gr1,8'h24};                    // if(nf==1) jump to 65
        100:douta={`STORE,`gr7,1'b0,`gr7,4'h7};       // store to mem37
        101:douta={`CMP, 3'd0,1'b0,`gr4,1'b0,`gr3};   // 2-1=1, nf<=0,zf<=0
        102:douta={`BN,`gr1,8'h28};                   // if(nf==1) jump to 69
        103:douta={`BNN,`gr1,8'h27};                  // if(nf==0) jump to 68
        104:douta={`STORE,`gr7,1'b0,`gr7,4'h8};       // store to mem38
        105:douta={`HALT, 11'd0};                     // STOP
    endcase
    end



//------------------------------------??????â‚?ï¿?(?????????â‚??lways??????????ï¿????mem????????â‚????â‚????ï¿??---------------------------------------//
    //init test 
       /*
        0:douta={`ADDI,`gr7,4'd1,4'd0};              // gr7 <= 16'h0010 for store address
        1:douta={`LDIH,`gr1,4'b1011,4'b0110};        // test for LDIH  gr1<="16'hb600"
        2:douta={`STORE,`gr1,1'b0,`gr7,4'h0};        // store to mem10
        3:douta={`LOAD,`gr1,1'b0,`gr0,4'h0};         // gr1 <= fffd
        4:douta={`LOAD,`gr2,1'b0,`gr0,4'h1};         // gr2 <= 4
        5:douta={`ADDC,`gr3,1'b0,`gr1,1'b0,`gr2};    // gr3 <= fffd + 4 + cf(=0) = 1, cf<=1
        6:douta={`STORE,`gr3,1'b0,`gr7,4'h1};        // store to mem11
        7:douta={`ADDC,`gr3,1'b0,`gr0,1'b0,`gr2};    // gr3 <= 0 + 4 + cf(=1) = 5, cf<=0
        8:douta={`STORE,`gr3,1'b0,`gr7,4'h2};        // store to mem12
        9:douta={`LOAD,`gr1,1'b0,`gr0,4'h2};          // gr1 <= 5
        10:douta={`SUBC,`gr3,1'b0,`gr1,1'b0,`gr2};    // gr3 <= 5 - 4 + cf(=0) =1, cf<=0
        11:douta={`STORE,`gr3,1'b0,`gr7,4'h3};        // store to mem13
        12:douta={`SUB,`gr3,1'b0,`gr2,1'b0,`gr1};     // gr3 <= 4 - 5 = -1, cf<=1
        13:douta={`STORE,`gr3,1'b0,`gr7,4'h4};        // store to mem14
        14:douta={`SUBC,`gr3,1'b0,`gr2,1'b0,`gr1};    // gr3 <= 5 - 4 - cf(=1) =2, cf<=0
        15:douta={`STORE,`gr3,1'b0,`gr7,4'h5};        // store to mem15
        16:douta={`LOAD,`gr1,1'b0,`gr0,4'h3};         // gr1 <= c369
        17:douta={`LOAD,`gr2,1'b0,`gr0,4'h4};         // gr2 <= 69c3
        18:douta={`AND,`gr3,1'b0,`gr1,1'b0,`gr2};     // gr3 <= gr1 & gr2 = 4141
        19:douta={`STORE,`gr3,1'b0,`gr7,4'h6};        // store to mem16
        20:douta={`OR,`gr3,1'b0,`gr1,1'b0,`gr2};      // gr3 <= gr1 | gr2 = ebeb
        21:douta={`STORE,`gr3,1'b0,`gr7,4'h7};        // store to mem17
        22:douta={`XOR,`gr3,1'b0,`gr1,1'b0,`gr2};     // gr3 <= gr1 ^ gr2 = aaaa
        23:douta={`STORE,`gr3,1'b0,`gr7,4'h8};        // store to mem18
        24:douta={`SLL,`gr3,1'b0,`gr1,4'h0};          // gr3 <= gr1 < 0
        25:douta={`STORE,`gr3,1'b0,`gr7,4'h9};        // store to mem19
        26:douta={`SLL,`gr3,1'b0,`gr1,4'h1};          // gr3 <= gr1 < 1
        27:douta={`STORE,`gr3,1'b0,`gr7,4'ha};        // store to mem1a
        28:douta={`SLL,`gr3,1'b0,`gr1,4'h4};          // gr3 <= gr1 < 8
        29:douta={`STORE,`gr3,1'b0,`gr7,4'hb};        // store to mem1b
        30:douta={`SLL,`gr3,1'b0,`gr1,4'hf};          // gr3 <= gr1 < 15
        31:douta={`STORE,`gr3,1'b0,`gr7,4'hc};        // store to mem1c
        32:douta={`SRL,`gr3,1'b0,`gr1,4'h0};          // gr3 <= gr1 > 0
        33:douta={`STORE,`gr3,1'b0,`gr7,4'hd};        // store to mem1d
        34:douta={`SRL,`gr3,1'b0,`gr1,4'h1};          // gr3 <= gr1 > 1
        35:douta={`STORE,`gr3,1'b0,`gr7,4'he};        // store to mem1e
        36:douta={`SRL,`gr3,1'b0,`gr1,4'h8};          // gr3 <= gr1 > 8
        37:douta={`STORE,`gr3,1'b0,`gr7,4'hf};        // store to mem1f
        38:douta={`SRL,`gr3,1'b0,`gr1,4'hf};          // gr3 <= gr1 > 15
        39:douta={`ADDI,`gr7,4'd1,4'd0};              // gr7 <= 16'h20 for store address
        40:douta={`STORE,`gr3,1'b0,`gr7,4'h0};        // store to mem20
        41:douta={`SLA,`gr3,1'b0,`gr1,4'h0};          // gr3 <= gr1 < 0
        42:douta={`STORE,`gr3,1'b0,`gr7,4'h1};        // store to mem21
        43:douta={`SLA,`gr3,1'b0,`gr1,4'h1};          // gr3 <= gr1 < 1
        44:douta={`STORE,`gr3,1'b0,`gr7,4'h2};        // store to mem22
        45:douta={`SLA,`gr3,1'b0,`gr1,4'h8};          // gr3 <= gr1 < 8
        46:douta={`STORE,`gr3,1'b0,`gr7,4'h3};        // store to mem23
        47:douta={`SLA,`gr3,1'b0,`gr1,4'hf};          // gr3 <= gr1 < 15
        48:douta={`STORE,`gr3,1'b0,`gr7,4'h4};        // store to mem24
        49:douta={`SLA,`gr3,1'b0,`gr2,4'h0};          // gr3 <= gr1 < 0
        50:douta={`STORE,`gr3,1'b0,`gr7,4'h5};        // store to mem25
        51:douta={`SLA,`gr3,1'b0,`gr2,4'h1};          // gr3 <= gr1 < 1
        52:douta={`STORE,`gr3,1'b0,`gr7,4'h6};        // store to mem26
        53:douta={`SLA,`gr3,1'b0,`gr2,4'h8};          // gr3 <= gr1 < 8
        54:douta={`STORE,`gr3,1'b0,`gr7,4'h7};        // store to mem27
        55:douta={`SLA,`gr3,1'b0,`gr2,4'hf};          // gr3 <= gr1 < 15
        56:douta={`STORE,`gr3,1'b0,`gr7,4'h8};        // store to mem28
        57:douta={`SRA,`gr3,1'b0,`gr1,4'h0};          // gr3 <= gr1 > 0
        58:douta={`STORE,`gr3,1'b0,`gr7,4'h9};        // store to mem29
        59:douta={`SRA,`gr3,1'b0,`gr1,4'h1};          // gr3 <= gr1 > 1
        60:douta={`STORE,`gr3,1'b0,`gr7,4'ha};        // store to mem2a
        61:douta={`SRA,`gr3,1'b0,`gr1,4'h8};          // gr3 <= gr1 > 8
        62:douta={`STORE,`gr3,1'b0,`gr7,4'hb};        // store to mem2b
        63:douta={`SRA,`gr3,1'b0,`gr1,4'hf};          // gr3 <= gr1 > 15
        64:douta={`STORE,`gr3,1'b0,`gr7,4'hc};        // store to mem2c
        65:douta={`SRA,`gr3,1'b0,`gr2,4'h0};          // gr3 <= gr1 > 0
        66:douta={`STORE,`gr3,1'b0,`gr7,4'hd};        // store to mem2d
        67:douta={`SRA,`gr3,1'b0,`gr2,4'h1};          // gr3 <= gr1 > 1
        68:douta={`STORE,`gr3,1'b0,`gr7,4'he};        // store to mem2e
        69:douta={`SRA,`gr3,1'b0,`gr2,4'h8};          // gr3 <= gr1 > 8
        70:douta={`STORE,`gr3,1'b0,`gr7,4'hf};        // store to mem2f
        71:douta={`ADDI,`gr7,4'd1,4'd0};              // gr7 <= 16'h30 for store address
        72:douta={`SRA,`gr3,1'b0,`gr2,4'hf};          // gr3 <= gr1 > 15
        73:douta={`STORE,`gr3,1'b0,`gr7,4'h0};        // store to mem30
        74:douta={`LOAD,`gr1,1'b0,`gr0,4'h5};         // gr1 <= 41
        75:douta={`LOAD,`gr2,1'b0,`gr0,4'h6};         // gr2 <= ffff
        76:douta={`LOAD,`gr3,1'b0,`gr0,4'h7};         // gr3 <= 1
        77:douta={`JUMP, 3'd0,8'h4f};                 // jump to 4f
        78:douta={`STORE,`gr7,1'b0,`gr7,4'h1};        // store to mem31
        79:douta={`JMPR, `gr1,8'h10};                 // jump to 41+10 = 51
        80:douta={`STORE,`gr7,1'b0,`gr7,4'h2};        // store to mem32
        81:douta={`ADD, `gr4,1'b0,`gr2,1'b0,`gr3};    // gr4<= ffff + 1,cf<=1
        82:douta={`BNC,`gr1,8'h28};                   // if(cf==0) jump to 69
        83:douta={`BC,`gr1,8'h14};                    // if(cf==1) jump to 55
        84:douta={`STORE,`gr7,1'b0,`gr7,4'h3};        // store to mem33
        85:douta={`ADD, `gr4,1'b0,`gr3,1'b0,`gr3};    // gr4<= 1 + 1 , cf<=0
        86:douta={`BC,`gr1,8'h28};                    // if(cf==1) jump to 69
        87:douta={`BNC,`gr1,8'h18};                   // if(cf==0) jump to 59
        88:douta={`STORE,`gr7,1'b0,`gr7,4'h4};        // store to mem34
        89:douta={`CMP, 3'd0,1'b0,`gr3,1'b0,`gr3};    // 1-1=0 , zf<=1,nf<=0
        90:douta={`BNZ,`gr1,8'h28};                   // if(zf==0) jump to 69
        91:douta={`BZ,`gr1,8'h1c};                    // if(zf==1) jump to 5d
        92:douta={`STORE,`gr7,1'b0,`gr7,4'h5};        // store to mem35
        93:douta={`CMP, 3'd0,1'b0,`gr4,1'b0,`gr3};    // 2-1=1 , zf<=0,nf<=0
        94:douta={`BZ,`gr1,8'h28};                    // if(zf==1) jump to 69
        95:douta={`BNZ,`gr1,8'h20};                   // if(zf==0) jump to 61
        96:douta={`STORE,`gr7,1'b0,`gr7,4'h6};        // store to mem36
        97:douta={`CMP, 3'd0,1'b0,`gr3,1'b0,`gr4};    // 1-2=-1, nf<=1,zf<=0
        98:douta={`BNN,`gr1,8'h28};                   // if(nf==0) jump to 69
        99:douta={`BN,`gr1,8'h24};                    // if(nf==1) jump to 65
        100:douta={`STORE,`gr7,1'b0,`gr7,4'h7};       // store to mem37
        101:douta={`CMP, 3'd0,1'b0,`gr4,1'b0,`gr3};   // 2-1=1, nf<=0,zf<=0
        102:douta={`BN,`gr1,8'h28};                   // if(nf==1) jump to 69
        103:douta={`BNN,`gr1,8'h27};                  // if(nf==0) jump to 68
        104:douta={`STORE,`gr7,1'b0,`gr7,4'h8};       // store to mem38
        105:douta={`HALT, 11'd0};                     // STOP
        */


    //¹«±¶Êý
/*
    0:douta <= {`LOAD, `gr1, 1'b0, `gr0, 4'b0001};  //gr1=0009
    1:douta <= {`LOAD, `gr2, 1'b0, `gr0, 4'b0010};  //gr2 = 0003
    2:douta <= {`ADD, `gr3, 1'b0, `gr0, 1'b0, `gr1}; //gr3=0009  0006  0003
    3:douta <= {`SUB, `gr1, 1'b0, `gr1, 1'b0, `gr2}; //gr1=0006  0003  0
    4:douta <= {`BZ, `gr0, 8'b0000_1001}; //no no jump to 09
    5:douta <= {`BNN, `gr0,  8'b0000_0010}; //jump to 2  jump to 2
    6:douta <= {`ADD, `gr1, 1'b0, `gr0, 1'b0, `gr2};
    7:douta <= {`ADD, `gr2, 1'b0, `gr0, 1'b0, `gr3};
    8:douta <= {`JUMP, 11'b000_0000_0010};
    9:douta <= {`STORE, `gr2, 1'b0, `gr0, 4'b0011}; //d[3:douta=0003
    10:douta <= {`LOAD, `gr1, 1'b0, `gr0, 4'b0001}; //gr1 = 0009
    11:douta <= {`LOAD, `gr2, 1'b0, `gr0, 4'b0010}; //gr2 = 0003
    12:douta <= {`ADDI, `gr4, 8'h1}; // gr4=1
    13:douta <= {`SUB, `gr2, 1'b0, `gr2, 1'b0, `gr3}; //gr2 = 0
    14:douta <= {`BZ, `gr0, 8'b0001_0000}; //jump to 16
    15:douta <= {`JUMP, 11'b000_0000_1100}; //
    16:douta <= {`SUBI, `gr4, 8'h1}; // gr4 = 0  -1
    17:douta <= {`BN, `gr0, 8'b0001_0100}; //no  jump to 20
    18:douta <= {`ADD, `gr5, 1'b0, `gr5, 1'b0, `gr1};  //gr5 = 0009
    19:douta <= {`JUMP, 11'b000_0001_0000}; //jump to 16
    20:douta <= {`STORE, `gr5, 1'b0, `gr0, 4'b0100}; //d[4:douta=0009
    21:douta <= {`LOAD, `gr1, 1'b0, `gr0, 4'b0011};//gr1=0003
    22:douta <= {`LOAD, `gr2, 1'b0, `gr0, 4'b0100};//gr2=0009
    23:douta <= {`HALT, 11'b000_0000_0000};
*/

   //64Î»¼Ó·¨Æ÷:64badder
    /*
    0:douta=16'h4c04 ; //{`ADDI,`gr4,8'h04};  gr4=0004
    1:douta=16'h1100 ; //{`LOAD, `gr1, 1'b0, `gr0, 4'b0000};  gr1 = fffe
    2:douta=16'h1204 ; //{`LOAD, `gr2, 1'b0, `gr0, 4'b0100};  gr2 = ffff
    3:douta=16'h4312 ; //{`ADD, `gr3, 1'b0, `gr1, 1'b0, `gr2};  gr3 = fffd
    4:douta=16'hfd06 ; //{`BNC, `gr5, 8'b0000_0110};  no
    5:douta=16'h4e01 ; //{`ADDI,`gr6,8'h01};  gr6=0001
    6:douta=16'h4337 ; //{`ADD, `gr3, 1'b0, `gr3, 1'b0, `gr7};  gr3 = fffd
    7:douta=16'hfd0b ; //{`BNC, `gr5, 8'b0000_1011};jump to 11
    8:douta=16'h5e00 ;  //{`SUBI, `gr6, 8'h0};
    9:douta=16'hdd0b ;   //{`BNZ, `gr5, 8'h0b};
    10:douta=16'h4e01 ;  //{`ADDI,`gr6,8'h01};
    11:douta=16'h5777 ;    //{`SUB, `gr7, 1'b0, `gr7, 1'b0, `gr7};  gr7 = 0
    12:douta=16'h4776 ;  //{`ADD, `gr7, 1'b0, `gr7, 1'b0, `gr6};  gr7 = 0001
    13:douta=16'h5666 ;    //{`SUB, `gr6, 1'b0, `gr6, 1'b0, `gr6};  gr6 = 0
    14:douta=16'h1b08 ;  //{`STORE, `gr3, 1'b0, `gr0, 4'b1000};  d[8:douta=fffd
    15:douta=16'h4801 ;     //{`ADDI,`gr0,8'h01};  gr0=0001
   16:douta=16'h6004 ;  //{`CMP, 3'b0,1'b0,`gr0,1'b0,`gr4}; 1<4
   17:douta=16'he501 ; //{`BN, `gr5, 8'b0000_0001};  jump to 1
    18:douta=16'h0800 ; //halt
    */


    //Ã°ÅÝÅÅÐò
    /*
    0:douta <= {`LOAD, `gr3, 1'b0, `gr0, 4'b0000};  //gr3=000a;
    1:douta <= {`SUBI, `gr3, 4'd0, 4'd2};   //gr3=0008
    2:douta <= {`ADD, `gr1, 1'b0, `gr0, 1'b0, `gr0};  //gr1=0
    3:douta <= {`ADD, `gr2, 1'b0, `gr3, 1'b0, `gr0}; //gr2=0008
    4:douta <= {`LOAD, `gr4, 1'b0, `gr2, 4'd1}; //gr4=d[9:douta=1057
    5:douta <= {`LOAD, `gr5, 1'b0, `gr2, 4'd2}; //gr5=d[10:douta=2895
    6:douta <= {`CMP, 3'd0, 1'b0, `gr5, 1'b0, `gr4}; //d[10:douta > d[9:douta
    7:douta <= {`BN, `gr0, 4'b0000, 4'b1010};  //no
    8:douta <= {`STORE, `gr4, 1'b0, `gr2, 4'd2}; //d[10:douta=gr4
    9:douta <= {`STORE, `gr5, 1'b0, `gr2, 4'd1}; //d[9:douta=gr5;
    10:douta <= {`SUBI, `gr2, 4'd0, 4'd1};  //gr2=0007
    11:douta <= {`CMP, 3'd0, 1'b0, `gr2, 1'b0, `gr1}; //gr2>gr1
    12:douta <= {`BNN, `gr0, 4'h0, 4'b0100}; //
    13:douta <= {`ADDI, `gr1, 4'd0, 4'd1};
    14:douta <= {`CMP, 3'd0, 1'b0, `gr3, 1'b0, `gr1};
    15:douta <= {`BNN, `gr0, 4'h0, 4'b0011};
    16:douta <= {`HALT, 11'd0};
    */

    //ÅÅÐòsort
    /*
    0:douta <= {`ADDI, `gr1, 4'b0000,  4'b1001};
    1:douta <= {`ADDI, `gr2, 4'b0000,  4'b1001};
    2:douta <= {`JUMP, 11'b000_0000_0101};//jump to start
    3:douta <= {`SUBI, `gr1, 4'd0, 4'd1};//new_round
    4:douta <= {`BZ, `gr7, 4'b0001, 4'b0010};//jump to end
    5:douta <= {`LOAD, `gr3, 1'b0, `gr0, 4'd0};//start
    6:douta <= {`LOAD, `gr4, 1'b0, `gr0, 4'd1};
    7:douta <= {`CMP, 3'd0, 1'b0, `gr3, 1'b0, `gr4};
    8:douta <= {`BN, `gr7, 4'h0, 4'b1011};//jump to NO_op
    9:douta <= {`STORE, `gr3, 1'b0, `gr0, 4'd1};
    10:douta <= {`STORE, `gr4, 1'b0, `gr0, 4'd0};
    11:douta <= {`ADDI, `gr0, 4'b0000, 4'b0001};//NO_OP
    12:douta <= {`CMP, 3'd0, 1'b0, `gr0, 1'b0, `gr2};
    13:douta <= {`BN, `gr7, 4'b0001, 4'b0001};//jump to continue
    14:douta <= {`SUBI, `gr2, 4'd0, 4'd1};
    15:douta <= {`SUB, `gr0, 1'b0,`gr0, 1'b0,`gr0};
    16:douta <= {`JUMP, 11'b000_0000_0011};//jump to new round
    17:douta <= {`JUMP, 11'b000_0000_0101};//jump to start,continue
    18:douta <= {`HALT, 11'd0};//end
    */



endmodule
