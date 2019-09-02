// Module m_register_file holds the sixteen 8-bit registers used for the processor.
// Write backs are executed when w_write_back is HIGH. The value of w_bus_write_back_value
// is written to the register specified by w_bus_write_back_reg.

module m_register_file (w_bus_high_reg, w_bus_low_reg, w_bus_instr_word, w_bus_write_back_value, w_bus_write_back_reg, w_write_back, w_clock, w_reset);
	output [7:0] w_bus_high_reg, w_bus_low_reg;
	input [7:0] w_bus_instr_word, w_bus_write_back_value;
	input [3:0] w_bus_write_back_reg;
	input w_write_back, w_clock, w_reset;

	reg [7:0] r_registers [0:15];
	wire [7:0] a0, a1, a2, a3, r2, r3, r4, r5, r6, r7, r8, r10, r13, r14, r15;

	// assign wires to allow for register monitoring (4 general purpose registers, $arg0 through $arg3, given first)
	assign a0 = r_registers[1];							// $arg0 (alias: $not)
	assign a1 = r_registers[9];							// $arg1 (alias: $bfs)
	assign a2 = r_registers[11];							// $arg2 (alias: $lli)
	assign a3 = r_registers[12];							// $arg3 (alias: $lhi)
	assign r2 = r_registers[2];							// $or
	assign r3 = r_registers[3];							// $and
	assign r4 = r_registers[4];							// $add
	assign r5 = r_registers[5];							// $rlf
	assign r6 = r_registers[6];							// $rrt
	assign r7 = r_registers[7];							// $sle
	assign r8 = r_registers[8];							// $sge
	assign r10 = r_registers[10];							// $jal
	assign r13 = r_registers[13];							// $lw
	assign r14 = r_registers[14];							// $sw
	assign r15 = r_registers[15];							// $mov

	integer i;

	assign w_bus_high_reg = r_registers[w_bus_instr_word[7:4]];
	assign w_bus_low_reg = r_registers[w_bus_instr_word[3:0]];

	initial begin
		for (i = 0; i < 16; i = i + 1) r_registers[i] = 8'b00000000;
		// monitor all registers
		
		$monitor("$arg0:%x, $arg1:%x, $arg2:%x, $arg3:%x, $and:%x, $or:%x, $add:%x, $rlf:%x, $rrt:%x, $sle:%x, $sge:%x, $jal:%x, $lw:%x, $sw:%x, $mov:%x", a0, a1, a2, a3, r2, r3, r4, r5, r6, r7, r8, r10, r13, r14, r15);
	end

	always @ (posedge w_clock) begin
		// if write back flag set and the write back register isn't 0, write the given value back to the given register
		if (w_write_back & w_bus_write_back_reg != 4'b0000) r_registers[w_bus_write_back_reg] <= w_bus_write_back_value;
		
		// if reset is HIGH, fill registers with 0
		if (w_reset) for (i = 0; i < 16; i = i + 1) r_registers[i] = 8'b00000000;
	end
endmodule
