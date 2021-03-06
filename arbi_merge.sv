`timescale 1ns/1fs
//NOTE: you need to compile SystemVerilogCSP.sv as well
import SystemVerilogCSP::*;

module arbi_merge(interface A, interface B, interface C);
parameter WIDTH = 32;
parameter FL = 2;
parameter BL = 1;
logic winner;
logic [WIDTH-1:0] data1, data2;

always begin
   wait (A.status != idle || B.status != idle);

   if (A.status != idle && B.status != idle) begin
       winner = ($urandom%2==0) ? 0:1;
   end else if (A.status != idle) begin
       winner = 0;
   end else begin
       winner = 1;
   end
   
   if (winner==0) begin
      A.Receive(data1);
      #FL;
      C.Send(data1);
   end else begin
      B.Receive(data2);
      #FL;
      C.Send(data2);
   end
end
endmodule

