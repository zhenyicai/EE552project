`timescale 1ns/1ps
//NOTE: you need to compile SystemVerilogCSP.sv as well
import SystemVerilogCSP::*;


module data_generator2(interface R);
  parameter totalcycles = 1000;
  parameter WIDTH = 26;
  parameter FL = 1;
  parameter data1 = 17696008;
  parameter data2 = 5;
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

module data_bucket(interface L);
  parameter WIDTH = 8;
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


module function_unit (interface d, interface s);
    parameter FL = 2;
    parameter BL = 2;
    logic [7:0] psum = 0;
    logic [25:0] data = 0;
    logic [23:0] filterdata = 0;
    logic [23:0] ifmapdata = 0;
    logic [1:0] j = 2'b00;//counter
    always
    begin
      d.Receive(data);
      if (data[25] == 1) begin
          ifmapdata = 0;
          filterdata = 0;
          j = 0;
      end
      else begin
      if (data[24] == 1) begin
          filterdata = data [23:0];
          j [1] = 1;
      end
      else begin
          ifmapdata = data [23:0];
          j [0] = 1;
      end
      #FL
      if (j == 2'b11) begin
          psum[7:0] = ifmapdata[16]*filterdata[23:16]+ifmapdata[8]*filterdata[15:8]+ifmapdata[0]*filterdata[7:0];
          j [0] = 0;
          //psum[17:15] = 3'b100;
          //psum[14:12] = data[26:24];
          s.Send(psum);
          #BL;
      end
      end
    end

endmodule


module function_unit_tb();
  
  

  Channel #(.hsProtocol(P2PhaseBD),.WIDTH(26)) intf  [1:0] (); 

  data_generator2 #(.data1(17696008), .data2(5))  dg1(.R(intf[0])); 
  function_unit #(.FL(2), .BL(1)) fu1(.d(intf[0]),.s(intf[1]));
  data_bucket #(.WIDTH(26), .BL(0)) db1(.L(intf[1]));
  initial 
     #20 $stop;

endmodule