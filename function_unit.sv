`timescale 1ns/1fs
//NOTE: you need to compile SystemVerilogCSP.sv as well
import SystemVerilogCSP::*;

module function_unit (interface d, interface s);
    parameter FL = 2;
    parameter BL = 1;
    logic [11:0] psum = 0;
    logic [25:0] data = 0;
    logic [23:0] filterdata = 0;
    logic [7:0] ifmapdata = 0;
    int i = 0;
    always
    begin
      d.Receive(data);
      if (data[25] == 0) begin
          ifmapdata = 0;
          filterdata = 0;
          i = 0;
      end
      else begin
      if (data[24] == 1) begin
          filterdata = data [23:0];
          i = i + 1;
      end
      else begin
          ifmapdata = data [7:0];
          i = i + 2;
      end
      #FL
      if (i == 3) begin
          psum[11:0] = ifmapdata[2]*filterdata[23:16]+ifmapdata[1]*filterdata[15:8]+ifmapdata[0]*filterdata[7:0];
          i = 1;
          //psum[17:15] = 3'b100;
          //psum[14:12] = data[26:24];
          s.Send(psum);
          #BL;
      end
      end
    end

endmodule