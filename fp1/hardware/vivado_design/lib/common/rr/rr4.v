//
//------------------------------------------------------------------------------
//     Copyright (c) 2017 Huawei Technologies Co., Ltd. All Rights Reserved.
//
//     This program is free software; you can redistribute it and/or modify
//     it under the terms of the Huawei Software License (the "License").
//     A copy of the License is located in the "LICENSE" file accompanying 
//     this file.
//
//     This program is distributed in the hope that it will be useful,
//     but WITHOUT ANY WARRANTY; without even the implied warranty of
//     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
//     Huawei Software License for more details. 
//------------------------------------------------------------------------------

`resetall

`resetall
`timescale    1ns / 1ns

module rr4
   #(
        parameter       REQ_W                   = 4       ,      
        parameter       RR_NUM_W                = 2                                       
    )  
    (
        input                                   reset      ,
        input                                   clks       ,
        
        input          [REQ_W-1:0]              req        ,
        input                                   req_vld    ,
        output  reg    [RR_NUM_W-1:0]           rr_bit     

    );
    
//======================================================================================================================
//signal
//======================================================================================================================

reg     [REQ_W-1:0]                             shift_req  ;
reg     [RR_NUM_W-1:0]                          bit_offset ;
    
//======================================================================================================================
//process
//======================================================================================================================

always @ ( * ) 
begin
    case ( rr_bit )
        2'd0  : shift_req = {req[0   ],req[3:1 ]};
        2'd1  : shift_req = {req[1 :0],req[3:2 ]};
        2'd2  : shift_req = {req[2 :0],req[3  ]};
        default : shift_req = req ;
    endcase
end

always @ ( * ) 
begin
    casex ( shift_req )
        4'b???1      : bit_offset = 2'd1 ;
        4'b??10      : bit_offset = 2'd2 ;
        4'b?100      : bit_offset = 2'd3 ;
        default      : bit_offset = 2'd0 ;
    endcase
end

always @(posedge clks or posedge reset)
begin
    if (reset == 1'b1) begin
        rr_bit <= {RR_NUM_W{1'b0}};
    end
    else if ( req_vld == 1'b1 )begin
        rr_bit <= bit_offset + rr_bit;
    end
    else ;
end


endmodule
