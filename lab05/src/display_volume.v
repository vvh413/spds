module display_volume(
  input clock,
  input [23:0] l_in,
  output  reg [7:0] LEDR
);

  always@(posedge clock)
  begin
    LEDR = 8'b0;
    if ( l_in< 1<<3) LEDR[0]<=1;
    else if ( l_in< 1<<6) LEDR[1]=1;
    else if ( l_in< 1<<9) LEDR[2]=1;
    else if ( l_in< 1<<12) LEDR[3]=1;
    else if ( l_in< 1<<15) LEDR[4]=1;
    else if ( l_in< 1<<18) LEDR[5]=1;
    else if ( l_in< 1<<21) LEDR[6]=1;
    else if ( l_in< 1<<23) LEDR[7]=1;
  end
endmodule



