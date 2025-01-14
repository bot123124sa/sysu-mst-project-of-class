`timescale 1ns / 1ps
`include "headfile.v"

module PCPU(input wire reset, enable, clock, start,
    input wire [15:0] d_datain,  //data from memory
    i_datain,                    //instruction
    output wire [7:0] d_addr,    //address for data memory
    output wire [7:0] i_addr,    //pc
    output wire [15:0] d_dataout,//output data to data memory
    output wire d_we         ,    //write enable
    output wire [15:0] y
    );
reg state,next_state;  //to control the CPU
reg [7:0] pc;
reg [15:0] id_ir,ex_ir,mem_ir,wb_ir;
reg [15:0] reg_A, reg_B, reg_C, reg_C1, smdr, smdr1, ALUo;
reg dw, zf, nf, cf, cin;
reg [15:0] gr[0:7];
assign d_dataout = smdr1;
assign d_we = dw;
assign d_addr = reg_C[7:0];
assign i_addr = pc;

//************* CPU control *************//
always @(posedge clock or negedge reset)
    begin
        if ((!reset) )
            state <= `idle;
        else
            state <= next_state;
    end
always @(*)
    begin
        case (state)
            `idle :
                if ((enable == 1'b1) && (start == 1'b1)) // on
                    next_state <= `exec;
                else
                    next_state <= `idle;
            `exec :
                if ((enable == 1'b0) || (wb_ir[15:11] == `HALT))//pause
                    next_state <= `idle;
                else
                    next_state <= `exec;
        endcase
    end

/************* IF *************/
always @(posedge clock or negedge reset)
    begin
        if (!reset)
            begin
                id_ir <= 16'b0000_0000_0000_0000;
                pc <= 8'b0000_0000;
            end

        else if (state ==`exec)
            begin
            if((ex_ir[15:11] == `BZ && zf == 1'b1) || (ex_ir[15:11] == `BN && nf == 1'b1)
                    ||(ex_ir[15:11] == `BNZ && zf == 1'b0) || (ex_ir[15:11] == `BNN && nf == 1'b0)
                     ||(ex_ir[15:11] == `BC && cin == 1'b1) || (ex_ir[15:11] == `BNC && cin == 1'b0)
                     || ex_ir[15:11] == `JMPR)
                    begin
                       pc <= ALUo[7:0];
                       id_ir <= 16'b0;//flush
                   end
                else if(id_ir[15:11] == `JUMP)
                   begin
                  pc <= id_ir[7:0]; //jump to {val2,val3}
                       id_ir <= 16'b0;
               end
                else if(id_ir[15:11] == `HALT) // STOP
                    begin
                       pc <= pc;
                       id_ir <= id_ir;
                    end
            //Load hazard  Stall
                else if((id_ir[15:11] == `LOAD)&&(i_datain[15:11]!=`JUMP)&&(i_datain[15:11]!=`NOP)&&(i_datain[15:11]!=`HALT)
                  &&(i_datain[15:11]!=`LOAD))
                 begin
                      //r1
                   if((id_ir[10:8]==i_datain[2:0])&&((i_datain[15:11]==`ADD)||(i_datain[15:11]==`ADDC)
                       ||(i_datain[15:11]==`SUB)||(i_datain[15:11]==`SUBC)||(i_datain[15:11]==`CMP)))
                       begin
                         pc <= pc;
                         id_ir <= 16'b0;
                       end
                      //r2
                    else if((id_ir[10:8]==i_datain[6:4])&&((i_datain[15:11]==`STORE)||(i_datain[15:11]==`ADD)
                      ||(i_datain[15:11]==`ADDC)||(i_datain[15:11]==`SUB)||(i_datain[15:11]==`SUBC)||(i_datain[15:11]==`CMP)||(i_datain[15:11]==`SLL)
                        ||(i_datain[15:11]==`SRL)||(i_datain[15:11]==`SLA)||(i_datain[15:11]==`SRA)))
                       begin
                         pc <= pc;
                         id_ir <= 16'b0;
                       end
                      //r3
                   else if((id_ir[10:8]==i_datain[10:8])&&((i_datain[15:11]==`STORE)||(i_datain[15:11]==`LDIH)
                      ||(i_datain[15:11]==`SUBI)||(i_datain[15:11]==`JMPR)||(i_datain[15:11]==`BZ)||(i_datain[15:11]==`BNZ)
                       ||(i_datain[15:11]==`BN)||(i_datain[15:11]==`BNN)||(i_datain[15:11]==`BNC)||(i_datain[15:11]==`BNC)))
                       begin
                         pc <= pc;
                         id_ir <= 16'b0;
                       end
                      else
                         begin
                            pc <= pc + 1'b1;
                         id_ir <= i_datain;
                          end
                   end
                else
                   begin
                       pc <= pc + 1'b1;
                       id_ir <= i_datain;
                    end
            end
         else if(state==`idle)
                begin
                   id_ir <= id_ir;
                    pc <= pc;
                end
    end

/************* ID *************/
always @(posedge clock or negedge reset)
    begin
        if (!reset )
            begin
                ex_ir <= 16'b0000_0000_0000_0000;
                reg_A <= 16'b0000_0000_0000_0000;
                reg_B <= 16'b0000_0000_0000_0000;
                smdr <= 16'b0000_0000_0000_0000;
            end
        //flush
        else if(state == `exec && ((ex_ir[15:11]==`BZ && zf==1'b1) ||(ex_ir[15:11]==`BNZ && zf==1'b0)
              ||(ex_ir[15:11]==`BN && nf==1'b1) || (ex_ir[15:11]==`BNN && nf==1'b0) ||(ex_ir[15:11]==`BC && cin==1'b1)
            ||(ex_ir[15:11]==`BNC && cin==1'b0) || ex_ir[15:11]==`JMPR||ex_ir[15:11]==`JUMP))
              ex_ir <= 16'b0;

      else if (state == `exec)
            begin
                    ex_ir <= id_ir;
               //regA
               //r1=r1+{val2,val3}
                if ((id_ir[15:11] == `BZ) || (id_ir[15:11] == `BNZ) || (id_ir[15:11] == `BN) || (id_ir[15:11] == `BNN)
                  || (id_ir[15:11] == `BC) || (id_ir[15:11] == `BNC) || (id_ir[15:11] == `LDIH) || (id_ir[15:11] == `ADDI)
                  || (id_ir[15:11] == `SUBI) || (id_ir[15:11] == `JMPR))
                  begin
                    //r1δд��
                   if(id_ir[10:8]==ex_ir[10:8]&&(ex_ir[15:11] == `ADD || ex_ir[15:11] == `LDIH || ex_ir[15:11] == `ADDI || ex_ir[15:11] == `SUB
                          || ex_ir[15:11] == `SUBI || ex_ir[15:11] == `ADDC || ex_ir[15:11] == `SUBC || ex_ir[15:11] == `SLL || ex_ir[15:11] == `SRL
                          || ex_ir[15:11] == `SLA || ex_ir[15:11] == `SRA ))
                       reg_A <= ALUo;
                    else if(id_ir[10:8] == mem_ir[10:8]&&(mem_ir[15:11] == `ADD || mem_ir[15:11] == `LDIH || mem_ir[15:11] == `ADDI
                            || mem_ir[15:11] == `SUB || mem_ir[15:11] == `SUBI || mem_ir[15:11] == `ADDC
                             || mem_ir[15:11] == `SUBC
                             || mem_ir[15:11] == `SLL || mem_ir[15:11] == `SRL || mem_ir[15:11] == `SLA || mem_ir[15:11] == `SRA
                             || mem_ir[15:11] == `LOAD))
                             begin
                                 if(mem_ir[15:11]==`LOAD)
                               reg_A <= d_datain;
                            else
                              reg_A <= reg_C;
                       end
               else if(wb_ir[10:8] == id_ir[10:8]&&(wb_ir[15:11] == `ADD || wb_ir[15:11] == `LDIH || wb_ir[15:11] == `ADDI
                           || wb_ir[15:11] == `SUB || wb_ir[15:11] == `SUBI || wb_ir[15:11] == `ADDC || wb_ir[15:11] == `SUBC
                             || wb_ir[15:11] == `SLL
                             || wb_ir[15:11] == `SRL || wb_ir[15:11] == `SLA || wb_ir[15:11] == `SRA || wb_ir[15:11] == `LOAD ))
                       reg_A <= reg_C1;
                    else
                       reg_A <= gr[(id_ir[10:8])];//gr1
                  end
                //r1=r2#r3 or r1=r2#val
                else if(id_ir[15:11] == `LOAD || id_ir[15:11] == `STORE || id_ir[15:11] == `ADD || id_ir[15:11] == `SUB
                        || id_ir[15:11] == `ADDC || id_ir[15:11] == `SUBC || id_ir[15:11] == `CMP || id_ir[15:11] == `SLL || id_ir[15:11] == `SRL
                          || id_ir[15:11] == `SLA || id_ir[15:11] == `SRA)
                    begin

                       if( (ex_ir[15:11] == `ADD || ex_ir[15:11] == `LDIH || ex_ir[15:11] == `ADDI || ex_ir[15:11] == `SUB
                          || ex_ir[15:11] == `SUBI || ex_ir[15:11] == `ADDC || ex_ir[15:11] == `SUBC || ex_ir[15:11] == `SLL || ex_ir[15:11] == `SRL
                          || ex_ir[15:11] == `SLA || ex_ir[15:11] == `SRA )&& ex_ir[10:8] == id_ir[6:4])
                            reg_A <= ALUo;
                        else if( (mem_ir[15:11] == `ADD || mem_ir[15:11] == `LDIH || mem_ir[15:11] == `ADDI
                              || mem_ir[15:11] == `SUB || mem_ir[15:11] == `SUBI || mem_ir[15:11] == `ADDC
                               || mem_ir[15:11] == `SUBC
                               || mem_ir[15:11] == `SLL || mem_ir[15:11] == `SRL || mem_ir[15:11] == `SLA || mem_ir[15:11] == `SRA
                               || mem_ir[15:11] == `LOAD)&& mem_ir[10:8] == id_ir[6:4])
                                 if(mem_ir[15:11]==`LOAD)
                              reg_A <= d_datain;
                           else
                                    reg_A <= reg_C;
                        else if( (wb_ir[15:11] == `ADD || wb_ir[15:11] == `LDIH || wb_ir[15:11] == `ADDI || wb_ir[15:11] == `SUB
                            || wb_ir[15:11] == `SUBI || wb_ir[15:11] == `ADDC || wb_ir[15:11] == `SUBC || wb_ir[15:11] == `SLL || wb_ir[15:11] == `SRL
                            || wb_ir[15:11] == `SLA || wb_ir[15:11] == `SRA || wb_ir[15:11] == `LOAD )&& wb_ir[10:8] == id_ir[6:4])
                             reg_A <= reg_C1;
                        else
                            reg_A <= gr[id_ir[6:4]];//gr2
                     end
                //flush
               else if((mem_ir[15:11]==`BZ && zf==1'b1) ||(mem_ir[15:11]==`BNZ && zf==1'b0)
                  ||(mem_ir[15:11]==`BN && nf==1'b1) || (mem_ir[15:11]==`BNN && nf==1'b0) ||(mem_ir[15:11]==`BC && cin==1'b1)
                ||(mem_ir[15:11]==`BNC && cin==1'b0) || mem_ir[15:11]==`JMPR)
                    reg_A <= 16'b0;
                else if(id_ir[15:11] == `JUMP)
                    reg_A <= 16'b0;
                else
                    reg_A <= gr[id_ir[6:4]];//gr2
                //regB
                if (id_ir[15:11] == `LOAD || id_ir[15:11] == `STORE || id_ir[15:11] == `SLL || (id_ir[15:11] == `SRL)
                  || (id_ir[15:11] == `SLA) || (id_ir[15:11] == `SRA))
                    reg_B <= {12'b0000_0000_0000, id_ir[3:0]};//val3
                else if ((id_ir[15:11] == `BZ) || (id_ir[15:11] == `BNZ) || (id_ir[15:11] == `BN) || (id_ir[15:11] == `BNN)
                      || (id_ir[15:11] == `BC) || (id_ir[15:11] == `BNC)
                      || (id_ir[15:11] == `ADDI) || (id_ir[15:11] == `SUBI) || (id_ir[15:11] == `JMPR))
                    reg_B <= {8'b0000_0000, id_ir[7:0]};//{00000000, value2��value3}
                else if(id_ir[15:11] == `LDIH)
                   reg_B <= {id_ir[7:0], 8'b0000_0000};//{val2,val3,00000000)
                //r1=r2#r3
                else if(id_ir[15:11] == `ADD || id_ir[15:11] == `SUB || id_ir[15:11] == `ADDC || id_ir[15:11] == `SUBC
                    || id_ir[15:11] == `CMP )
                    begin
                /***************************************************************start***************************************************************/
                        if( (ex_ir[15:11] == `ADD || ex_ir[15:11] == `LDIH || ex_ir[15:11] == `ADDI|| ex_ir[15:11] == `ADDC
                        || ex_ir[15:11] == `SUB || ex_ir[15:11] == `SUBI  || ex_ir[15:11] == `SUBC
                        || ex_ir[15:11] == `SLL || ex_ir[15:11] == `SRL || ex_ir[15:11] == `SLA || ex_ir[15:11] == `SRA 
                        || ex_ir[15:11] == `AND || ex_ir[15:11] == `OR || ex_ir[15:11] == `XOR)&& ex_ir[10:8] == id_ir[2:0])
                            begin
                                reg_B <= ALUo;
                            end
                        else if( (mem_ir[15:11] == `ADD || mem_ir[15:11] == `LDIH || mem_ir[15:11] == `ADDI || mem_ir[15:11] == `ADDC
                        || mem_ir[15:11] == `SUB || mem_ir[15:11] == `SUBI|| mem_ir[15:11] == `SUBC
                        || mem_ir[15:11] == `SLL || mem_ir[15:11] == `SRL || mem_ir[15:11] == `SLA || mem_ir[15:11] == `SRA
                        || mem_ir[15:11] == `AND || mem_ir[15:11] == `OR || mem_ir[15:11] == `XOR || mem_ir[15:11] == `LOAD )&& mem_ir[10:8] == id_ir[2:0])
                            begin
                                if(mem_ir[15:11]==`LOAD)
                                    reg_B <= d_datain;
                                else
                                    reg_B <= reg_C;
                            end
                        else if( (wb_ir[15:11] == `ADD || wb_ir[15:11] == `LDIH || wb_ir[15:11] == `ADDI || wb_ir[15:11] == `ADDC
                        || wb_ir[15:11] == `SUB  || wb_ir[15:11] == `SUBI || wb_ir[15:11] == `SUBC 
                        || wb_ir[15:11] == `SLL || wb_ir[15:11] == `SRL || wb_ir[15:11] == `SLA || wb_ir[15:11] == `SRA 
                        || wb_ir[15:11] == `AND || wb_ir[15:11] == `OR || wb_ir[15:11] == `XOR || wb_ir[15:11] == `LOAD)&& wb_ir[10:8] == id_ir[2:0])
                            begin
                                reg_B <= reg_C1;
                            end
/*****************************************************************end***************************************************************/
                        else
                            reg_B <= gr[id_ir[2:0]];//gr2
                    end
                //flush
                else if((mem_ir[15:11]==`BZ && zf==1'b1) ||(mem_ir[15:11]==`BNZ && zf==1'b0)
                  ||(mem_ir[15:11]==`BN && nf==1'b1) || (mem_ir[15:11]==`BNN && nf==1'b0) ||(mem_ir[15:11]==`BC && cin==1'b1)
                ||(mem_ir[15:11]==`BNC && cin==1'b0) || mem_ir[15:11]==`JMPR)
                    reg_B <= 16'bx;
                else if(id_ir[15:11] == `JUMP)
                   reg_B <= 16'b0;
                else
                    reg_B <= gr[id_ir[2:0]];//gr3
               //STORE
               if (id_ir[15:11] == `STORE)
                   begin

                      if(id_ir[10:8] == ex_ir[10:8] && (ex_ir[15:11] == `ADD || ex_ir[15:11] == `LDIH || ex_ir[15:11] == `ADDI
                         || ex_ir[15:11] == `SUB || ex_ir[15:11] == `SUBI || ex_ir[15:11] == `ADDC || ex_ir[15:11] == `SUBC
                         || ex_ir[15:11] == `SLL
                         || ex_ir[15:11] == `SRL || ex_ir[15:11] == `SLA || ex_ir[15:11] == `SRA ))
                           smdr <= ALUo;
                      else if(id_ir[10:8] == mem_ir[10:8] && (mem_ir[15:11] == `ADD || mem_ir[15:11] == `LDIH
                         || mem_ir[15:11] == `ADDI || mem_ir[15:11] == `SUB || mem_ir[15:11] == `SUBI || mem_ir[15:11] == `ADDC
                          || mem_ir[15:11] == `SUBC
                          || mem_ir[15:11] == `SLL || mem_ir[15:11] == `SRL || mem_ir[15:11] == `SLA || mem_ir[15:11] == `SRA
                          || mem_ir[15:11] == `LOAD))
                           begin
                          if(mem_ir[15:11]==`LOAD)
                              smdr <= d_datain;
                          else
                              smdr <= reg_C;
                     end
                      else if(id_ir[10:8] == wb_ir[10:8] && (wb_ir[15:11] == `ADD || wb_ir[15:11] == `LDIH
                         || wb_ir[15:11] == `LOAD || wb_ir[15:11] == `ADDI || wb_ir[15:11] == `SUB || wb_ir[15:11] == `SUBI
                          || wb_ir[15:11] == `ADDC || wb_ir[15:11] == `SUBC
                          || wb_ir[15:11] == `SLL || wb_ir[15:11] == `SRL || wb_ir[15:11] == `SLA
                          || wb_ir[15:11] == `SRA ))
                           smdr <= reg_C1;
                      else
                          smdr <= gr[id_ir[10:8]];
                    end
                else
                    smdr <= gr[id_ir[10:8]];


            end
   end

/************* ALU *************/
reg signed [15:0] reg_A1;// for SRA
always @(*)
begin
  reg_A1 <= reg_A;
end

always @(*)
    begin
/***************************************************************start***************************************************************/
        if(ex_ir[15:11] == `ADD || ex_ir[15:11] == `LDIH || ex_ir[15:11] == `ADDI 
        || ex_ir[15:11] == `LOAD|| ex_ir[15:11] == `STORE || ex_ir[15:11] == `JMPR
        || ex_ir[15:11] == `BN || ex_ir[15:11] == `BNN || ex_ir[15:11] == `BZ || ex_ir[15:11] == `BNZ|| ex_ir[15:11] == `BC || ex_ir[15:11] == `BNC
        )
            begin
                {cf,ALUo} <= reg_A + reg_B;
            end
        else if(ex_ir[15:11] == `CMP || ex_ir[15:11] == `SUB || ex_ir[15:11] == `SUBI)   
            begin
                {cf,ALUo} <= reg_A - reg_B;
            end
        else if(ex_ir[15:11] == `ADDC)   
            begin
                {cf,ALUo} <= reg_A + reg_B + cin;
            end
        else if(ex_ir[15:11] == `SUBC)   
            begin
                {cf,ALUo} <= reg_A - reg_B - cin;
            end
        else if(ex_ir[15:11] == `OR)   
            begin
                {cf,ALUo} <= reg_A | reg_B;
            end
        else if(ex_ir[15:11] == `AND)   
            begin
                {cf,ALUo} <= reg_A & reg_B;
            end
        else if(ex_ir[15:11] == `XOR)   
            begin
                {cf,ALUo} <= reg_A ^ reg_B;
            end
        else if(ex_ir[15:11] == `SLL)   
            begin
                {cf,ALUo} <= reg_A << reg_B;
            end
        else if(ex_ir[15:11] == `SRL)   
            begin
                {cf,ALUo} <= reg_A >> reg_B;
            end
        else if(ex_ir[15:11] == `SLA)   
            begin
                {cf,ALUo} <= reg_A <<< reg_B;
            end
        else if(ex_ir[15:11] == `SRA)   
            begin
                {cf,ALUo} <= reg_A >>> reg_B;
            end
/*****************************************************************end***************************************************************/
        else
            {cf, ALUo} <= 17'b0;
    end

/************* EX *************/
always @(posedge clock or negedge reset)
    begin
        if (!reset)
            begin
                mem_ir <= 16'b0000_0000_0000_0000;
                reg_C <= 16'b0000_0000_0000_0000;
                smdr1 <= 16'b0000_0000_0000_0000;
                zf <= 1'b0;
                nf <= 1'b0;
                cin <= 1'b0;
                dw <= 1'b0;
            end
       else if (state == `exec)
            begin
                mem_ir <= ex_ir;
                reg_C <= ALUo;

                if ((ex_ir[15:11] == `ADD) || (ex_ir[15:11] == `CMP) || (ex_ir[15:11] == `LDIH) || (ex_ir[15:11] == `ADDI)
                 || (ex_ir[15:11] == `ADDC) || (ex_ir[15:11] == `SUB) || (ex_ir[15:11] == `SUBI) || (ex_ir[15:11] == `SUBC))
                    begin
                        if (ALUo == 16'b0000_0000_0000_0000)
                            zf <= 1'b1;//if zero
                        else
                            zf <= 1'b0;
                        if (ALUo[15] == 1'b1)//if negative
                            nf <= 1'b1;
                        else
                            nf <= 1'b0;
                    end
                else
                  begin
                     zf <= zf;
                      nf <= nf;
                  end
                //carry
                if ((ex_ir[15:11] == `ADD) || (ex_ir[15:11] == `LDIH) || (ex_ir[15:11] == `ADDI) || (ex_ir[15:11] == `ADDC)
                 || (ex_ir[15:11] == `SUB) || (ex_ir[15:11] == `SUBI) || (ex_ir[15:11] == `SUBC))
                      cin <= cf;
                else
                      cin <= cin;
                //STORE
                if (ex_ir[15:11] == `STORE)
                    begin
                        dw <= 1'b1;//data wire enable
                        smdr1 <= smdr;
                    end
                else
                   begin
                       dw <= 1'b0;
                        smdr1 <= 16'b0;
                    end

            end
   end

/************* MEM *************/
always @(posedge clock or negedge reset)
    begin
        if (!reset)
            begin
                wb_ir <= 16'b0000_0000_0000_0000;
                reg_C1 <= 16'b0000_0000_0000_0000;
            end
        else if (state == `exec)
            begin
                wb_ir <= mem_ir;
                if (mem_ir[15:11] == `LOAD)
                        reg_C1 <= d_datain;
                else
                        reg_C1 <= reg_C;
            end
   end

/************* WB *************/
always @(posedge clock or negedge reset)//д��
    begin
        if (!reset)
            begin
                gr[7] <= 16'b0000_0000_0000_0000;
                gr[6] <= 16'b0000_0000_0000_0000;
                gr[5] <= 16'b0000_0000_0000_0000;
                gr[4] <= 16'b0000_0000_0000_0000;
                gr[3] <= 16'b0000_0000_0000_0000;
                gr[2] <= 16'b0000_0000_0000_0000;
                gr[1] <= 16'b0000_0000_0000_0000;
                gr[0] <= 16'b0000_0000_0000_0000;
            end
        else if (state == `exec)
            begin
                if ((wb_ir[15:11] == `LOAD) || (wb_ir[15:11] == `ADD) || (wb_ir[15:11] == `LDIH) || (wb_ir[15:11] == `ADDI)
                 || (wb_ir[15:11] == `ADDC) || (wb_ir[15:11] == `SUB) || (wb_ir[15:11] == `SUBI) || (wb_ir[15:11] == `SUBC)
                 || (wb_ir[15:11] == `SLL)
                 ||(wb_ir[15:11] == `SRL) ||(wb_ir[15:11] == `SLA) || (wb_ir[15:11] == `SRA))
                    gr[wb_ir[10:8]] <= reg_C1;//write back to gr1
                else
                   gr[wb_ir[10:8]] <= gr[wb_ir[10:8]];
            end
   end


assign y = {8'B0,pc}; //





endmodule

