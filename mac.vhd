library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.types_and_constants.all;

-- The MAC (Multipply ACcumulate) component performs a very simple
-- arithmetic operation:
-- output = sample * coefficient + accumulate
entity MAC is

  port (
    --! Input sample
    sample_in   : in  signed(SAMPLE_WIDTH-1 downto 0);
    --! Input coefficient
    coefficient : in  signed(SAMPLE_WIDTH-1 downto 0);
    --! Accumulate input
    accumulate  : in  signed(RESULT_WIDTH-1 downto 0);
    --! Output result
    result      : out signed(RESULT_WIDTH-1 downto 0));

end entity MAC;

architecture behaviour of MAC is
begin
  result <= (sample_in * coefficient) + accumulate;
end behaviour;
