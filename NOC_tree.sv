`timescale 1ns/1ps
import SystemVerilogCSP::*;

module NOC_tree(interface fromMem, interface toMem, interface fromPE1, interface toPE1, interface fromPE2, interface toPE2, interface fromPE3, interface toPE3, interface fromAdd, interface toAdd);

    Channel #(.hsProtocol(P2PhaseBD),.WIDTH(32)) intf [7:0] ();

    router #(.address(000), .mask(110)) R1(fromMem, fromPE1, intf[1], toMem, toPE1, intf[0]);
    router #(.address(010), .mask(110)) R2(fromPE2, fromPE3, intf[3], toPE2, toPE3, intf[2]);
    router #(.address(000), .mask(100)) R3(intf[0], intf[2], intf[5], intf[1], intf[3], intf[4]);
    router #(.address(000), .mask(000)) R4(intf[4], fromAdd, intf[7], intf[5], toAdd, intf[6]);

endmodule


