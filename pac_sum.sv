`timescale 1ns/1ps
import SystemVerilogCSP::*;

module pac_sum(interface i, interface o);
       parameter WIDTH = 32;
       parameter FL = 2;
       parameter BL = 1;
       parameter addr = 3'b100;
       parameter dest = 3'b000;
       logic [WIDTH-1:0] datai = 0;
       logic [WIDTH-1:0] datao = 0;
       always begin
         i.Receive(datai);
         $display("******\n datai = %d \n *******", datai);
         #FL;
         datao [8:0] = datai;
         datao [26:24] = dest;
         datao [29:27] = addr;
         $display("******\n outputsum = %d \n *******", datao[8:0]);
         o.Send(datao);
         #BL;
       end 


endmodule
