module Controller(input logic [31:0] instruction,
				  output logic [3:0] alu_op, output logic [2:0] mask, br_type, output logic reg_wr, sel_A, sel_B, rd_en, wr_en, output logic [1:0] wb_sel);
	logic [2:0] func3;
	logic [6:0] func7;
	logic [6:0] opcode;
	
	always_comb begin
		func3 <= instruction[14:12];
		func7 <= instruction[31:25];
		opcode <= instruction[6:0];
	end

    always_comb begin
    	case (opcode)
    		7'b0110011: begin	// R-type instructions
    			reg_wr <= 1;
    			sel_A <= 1;
    			sel_B <= 0;
    			rd_en <= 0;
    			wb_sel <= 0;
				case (func3)
					3'b000: begin if (func7 == 7'b0100000) alu_op <= 9; else alu_op <= 0; end
					3'b001:	alu_op <= 1;
					3'b010:	alu_op <= 2;
					3'b011:	alu_op <= 3;
					3'b100:	alu_op <= 4;
					3'b101: begin if (func7 == 7'b0100000) alu_op <= 6; else alu_op <= 5; end
					3'b110:	alu_op <= 7;
					3'b111:	alu_op <= 8;
				endcase
			end
			7'b0010011: begin	// I-type instructions
    			reg_wr <= 1;
    			sel_A <= 1;
    			sel_B <= 1;
    			rd_en <= 0;
    			wb_sel <= 0;
				case (func3)
					3'b000: alu_op <= 0;
					3'b001:	alu_op <= 1;
					3'b010:	alu_op <= 2;
					3'b011:	alu_op <= 3;
					3'b100:	alu_op <= 4;
					3'b101: begin if (func7 == 7'b0100000) alu_op <= 6; else alu_op <= 5; end
					3'b110:	alu_op <= 7;
					3'b111:	alu_op <= 8;
				endcase
			end
			7'b0000011: begin	// Load instructions
    			reg_wr <= 1;
    			sel_A <= 1;
    			sel_B <= 1;
    			rd_en <= 1;
    			wr_en <= 0;
    			wb_sel <= 1;
    			alu_op <= 0;
    			mask <= func3;
			end
			7'b0100011: begin	// S-type instructions
    			reg_wr <= 0;
    			sel_A <= 1;
    			sel_B <= 1;
    			rd_en <= 0;
    			wr_en <= 1;
    			wb_sel <= 1;
    			alu_op <= 0;
    			mask <= func3;
			end			
			7'b1100011: begin	// B-type instructions
    			reg_wr <= 0;
    			sel_A <= 0;
    			sel_B <= 1;
    			rd_en <= 0;
    			wr_en <= 0;
    			wb_sel <= 0;
    			alu_op <= 0;
    			br_type <= func3;
			end			
			7'b0110111: begin	// U-type instructions
    			reg_wr <= 1;
    			sel_A <= 1;
    			sel_B <= 1;
    			rd_en <= 0;
    			wr_en <= 0;
    			wb_sel <= 0;
    			alu_op <= 0;
    		end
			7'b1101111: begin	// J-type instructions
    			reg_wr <= 1;
    			sel_A <= 0;
    			sel_B <= 1;
    			rd_en <= 0;
    			wr_en <= 0;
    			wb_sel <= 2;
    			alu_op <= 0;
    		end
		endcase
	end
endmodule
