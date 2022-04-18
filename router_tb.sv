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

   arbi_merge a1(.A(intf[2]), .B(intf[4]), .C(C1_out));
   arbi_merge a2(intf[0], intf[5], C2_out);
   arbi_merge a3(intf[1], intf[3], P_out);
   
endmodule

module DGG(interface R);
  parameter totalcycles = 1000;
  parameter WIDTH = 32;
  parameter FL = 1;
  parameter data1 = 32'b00000001000000000000000000001001;
  parameter data2 = 32'b00000010000000000000000000001100;
  parameter data3 = 32'b00000011000000000000000000001111;
  logic [WIDTH-1:0] token;
  int i = 0;
  always begin 
    /*if (i >= totalcycles) begin 
      $display("Data Generator sent %d tokens.",totalcycles);
      break;
    end
    else begin*/
      if (i%3 == 0) begin
      token = data1;//$random() % (2**WIDTH);
      end
      else if (i%3 == 1) begin
      token = data2;
      end
      else begin
      token = data3;
      end
      #FL;
// 2. TODO place here the correct interface task for a data_generator
      R.Send(token);
      i = i + 1;
      //tindex.Send(i);
    //end
  end
endmodule

module data_bucket1(interface L);
  parameter WIDTH = 32;
  parameter BL = 0;
  logic [WIDTH-1:0] token = 0;
  //int i=0;
 always begin
// 3. TODO place the correct interface task for a data_bucket
   L.Receive(token);
   //i = i + 1;
   //tindex.Send(i);
   #BL;
 end
endmodule

module router_tb();

  Channel #(.hsProtocol(P2PhaseBD),.WIDTH(32)) intf[5:0] ();
  DGG DG1(intf[2]);

  router #(.address(3'b010), .mask(3'b110)) R1(intf[0], intf[1],intf[2],intf[3],intf[4],intf[5]);

  data_bucket1 DB1(intf[1]);
  data_bucket1 DB2(intf[0]);
  data_bucket1 DB3(intf[3]);
  data_bucket1 DB4(intf[4]);
  data_bucket1 DB5(intf[5]);
initial begin
  #50 $stop;
end
endmodule

/*module router_tb();
parameter WIDTH = 32;
Channel #(.hsProtocol(P2PhaseBD),.WIDTH(32)) intf[11:0] ();
  DGG DG1(intf[6]);


    parameter [2:0] address = 0;
    parameter [2:0] mask =  3'b110;
 
   switch #(.P(0),.address(address), .mask(mask)) sw1(intf[6], intf[0], intf[1]);
   switch #(.P(0),.address(address), .mask(mask)) sw2(intf[7], intf[2], intf[3]);
   switch #(.P(1),.address(address), .mask(mask)) sw3(intf[8], intf[4], intf[5]);

   arbi_merge a1(intf[3], intf[4], intf[9]);
   arbi_merge a2(intf[1], intf[5], intf[10]);
   arbi_merge a3(intf[0], intf[2], intf[11]);

  data_bucket1 DB1(intf[7]);
  data_bucket1 DB2(intf[8]);
  data_bucket1 DB3(intf[9]);
  data_bucket1 DB4(intf[10]);
  data_bucket1 DB5(intf[11]);
initial begin
  #50 $stop;
end

endmodule*/
