library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity filter_tb is
end entity;

architecture bench of filter_tb is
component filter is
  port (
      rst   : in  std_logic;
      clk   : in  std_logic;
      x : in std_logic_vector(7 downto 0);
      valid_in : in std_logic;
      valid_out : out std_logic;
      y : out std_logic_vector(18 downto 0) -- 16+1 bits
    );
end component;

signal clk, rst, valid_out, valid_in :  std_logic;
signal x : std_logic_vector(7 downto 0);
signal y : std_logic_vector(18 downto 0);

constant CLOCK_PERIOD : time := 10 ns;

begin
uut: filter
  port map(
      rst=>rst,
      clk=>clk,
      valid_in=>valid_in,
      x => x,
      valid_out => valid_out,
      y => y
    );

stimulus: process
	begin
    rst <= '0';
    valid_in <= '0';
    x <= x"00";
    wait for CLOCK_PERIOD*2;

    rst <= '1';
    valid_in <= '1';

    x <= x"C2"; -- 194
    wait for CLOCK_PERIOD;

    x<= x"BE";  -- 190
    wait for CLOCK_PERIOD;

    x<= x"65"; -- 101
    wait for CLOCK_PERIOD;

    x<= x"A8"; -- 168
    wait for CLOCK_PERIOD;

    x<= x"2C"; -- 44
    wait for CLOCK_PERIOD;

    x<= x"B5"; -- 181
    wait for CLOCK_PERIOD;

    x<= x"09"; -- 9
    wait for CLOCK_PERIOD;

    x<= x"47"; -- 71
    wait for CLOCK_PERIOD;  -- eighth input

    x<= x"0C"; -- 12
    valid_in <= '0';
    wait for CLOCK_PERIOD*2;

    valid_in <= '1';
    wait for CLOCK_PERIOD;

    x<= x"19"; -- 25
    valid_in <= '1';
    wait for CLOCK_PERIOD;

    x<= x"D2"; -- 210
    valid_in <= '1';
    wait for CLOCK_PERIOD;

    x<= x"B2"; -- 178
    valid_in <= '1';
    wait for CLOCK_PERIOD;

    x<= x"51"; -- 81
    valid_in <= '0';
    wait for CLOCK_PERIOD;

    valid_in <= '1';
    wait for CLOCK_PERIOD;

    x<= x"F3"; -- 243
    valid_in <= '1';
    wait for CLOCK_PERIOD;

    x<= x"09"; -- 9
    valid_in <= '1';
    wait for CLOCK_PERIOD;

    x<= x"00"; -- 0
    valid_in <= '1';
    wait for CLOCK_PERIOD*8;

    wait for CLOCK_PERIOD*10;

	wait;
end process;

generate_clock : process
begin
	clk <= '0';
	wait for CLOCK_PERIOD/2;
	clk <= '1';
	wait for CLOCK_PERIOD/2;
end process;

end bench;
