`timescale 1ns/1ps
import SystemVerilogCSP::*;

module sample_memory_wrapper(Channel toMemRead, Channel toMemWrite, Channel toMemT,
			Channel toMemX, Channel toMemY, Channel toMemSendData, Channel fromMemGetData, Channel toNOC, Channel fromNOC); 

parameter mem_delay = 15;
parameter simulating_processing_delay = 30;
parameter timesteps = 10;
parameter WIDTH = 8;
  Channel #(.hsProtocol(P4PhaseBD)) intf[9:0] (); 
  int num_filts_x = 3;
  int num_filts_y = 3;
  int ofx = 3;
  int ofy = 3;
  int ifx = 5;
  int ify = 5;
  int ift = 10;
  int i,j,k,t;
  int read_filts = 2;
  int read_ifmaps = 1; // write_ofmaps = 1 as well...
  int read_mempots = 0;
  int write_ofmaps = 1;
  int write_mempots = 0;
  logic [WIDTH-1:0] byteval;
  logic spikeval;

  // my modification
  logic [WIDTH*4-1:0] filterval = 0;
  logic [WIDTH*4-1:0] ifmapval = 0;
  logic [WIDTH*4-1:0] oldmemval;
  logic [WIDTH-1:0] mempotval;
  logic [WIDTH*4-1:0] ofmapval;
  int j1,i1,j2;
  int i3,j3;
  //
  
// Weight stationary design
// TO DO: modify for your dataflow - can read an entire row (or write one) before #mem_delay
// TO DO: decide whether each Send(*)/Receive(*) is correct, or just a placeholder
  initial begin
	for (int i = 0; i < num_filts_x; i++) begin
		for (int j = 0; j < num_filts_y; ++j) begin
			$display("%m Requesting filter [%d][%d] at time %d",i,j,$time);
			toMemRead.Send(read_filts);
			toMemX.Send(i);
			toMemY.Send(j);
			fromMemGetData.Receive(byteval);
                        if (j == 0) begin
                            filterval[7:0] = byteval;
                        end
                        else if (j ==1) begin
                            filterval[15:8] = byteval;
                        end
                        else begin
                            filterval[23:16] = byteval;
                        end
			#mem_delay;
			$display("%m Received filter[%d][%d] = %d at time %d",i,j,byteval,$time);
		end
            filterval[31:27] = 5'b01000;
            filterval[26:24] = i+1;
            toNOC.Send(filterval);
            $display("%m Send filterval = %d,%d,%d for PE%d",filterval[23:16],filterval[15:8],filterval[7:0],i+1);
	end
   $display("%m Received all filters at time %d", $time);
    for (int t = 1; t <= timesteps; t++) begin
	$display("%m beginning timestep t = %d at time = %d",t,$time);
		// get the new ifmaps
        for (int i1 = 0; i1 < ifx - 2; i1++) begin
             for (int j1 = 0; j1 < ify - 2; ++j1) begin
		for (int i = 0; i < num_filts_x; i++) begin
			for (int j = 0; j < num_filts_y; ++j) begin
				// TO DO: read old membrane potential (hint: you can't do it here...)
				$display("%m requesting ifm[%d][%d]",i,j);
				// request the input spikes
				toMemRead.Send(read_ifmaps);
				toMemX.Send(i+i1);
				toMemY.Send(j+j1);
				fromMemGetData.Receive(spikeval);
                                if (j == 0) begin
                                    ifmapval[0] = spikeval;
                                end
                                else if (j ==1) begin
                                    ifmapval[8] = spikeval;
                                end
                                else begin
                                    ifmapval[16] = spikeval;
                                end
				#mem_delay; // wait for them to arrive
				$display("%m received ifm[%d][%d] = %b",i+i1,j+j1,spikeval);				
				// do processing (delete this line)
				#simulating_processing_delay;

			end // ify
                        ifmapval[31:27] = 5'b00000;
                        ifmapval[26:24] = i+1;
                        toNOC.Send(ifmapval);
		end // ifx
                if (t > 1) begin
                    toMemRead.Send(read_mempots);
		    toMemX.Send(i1);
		    toMemY.Send(j1);
		    fromMemGetData.Receive(mempotval);
                    $display("%m received oldmempot[%d][%d] = %b",i1,j1,mempotval);	
                    oldmemval[31:24] = 8'b00000100;
                    oldmemval[23:8] = 16'b0;
                    oldmemval[7:0] = mempotval;
                    toNOC.Send(oldmemval);
                    #25;
                end
             end // j1
         end // i1
	$display("%m received all ifmaps for timestep t = %d at time = %d",t,$time);
	// membrane potential?

        //
		// write back membrane potentials & spikes
		// TO DO: you need to get them from the NoC first!
                
		for (int i = 0; i < ofx; i++) begin
			for (int j = 0; j < ofy; j++) begin	
                             	fromNOC.Receive(ofmapval);
				toMemWrite.Send(write_mempots);
				toMemX.Send(i);
				toMemY.Send(j);
				toMemSendData.Send(ofmapval[7:0]);
				#25;
				toMemWrite.Send(write_ofmaps);
				toMemX.Send(i);
				toMemY.Send(j);				
				toMemSendData.Send(ofmapval[8]);
                                #25;
                            
			end // ofy 
		end // ofx
		$display("%m sent all output spikes and stored membrane potentials for timestep t = %d at time = %d",t,$time);
		toMemT.Send(t);
		$display("%m send request to advance to next timestep at time t = %d",$time);
	end // t = timesteps
	$display("%m done");
	#mem_delay; // let memory display comparison of golden vs your outputs
	$stop;
  end
  
  always begin
	#200;
	$display("%m working still...");
  end
  
endmodule