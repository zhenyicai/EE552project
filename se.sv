`timescale 1ns/1ps
import SystemVerilogCSP::*;

module se(interface toNOC, interface fromNOC);
       Channel #(.hsProtocol(P2PhaseBD),.WIDTH(32)) intf [1:0] ();

       depac_sum depac2(fromNOC, intf[0]);
       sum_unit su1(intf[0], intf[1]);
       pac_sum pac2(intf[1],toNOC);

endmodule
