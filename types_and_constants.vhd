library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.ceil;
use ieee.math_real.log2;

package types_and_constants is

  constant FILTER_TAPS   : integer                          := 13;
  constant SAMPLE_WIDTH  : integer                          := 10;
  constant ADDRESS_WIDTH : integer                          := integer(ceil(log2(real(FILTER_TAPS))));
  constant MAX_TAP_1       : signed(ADDRESS_WIDTH-1 downto 0) := to_signed(FILTER_TAPS-1, ADDRESS_WIDTH);
  constant RESULT_WIDTH  : integer                          := (2 * SAMPLE_WIDTH) + integer(ceil(log2(real(FILTER_TAPS))));

  type sample_file is array (filter_taps-1 downto 0) of signed (SAMPLE_WIDTH-1 downto 0);
  type coeff_file is array (filter_taps-1 downto 0) of signed (SAMPLE_WIDTH-1 downto 0);
end package;
