// Module m_instruction_memory is 8 bits wide by 256 words deep. When
// an address is given to m_instr_mem by w_bus_addr, the value in the
// r_instr_mem register is given to w_bus_data. Program "program.bin"
// in the working directory is loaded into memory initially.

module m_instruction_memory (w_bus_data, w_bus_addr);
	output [7:0] w_bus_data;
	input [7:0] w_bus_addr;

	reg [7:0] r_instr_mem [0:255];

	assign w_bus_data = r_instr_mem[w_bus_addr];

	initial $readmemb("program.bin", r_instr_mem);
endmodule

// Module m_data_memory is 8 bit wide by 256 words deep. When an
// address is given to m_data_memory by w_bus_addr, the value in 
// the r_data_mem register is given to w_bus_data_inout. Loaded
// initially with 0. Writes on the negative w_clock edge.

module m_data_memory (w_bus_data_inout, w_bus_addr, w_write_enable, w_reset, w_clock);
	inout [7:0] w_bus_data_inout;
	input [7:0] w_bus_addr;
	input w_write_enable, w_reset, w_clock;

	reg [7:0] r_data_mem [0:255];

	integer i;
	
	assign w_bus_data_inout = (w_write_enable) ? 8'bzzzzzzzz : r_data_mem[w_bus_addr];

	always @ (negedge w_clock) begin
		if (w_write_enable) r_data_mem[w_bus_addr] <= w_bus_data_inout;
		if (w_reset) for (i = 0; i < 256; i = i + 1) r_data_mem[i] <= 8'b00000000;
	end
endmodule
