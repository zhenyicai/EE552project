`timescale 1ns/1ps
import SystemVerilogCSP::*;

module processing_unit(interface toNOC, interface fromNOC);
       Channel #(.hsProtocol(P2PhaseBD),.WIDTH(32)) intf [1:0] ();
       parameter address = 3'b001;

       depac_pe depac1(fromNOC, intf[0]);
       function_unit fu1(intf[0], intf[1]);
       pac_pe #(.addr(address))  pac1(intf[1],toNOC);

endmodule
