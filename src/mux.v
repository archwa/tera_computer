// Module m_2to1_8bit_mux is a dual 2 to 1 multiplexer. When w_channel is HIGH,
// w_bus_mux_in_1 bus is selected. When w_channel is LOW, w_bus_mux_in_0 bus is selected.

module m_2to1_8bit_mux (w_bus_mux_out, w_bus_mux_in_0, w_bus_mux_in_1, w_channel);
	output [7:0] w_bus_mux_out;
	input [7:0] w_bus_mux_in_0, w_bus_mux_in_1;
	input w_channel;

	assign w_bus_mux_out = (w_channel) ? w_bus_mux_in_1 : w_bus_mux_in_0;
endmodule

// Module m_2to1_8bit_mux_with_add1 is a dual 2 to 1 multiplexer. When w_channel is HIGH,
// w_bus_mux_in_1 bus is selected, adding 1 to its value. When w_channel is LOW,
// w_bus_mux_in_0 bus is selected.

module m_2to1_8bit_mux_with_add1 (w_bus_mux_out, w_bus_mux_in_0, w_bus_mux_in_1, w_channel);
	output [7:0] w_bus_mux_out;
	input [7:0] w_bus_mux_in_0, w_bus_mux_in_1;
	input w_channel;

	assign w_bus_mux_out = (w_channel) ? (w_bus_mux_in_1 + 1) : w_bus_mux_in_0;
endmodule


// Module m_2to1_8bit_demux is a 1 to 2 demultiplexer. When w_channel
// is HIGH, w_bus_demux_out_1 takes the value of w_bus_demux_in, while
// the high impedance state is output to w_bus_demux_out_0. When
// w_channel is LOW, w_bus_demux_out_0 takes the value of w_bus_demux_in,
// while the high impedance state is output to w_bus_demux_out_1.

module m_1to2_8bit_demux (w_bus_demux_out_0, w_bus_demux_out_1, w_bus_demux_in, w_channel);
	output [7:0] w_bus_demux_out_0, w_bus_demux_out_1;
	input [7:0] w_bus_demux_in;
	input w_channel;
	
	assign w_bus_demux_out_0 = (w_channel) ? 8'bzzzzzzzz : w_bus_demux_in;
	assign w_bus_demux_out_1 = (w_channel) ? w_bus_demux_in : 8'bzzzzzzzz;
endmodule
