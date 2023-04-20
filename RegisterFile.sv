module RegisterFile(input logic clk, reset, reg_wr, input logic [4:0] raddr1, raddr2, waddr, input logic [31:0] wdata,
                    output logic [31:0] rdata1, rdata2);
    logic [31:0] registerfile [31:0];

    always @(posedge clk) begin
    	if (reset) begin
		    registerfile[0] <= 0;
    	end
    end

    always_comb begin
    	rdata1 <= registerfile[raddr1];
    	rdata2 <= registerfile[raddr2];
    end

    always @(negedge clk) begin
        if (reg_wr & (waddr != 0)) registerfile[waddr] <= wdata;
    end
endmodule
