`timescale 1ns/1ps
//NOTE: you need to compile SystemVerilogCSP.sv as well
import SystemVerilogCSP::*;

module sum_unit(interface i, interface o); // input and output interface
  parameter WIDTH = 8;
  parameter FL = 2;
  parameter BL = 1;
  parameter FT = 9; //first ifmap, without mempot
  parameter vt = 64; // threshold voltage
  logic [WIDTH+1:0] data;
  logic [WIDTH-1:0] psmem, ps1, ps2, ps3; // 4 memory blocks for partial sum from PE1, PE2, PE3 and memory
  logic [WIDTH:0] outputsum; // 9 bit, 1 bit output spike, 8 bit output membrane potential
  logic [4:0] k = 5'b00000; // flag for partial sum received
  int j = 0; //counter for adding times
  always 
  begin
    if (k == 5'b00000) begin
        psmem = 0;
        ps1 = 0;
        ps2 = 0;
        ps3 = 0; // initializing
    end
    k[4] = 1;
    if (j < 9) begin
        k[0] = 1;
        psmem = 0;
    end
    //else begin

    //end 
    i.Receive(data); 
    //$display ("###### \n data %d received, value = %d \n #######", j, data);  
    #FL;
    case(data[WIDTH+1:WIDTH])
        2'b00: begin
               psmem = data [WIDTH-1:0];
               k[0] = 1;
               end
        2'b01: begin
               ps1 = data [WIDTH-1:0];
               k[1] = 1;
               end
        2'b10: begin
               ps2 = data [WIDTH-1:0];
               k[2] = 1;
               end
        2'b11: begin
               ps3 = data [WIDTH-1:0];
               k[3] = 1;
               end
        default: begin
               psmem = data [WIDTH-1:0];
               k[0] = 1;
               end
    endcase
    if (k[3:0] == 4'b1111) begin
        outputsum = psmem + ps1 + ps2 + ps3;
        k[3:0] = 4'b0000;
        if  (outputsum >= vt) begin
            outputsum = outputsum - vt;
            outputsum[WIDTH] = 1;
            $display("******\n outputsum = %d \n *******", outputsum);
        end
        //outputsum[10:9] = j%3;
        //outputsum[12:11] = j/3;
        o.Send(outputsum);
        j = j+1;
        #BL;
    end 
  end
endmodule