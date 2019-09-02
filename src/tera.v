module m_tera;
	// global section
	// specify clock LOW and reset HIGH initial values
	reg r_clock = 1'b0;
	reg r_reset = 1'b1;

	wire w_clock, w_reset;

	assign w_clock = r_clock;
	assign w_reset = r_reset;
	// end global section


	// program counter section
	reg r_pc_demux_channel = 1'b0;
	
	wire [7:0] w_bus_instr_mem_addr, w_bus_alu_out;
	wire w_jump_flag;

	m_program_counter pc (w_bus_instr_mem_addr, w_bus_alu_out, w_jump_flag, w_clock, w_reset);
	// end program counter section


	// memory section
	wire [7:0] w_bus_instr_mem_word, w_bus_data_mem_word, w_bus_data_mem_addr, w_bus_high_register_value, w_bus_low_register_value;
	wire w_data_mem_write_enable;

	m_instruction_memory instr_mem (w_bus_instr_mem_word, w_bus_instr_mem_addr);
	m_data_memory data_mem (w_bus_data_mem_word, w_bus_high_register_value, w_data_mem_write_enable, w_reset, w_clock);
	// end memory section


	// register file section
	wire [7:0] w_bus_write_back_value;
	wire [3:0] w_bus_write_back_reg;
	wire w_write_back_flag;

	m_register_file regfile (w_bus_high_register_value, w_bus_low_register_value, w_bus_instr_mem_word, w_bus_write_back_value, w_bus_write_back_reg, w_write_back_flag, w_clock, w_reset);
	// end register file section


	// instruction logic unit section
	wire w_store_word_flag, w_store_pc_flag, w_load_word_flag, w_cf; // w_cf is comparison flag
	
	m_instruction_logic_unit ilu (w_jump_flag, w_data_mem_write_enable, w_store_word_flag, w_store_pc_flag, w_load_word_flag, w_write_back_flag, w_bus_write_back_reg, w_bus_instr_mem_word, w_cf, w_clock);
	// end instruction logic unit section


	// arithmetic logic unit section
	m_arithmetic_logic_unit alu (w_bus_alu_out, w_cf, w_bus_instr_mem_word, w_bus_high_register_value, w_bus_low_register_value, w_clock);
	// end arithmetic logic unit section


	// mux/demux section
	wire [7:0] w_bus_demux_inter0, w_bus_mux_inter;

	m_1to2_8bit_demux store_demux (w_bus_demux_inter0, w_bus_data_mem_word, w_bus_alu_out, w_store_word_flag);
	m_2to1_8bit_mux load_mux (w_bus_mux_inter, w_bus_demux_inter0, w_bus_data_mem_word, w_load_word_flag);
	m_2to1_8bit_mux_with_add1 pc_mux (w_bus_write_back_value, w_bus_mux_inter, w_bus_instr_mem_addr, w_store_pc_flag);
	// end mux/demux section


	initial begin
		$dumpfile ("dumpfile.vcd");
		$dumpvars (0, m_tera);

		$display ("\nStarting program (Program Counter = 0).\n");
		#2 r_reset = 1'b0;
	end


	always #1 begin
		r_clock = ~w_clock;	// send clock pulses
	
		if (w_bus_instr_mem_addr == 8'b11111111) begin
			$display ("\nReached EOF (Program Counter = 255). Closing program.\n");
			$finish;
		end
	end
endmodule
