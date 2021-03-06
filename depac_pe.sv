`timescale 1ns/1ps
//NOTE: you need to compile SystemVerilogCSP.sv as well
import SystemVerilogCSP::*;

module depac_pe (interface i, interface o); // i is input channel from NOC, o is output channel to funxtion unit
       parameter WIDTH = 32;
       parameter FL = 2;
       parameter BL = 1;
       parameter OUTPUTWIDTH = 26;//width of output data
       logic [WIDTH-1:0] datai;
       logic [OUTPUTWIDTH-1:0] datao;
       always begin
	 i.Receive(datai);
         #FL;
         datao [23:0] = datai [23:0];
         datao [25:24] = datai [31:30];
         o.Send(datao);
         #BL;
       end
endmodule