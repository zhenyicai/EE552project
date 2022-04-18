`timescale 1ns/1fs
//NOTE: you need to compile SystemVerilogCSP.sv as well
import SystemVerilogCSP::*;


module depack (interface i, interface o);
    parameter FL = 2;
    parameter BL = 1;
    logic [31:0] data = 0;
    

endmodule