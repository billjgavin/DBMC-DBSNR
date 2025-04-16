`timescale 1ns / 1ps

(* KEEP = "true" *)
(* DONT_TOUCH = "true" *)

//Individual components of sorting unit, generated in SR_chain

module SR_full(input[9:0] new, input [9:0] above, input clk, input reset,input [1:0] load,input abvctrl, output cmp, output [9:0] down

    );
wire[9:0] curval;       //Currently input value
wire cmp;   //Comparison result
SR_N SR_N0(new,above,cmp,clk,reset,load,abvctrl,curval);    //SR registers
comparator c0(new,curval,cmp);      //Attatched comparators

assign down=curval;     //Below SR receives comparison result
endmodule