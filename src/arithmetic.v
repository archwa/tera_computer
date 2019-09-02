// Module m_8bit_plus1_adder takes in an 8-bit value on w_bus_eight_in
// adds 1 to it, and outputs the value on w_bus_eight_out.

module m_8bit_plus1_adder (w_bus_eight_out, w_bus_eight_in);
	output [7:0] w_bus_eight_out;
	input [7:0] w_bus_eight_in;

	assign w_bus_eight_out = w_bus_eight_in + 1;
endmodule


// Module m_arithmetic_logic_unit parses given instructions and the
// comparison flag to determine what arithmetic operations must be
// performed on the given inputs.

module m_arithmetic_logic_unit (w_bus_alu_out, w_cf, word, w_bus_high_register_value, w_bus_low_register_value, w_clock);
	output [7:0] w_bus_alu_out;
	output w_cf;
	input [7:0] word, w_bus_high_register_value, w_bus_low_register_value;
	input w_clock;

	reg [7:0] r_bus_alu_out;
	reg r_cf, r_temp1;
	reg [6:0] r_temp2;

	assign w_bus_alu_out = r_bus_alu_out;
	assign w_cf = r_cf;

	integer i;

	// initialize outputs, flags, temporaries with 0
	initial begin
		r_bus_alu_out[7:0] <= 8'b00000000;
		r_cf <= 0;
		r_temp1 <= 0;
		r_temp2 <= 7'b0000000;
	end

	always @ (w_clock, w_bus_low_register_value, w_bus_high_register_value, word) begin
		if (word[7:4] == 4'b1111 | word[3:0] == 4'b1111) r_bus_alu_out[7:0] <= w_bus_high_register_value[7:0]; 			// mov
		else if (word[7:4] == 4'b1110) r_bus_alu_out[7:0] <= w_bus_low_register_value[7:0]; 					// sw
		else if (word[7:4] == 4'b1101) r_bus_alu_out[7:0] <= 8'b00000000;							// lw
		else if (word[7:4] == 4'b1100) r_bus_alu_out[7:0] <= {word[3:0], 4'b0000};						// lhi
		else if (word[7:4] == 4'b1011) r_bus_alu_out[7:0] <= {4'b0000, word[3:0]};						// lli
		else if (word[7:4] == 4'b1010) r_bus_alu_out[7:0] <= w_bus_high_register_value[7:0];					// jal
		else if (word[7:4] == 4'b1001) r_bus_alu_out[7:0] <= (w_cf) ? w_bus_low_register_value : 8'b00000000;			// bfs
		else if (word[7:4] == 4'b1000) begin											// sge
			r_cf <= (w_bus_high_register_value >= w_bus_low_register_value);
			r_bus_alu_out[7:0] <= 8'b00000000;
		end
		else if (word[7:4] == 4'b0111) begin											// sle
			r_cf <= (w_bus_high_register_value <= w_bus_low_register_value);
			r_bus_alu_out[7:0] <= 8'b00000000;
		end
		else if (word[7:4] == 4'b0110) begin											// rrt
			r_bus_alu_out[7:0] = w_bus_low_register_value[7:0];
			for (i = 0; i < w_bus_high_register_value; i = i + 1) begin
				r_temp1 = r_bus_alu_out[0];
				r_temp2[6:0] = r_bus_alu_out[7:1];
				r_bus_alu_out[7:0] = {r_temp1, r_temp2[6:0]};
			end
		end
		else if (word[7:4] == 4'b0101) begin											// rlf
			r_bus_alu_out[7:0] = w_bus_low_register_value[7:0];
			for (i = 0; i < w_bus_high_register_value; i = i + 1) begin
				r_temp1 = r_bus_alu_out[7];
				r_temp2[6:0] = r_bus_alu_out[6:0];
				r_bus_alu_out[7:0] = {r_temp2[6:0], r_temp1};
			end
		end
		else if (word[7:4] == 4'b0100) r_bus_alu_out[7:0] <= (w_bus_high_register_value + w_bus_low_register_value);		// add
		else if (word[7:4] == 4'b0011) r_bus_alu_out[7:0] <= (w_bus_high_register_value[7:0] | w_bus_low_register_value[7:0]);	// or
		else if (word[7:4] == 4'b0010) r_bus_alu_out[7:0] <= (w_bus_high_register_value[7:0] & w_bus_low_register_value[7:0]);	// and
		else if (word[7:4] == 4'b0001) r_bus_alu_out[7:0] <= (~w_bus_high_register_value[7:0]);					// not
		else r_bus_alu_out[7:0] <= 8'b00000000;
	end
endmodule
