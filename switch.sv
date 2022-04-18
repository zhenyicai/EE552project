`timescale 1ns/1fs
//NOTE: you need to compile SystemVerilogCSP.sv as well
import SystemVerilogCSP::*;

module switch(interface A, interface B, interface C);
  parameter WIDTH =32;
  parameter FL=2;
  parameter BL=1;
  parameter P =1;
  parameter [2:0] address = 0;
  parameter [2:0] mask =  0;
  logic winner;
  logic [WIDTH-1:0]  data;
  logic [2:0] result;
  
  always  begin
  A.Receive(data);
  #FL;
  if (P ==1)  begin // parent side input
    case (mask)
    3'b000: if (data[26] == 0) winner = 0;//child 1
            else winner = 1;//child 2
    3'b100: if (data[25] == 0) winner = 0;//child 1
            else winner = 1;//child 2
    3'b110: if (data[24] == 0) winner = 0;//child 1
            else winner = 1;//child 2
    default: if (data[26] == 0) winner = 0;//child 1
            else winner = 1;//child 2
    endcase
  end
  else begin // child side input
  result = data[26:24] & mask;
    if (result == address) begin 
        winner = 0; 
        //$display( "dest = %d, mask = %d, addr = %d, result = %d, winner = child",data[26:24],mask,address,result);
    end// child
    else begin
    winner = 1; //parent
    //$display( "dest = %d, mask = %d, addr = %d, result = %d, winner = parent",data[26:24],mask,address,result);
    end
  end
  if (winner == 0) B.Send(data);
  else C.Send(data);
  #BL; 
  end
endmodule


  
