module WriteBack(input logic [31:0] A, B, C, input logic [1:0] wb_sel,
				 output logic [31:0] wdata);
	always_comb begin
		case (wb_sel)
			0: wdata <= A;
			1: wdata <= B;
			2: wdata <= C;
		endcase
	end
endmodule
