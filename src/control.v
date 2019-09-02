// Module m_instruction_logic_unit parses instructions, comparison flag, and clock values
// to determine which flags should be set for proper operation of external mux/demux
// data selectors, register file, arithmetic logic unit, and data memory.

module m_instruction_logic_unit (w_jump_flag, w_data_mem_write_flag, w_store_word_flag, w_store_pc_flag, w_load_word_flag, w_write_back_flag, w_write_back_reg, w_bus_wordin, w_cf, w_clock);
	output w_jump_flag, w_data_mem_write_flag, w_store_word_flag, w_store_pc_flag, w_load_word_flag, w_write_back_flag;
	output [3:0]  w_write_back_reg;
	input w_cf, w_clock;
	input [7:0] w_bus_wordin;
	reg r_jump_flag, r_data_mem_write_flag, r_store_word_flag, r_store_pc_flag, r_load_word_flag, r_write_back_flag;
	reg [3:0] r_write_back_reg;


	assign w_jump_flag = r_jump_flag;
	assign w_data_mem_write_flag = r_data_mem_write_flag;
	assign w_store_word_flag = r_store_word_flag;
	assign w_store_pc_flag = r_store_pc_flag;
	assign w_load_word_flag = r_load_word_flag;
	assign w_write_back_flag = r_write_back_flag;
	assign w_write_back_reg[3:0] = r_write_back_reg[3:0];


	initial begin
		// set all flags and write back register to 0
		r_jump_flag <= 0;
		r_data_mem_write_flag <= 0;
		r_store_word_flag <= 0;
		r_store_pc_flag <= 0;
		r_load_word_flag <= 0;
		r_write_back_flag <= 0;
		r_write_back_reg[3:0] <= 4'b0000;
	end

	always @ (w_clock, w_cf, w_bus_wordin) begin
		// parse instructions and set appropriate flags
		if (w_bus_wordin[3:0] == 4'b1111 | w_bus_wordin[7:4] == 4'b1100 | w_bus_wordin[7:4] == 4'b1011) begin
			// store MOV register instruction
			// or load high immediate instruction
			// or load low immediate instruction
			r_jump_flag <= 0;
			r_data_mem_write_flag <= 0;
			r_store_word_flag <= 0;
			r_store_pc_flag <= 0;
			r_load_word_flag <= 0;
			r_write_back_flag <= 1;
			r_write_back_reg[3:0] <= 4'b1111;
		end
		else if (w_bus_wordin[7:4] == 4'b1110) begin
			// store w_bus_wordin (register to memory)
			r_jump_flag <= 0;
			r_data_mem_write_flag <= 1;
			r_store_word_flag <= 1;
			r_store_pc_flag <= 0;
			r_load_word_flag <= 0;
			r_write_back_flag <= 0;
			r_write_back_reg[3:0] <= w_bus_wordin[3:0];
		end
		else if (w_bus_wordin[7:4] == 4'b1101) begin
			// load w_bus_wordin (memory to register)
			r_jump_flag <= 0;
			r_data_mem_write_flag <= 0;
			r_store_word_flag <= 0;
			r_store_pc_flag <= 0;
			r_load_word_flag <= 1;
			r_write_back_flag <= 1;
			r_write_back_reg[3:0] <= w_bus_wordin[3:0];
		end
		else if (w_bus_wordin[7:4] == 4'b1010) begin
			// jump and link instruction
			r_jump_flag <= 1;
			r_data_mem_write_flag <= 0;
			r_store_word_flag <= 0;
			r_store_pc_flag <= 1;
			r_load_word_flag <= 0;
			r_write_back_flag <= 1;
			r_write_back_reg[3:0] <= w_bus_wordin[3:0];
		end
		else if (w_bus_wordin[7:4] == 4'b1001) begin
			// branch on flag set instruction
			r_jump_flag <= w_cf;
			r_data_mem_write_flag <= 0;
			r_store_word_flag <= 0;
			r_store_pc_flag <= 0;
			r_load_word_flag <= 0;
			r_write_back_flag <= 0;
			r_write_back_reg[3:0] <= w_bus_wordin[3:0];
		end
		else if (w_bus_wordin[7:4] == 4'b1000 | w_bus_wordin[7:4] == 4'b0111) begin
			// set on greater than instruction
			r_jump_flag <= 0;
			r_data_mem_write_flag <= 0;
			r_store_word_flag <= 0;
			r_store_pc_flag <= 0;
			r_load_word_flag <= 0;
			r_write_back_flag <= 0;
			r_write_back_reg[3:0] <= w_bus_wordin[3:0];
		end
		else if (w_bus_wordin[7:4] == 4'b1111 | w_bus_wordin[7:4] == 4'b0110 | w_bus_wordin[7:4] == 4'b0101 | w_bus_wordin[7:4] == 4'b0100 | w_bus_wordin[7:4] == 4'b0011 | w_bus_wordin[7:4] == 4'b0010 | w_bus_wordin[7:4] == 4'b0001) begin
			// load $mov register instruction
			// or basic arithmetic instructions
			r_jump_flag <= 0;
			r_data_mem_write_flag <= 0;
			r_store_word_flag <= 0;
			r_store_pc_flag <= 0;
			r_load_word_flag <= 0;
			r_write_back_flag <= 1;
			r_write_back_reg[3:0] <= w_bus_wordin[3:0];
		end
	end
endmodule
