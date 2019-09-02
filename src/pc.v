// Module m_pc_reg is the actual program counter register. It holds the value of the
// instruction memory address to be completed.

module m_pc_reg (r_bus_addr_out, w_bus_addr_in, w_clock, w_reset);
	input [7:0] w_bus_addr_in;				// 8 bit address bus input
	input w_clock, w_reset;					// clock and reset variables

	output reg [7:0] r_bus_addr_out;			// 8 bit address bus output

	always @ (posedge w_clock)				// on positive edge of clock pulse:
		if (w_reset) r_bus_addr_out <= 8'b0;		// reset to 0 synchronously
		else r_bus_addr_out <= w_bus_addr_in;		// output what is on the input
endmodule


// Module m_program_counter is the combination of the actual program counter register
// along with the address selecting multiplexer (either PC + 1 or JUMP ADDRESS).

module m_program_counter (w_bus_addr_pc_out, w_bus_jump_addr, w_channel, w_clock, w_reset);
	output [7:0] w_bus_addr_pc_out;
	input [7:0] w_bus_jump_addr;
	input w_channel, w_clock, w_reset;

	wire [7:0] w_bus_mux_out, w_bus_pc_plus1;

	m_pc_reg pc_reg (w_bus_addr_pc_out, w_bus_mux_out, w_clock, w_reset);
	m_8bit_plus1_adder add_pc (w_bus_pc_plus1, w_bus_addr_pc_out);
	m_2to1_8bit_mux pc_mux (w_bus_mux_out, w_bus_pc_plus1, w_bus_jump_addr, w_channel);
endmodule	
