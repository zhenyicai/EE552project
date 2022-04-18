`timescale 1ns/1ps
import SystemVerilogCSP::*;

module NOC_tree_tb();

    Channel #(.hsProtocol(P2PhaseBD),.WIDTH(32)) intf [9:0] ();
    DG3 dg31(intf[0]);
    data_bucket1 db1(intf[1]);
    processing_unit #(.address(3'b001)) pe1(intf[2],intf[3]);
    processing_unit #(.address(3'b010)) pe2(intf[4],intf[5]);
    processing_unit #(.address(3'b011)) pe3(intf[6],intf[7]);
    se se1(intf[8],intf[9]);
    /*DG2 #(.data1(32'b00001100000000000000000000000010),.FL(10)) dg2(intf[2]);
    DG2 #(.data1(32'b00010100000000000000000000000011),.FL(10)) dg3(intf[4]);
    DG2 #(.data1(32'b00011100000000000000000000000100),.FL(10)) dg4(intf[6]);
    DG2 #(.data1(32'b00100000000000000000000000000110),.FL(30)) dg5(intf[8]);
    data_bucket1 db1(intf[1]);
    data_bucket1 db2(intf[3]);
    data_bucket1 db3(intf[5]);
    data_bucket1 db4(intf[7]);
    data_bucket1 db5(intf[9]);*/

    NOC_tree noc1(intf[0],intf[1],intf[2],intf[3],intf[4],intf[5],intf[6],intf[7],intf[8],intf[9]);

initial begin
#100 $stop;
end


endmodule

module DG2(interface R);
  parameter totalcycles = 1000;
  parameter WIDTH = 32;
  parameter FL = 1;
  parameter data1 = 0;
  logic [WIDTH-1:0] token;
  always begin 
      token = data1;
// 2. TODO place here the correct interface task for a data_generator
      R.Send(token);
      #FL;
      //tindex.Send(i);
    //end
  end
endmodule


module DG1(interface R);
  parameter totalcycles = 1000;
  parameter WIDTH = 32;
  parameter FL = 1;
  parameter data1 = 32'b00000001000000000000000000001001;
  parameter data2 = 32'b00000010000000000000000000001100;
  parameter data3 = 32'b00000011000000000000000000001111;
  parameter data4 = 32'b00000100000000000000000000000111;
  logic [WIDTH-1:0] token;
  int i = 0;
  always begin 
    /*if (i >= totalcycles) begin 
      $display("Data Generator sent %d tokens.",totalcycles);
      break;
    end
    else begin*/
      if (i%4 == 0) begin
      token = data1;//$random() % (2**WIDTH);
      end
      else if (i%4 == 1) begin
      token = data2;
      end
      else if (i%4 == 2) begin
      token = data3;
      end
      else begin
      token = data4;
      end
      #FL;
// 2. TODO place here the correct interface task for a data_generator
      R.Send(token);
      i = i + 1;
      //tindex.Send(i);
    //end
  end
endmodule



module DG3(interface R);
  parameter totalcycles = 1000;
  parameter WIDTH = 32;
  parameter FL = 1;
  parameter data1 = 32'b00000001000000000000000100000001;
  parameter data2 = 32'b00000010000000010000000100000001;
  parameter data3 = 32'b00000011000000010000000100000000;
  parameter data4 = 32'b01000001000010000000010100001110;
  parameter data5 = 32'b01000010000001110000100000000100;
  parameter data6 = 32'b01000011000010100000100100001010;
  logic [WIDTH-1:0] token;
  int i = 0;
  int j = 0;
  int k = 0;
  always begin 
    if (j == 0) begin
        R.Send(data4); 
        #5; 
        R.Send(data5);
        #5; 
        R.Send(data6);
        j = 1;
    end
    else begin
    /*if (i >= totalcycles) begin 
      $display("Data Generator sent %d tokens.",totalcycles);
      break;
    end
    else begin*/
      if (i == 0) begin
      token = data1;//$random() % (2**WIDTH);
      R.Send(token);
      end
      else if (i == 1) begin
      token = data2;
      R.Send(token);
      end
      else if (i == 2) begin
      token = data3;
      R.Send(token);
      end
      else begin
      token = data1;
      end
      #FL;
// 2. TODO place here the correct interface task for a data_generator
      
      i = i + 1;
      //tindex.Send(i);
    //end
    end
  end
endmodule