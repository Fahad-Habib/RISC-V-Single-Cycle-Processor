`timescale 1ns / 1ps

module Processor_TB;
	logic clk, reset;
	Processor UUT (clk, reset);
	initial
		begin
			clk = 1;
			forever #1 clk = ~clk;
		end
	initial
		begin
			reset = 1;
			#2;
			reset = 0;
			#400
			$stop;
		end
endmodule
