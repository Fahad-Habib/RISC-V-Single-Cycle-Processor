module ImmediateGenerator(input logic clk, input logic [31:0] instruction,
						  output logic [31:0] imm_out);
	always_comb begin
		case (instruction[6:0])
			7'b0010011: begin	// I-type instructions
				case (instruction[14:12])
					3'b001, 3'b101: imm_out <= $signed(instruction[24:20]);
					default: imm_out <= $signed(instruction[31:20]);
				endcase
			end
			7'b0000011: begin	// Load instructions
				imm_out <= instruction[31:20];
			end
			7'b0100011: begin	// S-type instructions
				imm_out <= {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};
			end
			7'b1100011: begin	// B-type instructions
				imm_out <= {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};
			end
			7'b0110111: begin	// U-type instructions
				imm_out <= {instruction[31:12], 12'b0};
			end
			7'b1101111: begin	// J-type instructions
				imm_out <= {{12{instruction[31]}}, instruction[19:12], instruction[20], instruction[30:21], 1'b0};
			end
		endcase
	end
endmodule
