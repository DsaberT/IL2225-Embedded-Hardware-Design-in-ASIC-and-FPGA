library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.types_and_constants.all;


--! @brief The delay line stores the input samples of the FIR filter.
--
-- It has synchoronous input port an asynchronous output port.
entity delay_line is

  port(
    --! Clock signal
    clk           : in  std_logic;
    --! Active low asynchronous reset
    nrst          : in  std_logic;
    --! Flag to indicate a new sample is present in the input
    new_sample    : in  std_logic;
    --! Flag to enable write of the new sample to memory
    write_enable  : in  std_logic;
    --! Write address of the new sample
    write_address : in  unsigned(ADDRESS_WIDTH-1 downto 0);
    --! Read address of stored samples
    read_address_1, read_address_2  : in  unsigned(ADDRESS_WIDTH-1 downto 0);
    --! Sampple input (write) (Synchronous)
    sample_in     : in  signed (SAMPLE_WIDTH-1 downto 0);
    --! Sample output (read). (Asynchronous)
    sample_out_1, sample_out_2    : out signed (SAMPLE_WIDTH-1 downto 0));

end delay_line;

architecture behaviour of delay_line is

  --! Sample memory
  signal data : sample_file;

begin

  -- Synchronous write to sample memory
  memory_write_pr : process (nrst, clk)
  begin
    if nrst = '0' then
      data <= (others => (others => '0'));
    elsif rising_edge (clk) then
      if write_enable = '1' then
        data(to_integer(unsigned(write_address))) <= sample_in;
      end if;
    end if;
  end process;

  -- Asynchronous read from sample memory
  sample_out_1 <= data(to_integer(read_address_1));
  sample_out_2 <= data(to_integer(read_address_2));

end behaviour;

