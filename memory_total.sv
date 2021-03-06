`timescale 1ns/1ps
import SystemVerilogCSP::*;

module memory_total(); 

  Channel #(.hsProtocol(P2PhaseBD),.WIDTH(32)) intf[9:0] (); 

  memory mem_DUT (.read(intf[1]), .write(intf[2]), .T(intf[3]), 
		.x(intf[4]), .y(intf[5]), .data_in(intf[6]), .data_out(intf[7]));

  
  sample_memory_wrapper smw_DUT (.toMemRead(intf[1]), .toMemWrite(intf[2]), .toMemT(intf[3]), 
	.toMemX(intf[4]), .toMemY(intf[5]), .toMemSendData(intf[6]), .fromMemGetData(intf[7]), 
	.toNOC(intf[8]), .fromNOC(intf[9]));  
		
  NOC_tree_total noc_DUT(.fromMem(intf[8]), .toMem(intf[9]));

  int i, j, k;
  
initial begin 
    #15000;			

	$stop;

  end // initial block
endmodule

module NOC_tree_total(interface fromMem, interface toMem);

    Channel #(.hsProtocol(P2PhaseBD),.WIDTH(32)) intf [9:0] ();
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

    NOC_tree noc1(fromMem,toMem,intf[2],intf[3],intf[4],intf[5],intf[6],intf[7],intf[8],intf[9]);


endmodule
