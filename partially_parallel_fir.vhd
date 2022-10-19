library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.types_and_constants.all;

entity serial_fir is

  port (
    --! Clock signal
    clk          : in  std_logic;
    --! Active low asynchronous reset
    nrst         : in  std_logic;
    --! Sample input
    sample_in    : in  signed(SAMPLE_WIDTH-1 downto 0);
    --! New sample flag
    new_sample   : in  std_logic;
    --! Output of the FIR filter
    output       : out signed(RESULT_WIDTH-1 downto 0);
    --! Output ready flag
    output_ready : out std_logic);

end entity serial_fir;

architecture structural of serial_fir is

  signal nrst_mac            : std_logic;
  signal nrst_mac_2          : std_logic;
  signal write_enable        : std_logic;
  signal out_temp  	     : std_logic;
  signal result              : signed(RESULT_WIDTH-1 downto 0);
  signal write_address       : unsigned(ADDRESS_WIDTH-1 downto 0);
  signal read_address_1, read_address_2        : unsigned(ADDRESS_WIDTH-1 downto 0);
  signal coefficient_address_1, coefficient_address_2  : unsigned(ADDRESS_WIDTH-1 downto 0);
  signal sample_out_1, sample_out_2          : signed(SAMPLE_WIDTH-1 downto 0);
  signal coefficient_1, coefficient_2         : signed(SAMPLE_WIDTH-1 downto 0);

begin

  ARITHMETIC_UNIT_1 : entity work.arithmetic_unit
    port map (
      clk         => clk,
      nrst        => nrst,
      nrst_mac    => nrst_mac,
      nrst_mac_2  => nrst_mac_2,
      sample_in_1   => sample_out_1,
      sample_in_2   => sample_out_2,
      coefficient_1 => coefficient_1,
      coefficient_2 => coefficient_2,      
      result      => result);

  FSM_1 : entity work.fsm
    port map (
      clk                 => clk,
      nrst                => nrst,
      nrst_mac_2  	  => nrst_mac_2,
      new_sample          => new_sample,
      write_enable        => write_enable,
      write_address       => write_address,
      read_address_1        => read_address_1,
      read_address_2        => read_address_2,
      output_ready       => out_temp,
      nrst_mac            => nrst_mac,
      coefficient_address_1  => coefficient_address_1,
coefficient_address_2  => coefficient_address_2);

  ROM_COEFFICIENTS_1 : entity work.rom_coefficients
    port map (
      coeff_addr => coefficient_address_1,
      coeff_out_2  => coefficient_2,
      coeff_out_1  => coefficient_1);


  DELAY_LINE_1 : entity work.delay_line
    port map (
      clk           => clk,
      nrst          => nrst,
      new_sample    => new_sample,
      write_address => write_address,
      write_enable  => write_enable,
      sample_in     => sample_in,
      read_address_1        => read_address_1,
      read_address_2  => read_address_2,
      sample_out_1    => sample_out_1,
      sample_out_2    => sample_out_2);

  OUTPUT_SELECT : output <= result when (out_temp = '1') else (others => '0');

end structural;
