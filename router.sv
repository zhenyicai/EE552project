`timescale 1ns/1fs
//NOTE: you need to compile SystemVerilogCSP.sv as well
import SystemVerilogCSP::*;

module router(interface C1_in, interface C2_in, interface P_in, interface C1_out, interface C2_out, interface P_out);

    Channel #(.hsProtocol(P2PhaseBD),.WIDTH(32)) intf [5:0] ();
    parameter WIDTH = 32;
    parameter [2:0] address = 0;
    parameter [2:0] mask =  0;
 
   switch #(.P(0),.address(address), .mask(mask)) sw1(C1_in, intf[0], intf[1]);
   switch #(.P(0),.address(address), .mask(mask)) sw2(C2_in, intf[2], intf[3]);
   switch #(.P(1),.address(address), .mask(mask)) sw3(P_in, intf[4], intf[5]);

   arbi_merge a1(intf[3], intf[4], C1_out);
   arbi_merge a2(intf[1], intf[5], C2_out);
   arbi_merge a3(intf[0], intf[2], P_out);
   
endmodule
  




    
   





