`timescale 1ns/1fs
//NOTE: you need to compile SystemVerilogCSP.sv as well
import SystemVerilogCSP::*;


module DG(interface R);
  parameter totalcycles = 1000;
  parameter WIDTH = 26;
  parameter FL = 1;
  parameter data = 5;
  logic [WIDTH-1:0] token;
  int i = 0;
  always begin 
      token = data;
      #FL;
// 2. TODO place here the correct interface task for a data_generator
      R.Send(token);
      i = i + 1;
      //tindex.Send(i);
    //end
  end
endmodule

module test_ABM();
     
    Channel #(.hsProtocol(P2PhaseBD),.WIDTH(32)) intf  [2:0] ();
    DG #(.data(50), .FL(0))  dg1(.R(intf[0]));
    DG #(.data(20), .FL(0))  dg2(.R(intf[1])); 
    arbi_merge ABM1(.A(intf[0]),.B(intf[1]),.C(intf[2]));
    data_bucket #(.WIDTH(32), .BL(0)) db1(.L(intf[2]));
    initial 
      #20 $stop;
endmodule
     
     
