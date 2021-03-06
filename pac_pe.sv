`timescale 1ns/1ps
//NOTE: you need to compile SystemVerilogCSP.sv as well
import SystemVerilogCSP::*;

module pac_pe (interface i, interface o); 
       parameter WIDTH = 32;
       parameter FL = 2;
       parameter BL = 1;
       parameter addr = 3'b001;
       parameter dest = 3'b100;
       logic [WIDTH-1:0] datai = 0;
       logic [WIDTH-1:0] datao = 0;
       always begin
         i.Receive(datai);
         #FL;
         datao [7:0] = datai [7:0];
         datao [26:24] = dest;
         datao [29:27] = addr;
         o.Send(datao);
         #BL;
       end 


endmodule
