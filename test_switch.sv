`timescale 1ns/1fs
//NOTE: you need to compile SystemVerilogCSP.sv as well
import SystemVerilogCSP::*;

module test_switch();

  Channel #(.hsProtocol(P2PhaseBD),.WIDTH(32)) intf  [2:0] ();
  DGG  dg1(.R(intf[0]));
  switch #(.mask(6),.address(0),.P(0)) S1(.A(intf[0]),.B(intf[1]),.C(intf[2]));
  data_bucket1 DB1(intf[1]);
  data_bucket1 DB2(intf[2]);
  initial #20 $stop;
endmodule
