`timescale 1ns/1ps
//NOTE: you need to compile SystemVerilogCSP.sv as well
import SystemVerilogCSP::*;

module pe_tb();
  Channel #(.hsProtocol(P2PhaseBD),.WIDTH(32)) intf  [1:0] (); 
  DG4 dg41(intf[0]);
  processing_unit #(.address(3'b001)) pe1(intf[1],intf[0]);
  data_bucket1 db1(intf[1]);

initial begin
  #50 $stop;
end

endmodule

module DG4(interface R);
  parameter totalcycles = 1000;
  parameter WIDTH = 32;
  parameter FL = 1;
  parameter data1 = 32'b01000001000010000000010100001110;
  parameter data2 = 32'b00000001000000010000000100000001;
  logic [WIDTH-1:0] token;
  int i = 0;
  always begin 
    /*if (i >= totalcycles) begin 
      $display("Data Generator sent %d tokens.",totalcycles);
      break;
    end
    else begin*/
      if (i == 0) begin
      token = data1;//$random() % (2**WIDTH);
      end
      else begin
      token = data2;
      end
      #FL;
// 2. TODO place here the correct interface task for a data_generator
      R.Send(token);
      i = i + 1;
      //tindex.Send(i);
    //end
  end
endmodule