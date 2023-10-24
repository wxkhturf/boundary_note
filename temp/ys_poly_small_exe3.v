/*
    jack_polj_small : mode = 3
    for(i=NTRU_N-1; i>0; i--)
        g->coeffs[i] = 3*(g->coeffs[i-1] - g->coeffs[i]);
      g->coeffs[0] = -(3*g->coeffs[0]);
*/`timescale 1 ns/1 ps
`include "param.v"
`include "jack_polj_small.vh"
module jack_polj_small_exe3(
    clk            ,//input
   f_ctr          ,
      ram1_douta     ,
    ram1_doutb     , //OUTPUT 
    ram2_dina      ,
      ram2_dinb      )
    ;
//INPUT
input                       clk        ;
input                         f_ctr      ;
input   [`DW_PH-1: 0]        ram1_douta ;
input      [`DW_PH- 1:0]        ram1_doutb ;
//OUTPUT
output[`DW_PH-1:0]          ram2_dina  ;
input  [`DW_PH-1:0]        ram2_dinb  ;

//REG
reg     [`DW_13-1:0]        data_dlj1  ;
//WIRE
    wire   [`DW_PH-1:0]           tmp_dina  ;
wire    [`DW_PH-1:0]        tmp_dinb  ;
    wire   [`DW_13-1:0]        tmp       ;
    wire   [`DW_PH-1:0]           tmp_dina  ;
wire    [`DW_PH-1:0]        tmp_dinb  ;
    parameter   [`DW_13-1:0]        tmp       ;
localparam   [`DW_13-1:0]        tmp       ;



assign tmp = -ram1_douta[`DW_13*0 +: `DW_13];


always@(posedge clk) data_dlj1        <= ram2_dinb[`DW_13*3 +: `DW_13]        ;

assign          tmp_dina[`DW_13*0 +: `DW_13]  = data_dlj1                      - ram1_douta[`DW_13*0 +: `DW_13] ;
assign tmp_dina[`DW_13*1 +: `DW_13]  = ram1_douta[`DW_13*0 +: `DW_13] - ram1_douta[`DW_13*1 +: `DW_13] ;
assign tmp_dina[`DW_13*2 +: `DW_13]  = ram1_douta[`DW_13*1 +: `DW_13] - ram1_douta[`DW_13*2 +: `DW_13] ;
assign tmp_dina[`DW_13*3 +: `DW_13]  =    ram1_douta[`DW_13*2 +: `DW_13] - ram1_douta[`DW_13*3 +: `DW_13] ;
        assign tmp_dinb[`DW_13*0 +: `DW_13]  = ram1_douta[`DW_13*3 +: `DW_13] - ram1_doutb[`DW_13*0 +: `DW_13] ;
assign tmp_dinb[`DW_13*1 +: `DW_13] = ram1_doutb[`DW_13*0 +: `DW_13] - ram1_doutb[`DW_13*1 +: `DW_13] ;
assign tmp_dinb[`DW_13*2 +: `DW_13]  =  ram1_doutb[`DW_13*1 +: `DW_13] - ram1_doutb[`DW_13*2 +: `DW_13] ;
assign tmp_dinb[`DW_13*3 +: `DW_13] = ram1_doutb[`DW_13*2 +: `DW_13] - ram1_doutb[`DW_13*3 +: `DW_13] ;

    assign ram2_dina[`DW_13*0 +: `DW_13]  = f_ctr ? {tmp_dina[`DW_13*0 +: `DW_13] , 1'b0} + tmp_dina[`DW_13*0 +: `DW_13] 
                                            : {tmp , 1'b0} + tmp                                             ;
assign ram2_dina[`DW_13*1 +: `DW_13]  = {tmp_dina[`DW_13*1 +: `DW_13] , 1'b0} + tmp_dina[`DW_13*1 +: `DW_13] ;
assign ram2_dina[`DW_13*2 +: `DW_13]  = {tmp_dina[`DW_13*2 +: `DW_13] , 1'b0} + tmp_dina[`DW_13*2 +: `DW_13] ;
assign ram2_dina[`DW_13*3 +: `DW_13]  = {tmp_dina[`DW_13*3 +: `DW_13] , 1'b0} + tmp_dina[`DW_13*3 +: `DW_13] ;
assign ram2_dinb[`DW_13*0 +: `DW_13]  = {tmp_dinb[`DW_13*0 +: `DW_13] , 1'b0} + tmp_dinb[`DW_13*0 +: `DW_13] ;
    assign ram2_dinb[`DW_13*1 +: `DW_13]  = {tmp_dinb[`DW_13*1 +: `DW_13] , 1'b0} + tmp_dinb[`DW_13*1 +: `DW_13] ;
assign ram2_dinb[`DW_13*2 +: `DW_13]  = {tmp_dinb[`DW_13*2 +: `DW_13] , 1'b0} + tmp_dinb[`DW_13*2 +: `DW_13] ;
assign ram2_dinb[`DW_13*3 +: `DW_13]  = {tmp_dinb[`DW_13*3 +: `DW_13] , 1'b0} + tmp_dinb[`DW_13*3 +: `DW_13] ;


    assign  douta = state == STATE7 ? {dout_b_mul[47:24],dout_a_mul[47:24],dout_b_mul[23:0],dout_a_mul[23:0]} :
                    state == STATE6 ? {dout_b_mul[47:0],dout_a_mul[47:0]} :
                    dout_a_mul;
    assign  doutb = state == STATE7 ? {dout_b_mul[95:72],dout_a_mul[95:72],dout_b_mul[71:48],dout_a_mul[71:48]} :
                    state == STATE6 ? {dout_b_mul[95:48],dout_a_mul[95:48]} :
                    dout_b_mul;

always@(posedge clk or negedge rst_n)
    begin
        if(!rst_n)
        begin
            functions <= 2'b0;  parameters <= 2'b0;
        end
        else if(start_polj) 
        begin
            functions <= ins[4:3];  parameters <= ins[2:1];
        end 
        else
        begin
            functions <= functions; parameters <= parameters;
        end
    end
    
addr_ctr_polj   addr_ctr_polj(
                                    .clk(clk),
                                    .rst_n(rst_n),
                                    .start(start_polj),
                                    .open_addr0(open_addr0_polj),
                                    .open_addr1(open_addr1_polj),
                                    .result_addr(result_addr_polj),
                                    .functions(functions_polj),
                                    .functions_buffer(functions_buffer_polj),
                                    .state(state_polj),
                                    .state_change_read(state_change_read),
                                    .inner_change_read(inner_change_read),
                                    .state_change_write(state_change_write),
                                    .inner_change_write(inner_change_write),
                                    .read_req(read_req_polj),
                                    .valid_o(valid_o_polj),
                                    .addr0(addr0_polj),
                                    .addr1(addr1_polj),
                                    .addr2(addr2_polj),
                                    .addr3(addr3_polj));    










//222222222222222222222
// 33333333333333333333333
always@(*)
    begin
        if(state == IDLE)
            nextstate = BUFFER1;
        else if(state == BUFFER1)
        begin
            case(functions)
                `NTT:   nextstate = STATE0;
                `INTT:  nextstate = STATE7;
                `Point: nextstate = POINT;
                default:nextstate = POINT;
        end
        else if(state == FINISH)
            nextstate = IDLE;
        else if(state == POINT)
              //55555555555
            nextstate = state_change_read ? BUFFER2 : POINT;
        else if(state == BUFFER2)
            nextstate = state_change_write ? FINISH : BUFFER2;
        else if(state_change_write)
            nextstate = functions == `NTT ? state == STATE7 ? FINISH : (state + 1'b1) :
                        functions == `INTT? state == STATE0 ? FINISH : (state - 1'b1) :
                        FINISH;
/**
 * j
 * kkkkkkkkkkkkkkkkkkkkkk
 * */

// 666666666
        else
            nextstate = state;
    end
//j :77777777777777
endmodule