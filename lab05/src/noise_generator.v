module noise_generator (clk, rst_n, enable, Q);
    input clk, enable, rst_n;
    output [23:0] Q;
    
    reg [2:0] counter;
    always@(posedge clk)
		  if (!rst_n)
				counter = 3'b0;
        else if (enable)
				counter = counter + 1'b1;

    assign Q = {{10{counter[2]}}, counter, 11'd0};
endmodule