`timescale 1ns / 1ps
//DBSCAN magnitude module

module DBSCAN_ABS(input[9:0] in0,input clk,input reset,input start,input final,output [9:0] out0);

reg[9:0] newval,oldval,pointcount,clustercount;   //Declare registers
wire[9:0] diff;   //Difference between 2 current values
parameter e = 0;  //Epsilon value (value equals x*2^-8, eg 1 = 0.00390625)
parameter m = 1;  //minpts value, set to 1 below traditional minpts value
reg [9:0] outreg;   //Output reg
assign diff=newval-oldval;
assign out0=outreg;    //Output wire



//Main DBSCAN operation logic
always@(posedge clk) begin
oldval<=newval;     //Move most recently loaded value to second register
newval<=in0;        //Load new value from SR_chain
if (reset==1) begin
newval<=0;
oldval<=0;              //Resets
pointcount<=0;
clustercount <=0;
end
//If final control signal declared and pointcount greater than minpts then output current clustercount+1
else if ((pointcount>=m)&&(final==1)) begin
outreg<=clustercount+1;
clustercount <=0;
pointcount<=0;
end
//If final control signal declared and pointcount is not greater than minpts then output current clustercount
else if ((pointcount<m)&&(final==1)) begin
outreg<=clustercount;
clustercount <=0;
pointcount<=0;
end
//If difference value less than epsilon increment pointcount
else if ((diff<=e)&&(start==1)) begin
pointcount = pointcount +1;
end
//Difference value being greater than epsilon is implicit, if pointcount greater than minpts incremement clustercount
else if ((pointcount>=m)&&(start==1))begin
clustercount =clustercount+1;
pointcount<=0;
end
end




endmodule
