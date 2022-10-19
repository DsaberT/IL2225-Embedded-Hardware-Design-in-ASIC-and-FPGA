library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.types_and_constants.all;

-- The rom_coefficients entity simulates an asynchronous ROM that stores the
-- FIR coefficients. The coefficients are initialized in a "triangular" pattern.
-- You are free to change the coefficinets to any value but this pattern makes
-- it easy to verify the correct output when an impulse input is applied.
entity rom_coefficients is

  port (
    --! Address selector
    coeff_addr : in  unsigned(ADDRESS_WIDTH-1 downto 0);
    --! Coefficient output
    coeff_out_1  : out signed (SAMPLE_WIDTH-1 downto 0);
    coeff_out_2  : out signed (SAMPLE_WIDTH-1 downto 0));


end entity rom_coefficients;

architecture behavior of rom_coefficients is

  -- Initialize the coefficients
  signal all_coeffs : coeff_file;
begin

  -- Permanently connect the coefficients to their value to emulate the ROM
  all_coeffs(0)  <= "0000000001";
  all_coeffs(1)  <= "0000000011";
  all_coeffs(2)  <= "0000000111";
  all_coeffs(3)  <= "0000001111";
  all_coeffs(4)  <= "0000011111";
  all_coeffs(5)  <= "0000111111";
  all_coeffs(6)  <= "0001111111";
  all_coeffs(7)  <= "0000111111";
  all_coeffs(8)  <= "0000011111";
  all_coeffs(9)  <= "0000001111";
  all_coeffs(10) <= "0000000111";
  all_coeffs(11) <= "0000000011";
  all_coeffs(12) <= "0000000001";

  -- Select the coefficient position specified in coeff_addr
  coeff_out_1 <= all_coeffs(to_integer(unsigned(coeff_addr)));
coeff_out_2 <= all_coeffs(to_integer(unsigned(coeff_addr)));

end architecture behavior;
