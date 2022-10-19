library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.types_and_constants.all;

entity arithmetic_unit is

  port (
    --! Clock signal
    clk         : in  std_logic;
    --! Active low asynchronous reset
    nrst       : in  std_logic;
    --! Active low MAC reset. Clears the accumulate value.
    nrst_mac   : in  std_logic;
   -- reset for last lap in mac 2
    nrst_mac_2 : in std_logic; 
    --! Input sample
    sample_in_1, sample_in_2   : in  signed(SAMPLE_WIDTH-1 downto 0);
    --! Input coefficient
    coefficient_1, coefficient_2 : in  signed(SAMPLE_WIDTH-1 downto 0);
    --! Output result
    result     : out signed(RESULT_WIDTH-1 downto 0));

end entity arithmetic_unit;

architecture behaviour of arithmetic_unit is
  signal temp_result_1, temp_result_2, MAC_result_1, MAC_result_2 : signed (RESULT_WIDTH-1 downto 0);
  signal coefficient2_signal : signed (SAMPLE_WIDTH-1 downto 0);
begin

  -- Instantiate MAC 1
  MAC_1: entity work.MAC
    port map (
      sample_in   => sample_in_1,
      coefficient => coefficient_1,
      accumulate  => temp_result_1,
      result      => MAC_result_1);
  -- Instantiate MAC 2
 MAC_2: entity work.MAC
    port map (
      sample_in   => sample_in_2,
      coefficient => coefficient2_signal,
      accumulate  => temp_result_2,
      result      => MAC_result_2);

  process (clk, nrst)
  begin
    if nrst = '0' then
      	temp_result_1 <= (others => '0');
	temp_result_2 <= (others => '0');
    elsif rising_edge (clk) then
      if nrst_mac = '0' then
        	temp_result_1 <= (others => '0');
		temp_result_2 <= (others => '0');
      else
        	temp_result_1 <= MAC_result_1;
		temp_result_2 <= MAC_result_2;
      end if;
    end if;
  end process;
	with nrst_mac_2 select
	 coefficient2_signal <= coefficient_2 when '1',
				 (others => '0') when others;
	
	
	result <= temp_result_1 + temp_result_2;
end behaviour;
