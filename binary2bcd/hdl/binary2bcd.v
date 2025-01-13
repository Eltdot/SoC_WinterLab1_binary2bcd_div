module binary2bcd(
    input wire [13:0] binary_in, // 14 bits binary input
    output reg [15:0] packed_bcd_out // 16 bits packed BCD output (0~9999)
);


reg [13:0] binary_in_tmp[0:2]; // Temporary registers to hold intermediate values during conversion
reg [3:0] digit1, digit2, digit3, digit4; // 4 bits registers to hold each BCD digit (0-9)

always @(*) begin
  binary_in_tmp[0] = binary_in;

  digit1 = binary_in_tmp[0] % 10; // Extract the first digit (units place)
  binary_in_tmp[1] = binary_in_tmp[0] / 10;

  digit2 = binary_in_tmp[1] % 10; // Extract the second digit (tens place)
  binary_in_tmp[2] = binary_in_tmp[1] / 10;

  digit3 = binary_in_tmp[2] % 10; // Extract the third digit (hundreds place)

  digit4 = binary_in_tmp[2] / 10; // Extract the fourth digit (thousands place)

  packed_bcd_out = {digit4, digit3, digit2, digit1}; // Combine the four BCD digits into a packed BCD output
end

endmodule