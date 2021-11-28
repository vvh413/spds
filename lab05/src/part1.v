module part1 (CLOCK_50, CLOCK2_50, KEY, SW, FPGA_I2C_SCLK, FPGA_I2C_SDAT, AUD_XCK, 
		        AUD_DACLRCK, AUD_ADCLRCK, AUD_BCLK, AUD_ADCDAT, AUD_DACDAT, LEDR);

	input CLOCK_50, CLOCK2_50;
	input [1:0] KEY;
	input [9:0] SW;
	// I2C Audio/Video config interface
	output FPGA_I2C_SCLK;
	inout FPGA_I2C_SDAT;
	// Audio CODEC
	output AUD_XCK;
	input AUD_DACLRCK, AUD_ADCLRCK, AUD_BCLK;
	input AUD_ADCDAT;
	output AUD_DACDAT;
	output [7:0] LEDR;

	// Local wires.
	wire read_ready, write_ready, read, write;
	wire [23:0] readdata_left, readdata_right;
	wire [23:0] writedata_left, writedata_right;
	wire reset = ~KEY[0];

	/////////////////////////////////
	// Your code goes here 
	/////////////////////////////////
	wire [23:0] noise;
	
	wire [23:0] v_left, v_right;
	
	wire [7:0] temp_ledr;
	
	
	
	
	display_volume display_volume(
		.clock(CLOCK2_50),
		.l_in(v_left),
		.LEDR(temp_ledr)
		
	);
	
	volume_module volume_module(
		.clock(CLOCK2_50),
		.left_input(readdata_left),
		.right_input(readdata_right),
		.left_output(v_left),
		.right_output(v_right)
		
	);
	
	
	
	noise_generator noise_gen(
		.clk (CLOCK2_50),
		.rst_n (reset),
		.enable (SW[9]),
		.Q(noise)
	);
	
	
	
	
	assign LEDR = temp_ledr;
	assign writedata_left = v_left + (SW[9] ? noise : 24'b0);
	assign writedata_right = KEY[1] ? v_right + (SW[9] ? noise : 24'b0)
											  : 24'b0;
	assign read = read_ready;
	assign write = write_ready;
	
/////////////////////////////////////////////////////////////////////////////////
// Audio CODEC interface. 
//
// The interface consists of the following wires:
// read_ready, write_ready - CODEC ready for read/write operation 
// readdata_left, readdata_right - left and right channel data from the CODEC
// read - send data from the CODEC (both channels)
// writedata_left, writedata_right - left and right channel data to the CODEC
// write - send data to the CODEC (both channels)
// AUD_* - should connect to top-level entity I/O of the same name.
//         These signals go directly to the Audio CODEC
// I2C_* - should connect to top-level entity I/O of the same name.
//         These signals go directly to the Audio/Video Config module
/////////////////////////////////////////////////////////////////////////////////
	
	clock_generator my_clock_gen(
		// inputs
		CLOCK2_50,
		reset,

		// outputs
		AUD_XCK
	);

	audio_and_video_config cfg(
		// Inputs
		CLOCK_50,
		reset,

		// Bidirectionals
		FPGA_I2C_SDAT,
		FPGA_I2C_SCLK
	);

	audio_codec codec(
		// Inputs
		CLOCK_50,
		reset,

		read,	write,
		writedata_left, writedata_right,

		AUD_ADCDAT,

		// Bidirectionals
		AUD_BCLK,
		AUD_ADCLRCK,
		AUD_DACLRCK,

		// Outputs
		read_ready, write_ready,
		readdata_left, readdata_right,
		AUD_DACDAT
	);

endmodule


