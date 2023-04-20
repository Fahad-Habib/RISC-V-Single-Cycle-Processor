module DataMemory(input logic [31:0] addr, wdata, input logic [2:0] mask, input logic wr_en, rd_en, clk,
				  output logic [31:0] rdata);
	logic [31:0] memory [1023:0];		// 1 KB Memory size
	logic [31:0] data, write_data;

	always_comb begin
		if (rd_en)
			data <= memory[addr[31:2]];
		else
			data <= 0;
	end

	always_comb begin
		if (rd_en) begin		// Load instruction
			case (mask)
				3'b000: begin	// Load byte (Signed)
					case (addr[1:0])
						0: rdata <= {{24{data[7]}}, data[7:0]};
						1: rdata <= {{24{data[15]}}, data[15:8]};
						2: rdata <= {{24{data[23]}}, data[23:16]};
						3: rdata <= {{24{data[31]}}, data[31:24]};
						default rdata <= 0;
					endcase
				end
				3'b001: begin	// Load halfword (Signed)
					case (addr[1])
						0: rdata <= {{16{data[15]}}, data[15:0]};
						1: rdata <= {{16{data[31]}}, data[31:16]};
						default rdata <= 0;
					endcase
				end
				3'b010: begin	// Load word
					rdata <= data;
				end
				3'b100: begin	// Load byte (Unsigned)
					case (addr[1:0])
						0: rdata <= {24'b0, data[7:0]};
						1: rdata <= {24'b0, data[15:8]};
						2: rdata <= {24'b0, data[23:16]};
						3: rdata <= {24'b0, data[31:24]};
						default rdata <= 0;
					endcase
				end
				3'b101: begin	// Load halfword (Unsigned)
					case (addr[1])
						0: rdata <= {16'b0, data[15:0]};
						1: rdata <= {16'b0, data[31:16]};
						default rdata <= 0;
					endcase
				end
				default: rdata <= 0;
			endcase
		end
	end
		
	always_comb begin
		if (wr_en) begin		// S-type instruction
			case (mask)
				3'b000: begin	// Store byte
					case (addr[1:0])
						0: write_data <= {24'b0, wdata[7:0]};
						1: write_data <= {24'b0, wdata[15:8]};
						2: write_data <= {24'b0, wdata[23:16]};
						3: write_data <= {24'b0, wdata[31:24]};
						default ;
					endcase
				end
				3'b001: begin	// Store halfword
					case (addr[1])
						0: write_data <= {16'b0, wdata[15:0]};
						1: write_data <= {16'b0, wdata[31:16]};
						default ;
					endcase
				end
				3'b010: begin	// Store word
					write_data <= wdata;
				end
			endcase
		end
	end
	
	always_ff @(negedge clk) begin
		if (wr_en) begin
			memory[addr[31:2]] <= write_data;
		end
	end
endmodule
