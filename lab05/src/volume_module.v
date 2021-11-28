module volume_module(
  input clock,
  input volume_flg,
  input [23:0] left_input, right_input,
  output reg [23:0] left_output, right_output
);

  always@(posedge clock)
  begin
    left_output = volume_flg? left_input*2 : left_input;
    right_output = volume_flg? right_input*2: right_input;
  end
endmodule

