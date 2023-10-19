library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity parallel_filter_tb is
end entity;

architecture bench of parallel_filter_tb is
component parallel_filter is
  port (
      rst   : in  std_logic;
      clk   : in  std_logic;
      x1 : in std_logic_vector(7 downto 0);
      x2 : in std_logic_vector(7 downto 0);
      valid_in : in std_logic;
      valid_out : out std_logic;
      y1 : out std_logic_vector(18 downto 0);
      y2 : out std_logic_vector(18 downto 0) -- 16+1 bits
    );
end component;

signal clk, rst, valid_out, valid_in :  std_logic;
signal x1, x2 : std_logic_vector(7 downto 0);
signal y1, y2 : std_logic_vector(18 downto 0);

constant CLOCK_PERIOD : time := 10 ns;

begin
uut: parallel_filter
  port map(
      rst=>rst,
      clk=>clk,
      valid_in=>valid_in,
      x1 => x1,
      x2 => x2,
      valid_out => valid_out,
      y1 => y1,
      y2 => y2
    );

stimulus: process
	begin
    rst <= '0';
    valid_in <= '0';
    wait for CLOCK_PERIOD*2;

    rst <= '1';
    valid_in <= '1';
    --------------------------------------
     x2 <= x"C2"; -- 194
     x1 <= x"BE";  -- 190
     wait for CLOCK_PERIOD;

     x2 <= x"65"; -- 101
     x1 <= x"A8"; -- 168
     wait for CLOCK_PERIOD;

     x2 <= x"2C"; -- 44
     x1 <= x"B5"; -- 181
     wait for CLOCK_PERIOD;

     x2 <= x"09"; -- 9
     x1 <= x"47"; -- 71
     wait for CLOCK_PERIOD;  -- eighth input

     x2 <= x"0C"; -- 12
     x1 <= x"19"; -- 25
     wait for CLOCK_PERIOD;

     x2 <= x"D2"; -- 210
     x1 <= x"B2"; -- 178
     valid_in <= '0';
     wait for CLOCK_PERIOD*2;

     valid_in <= '1';
     wait for CLOCK_PERIOD;

     x2 <= x"51"; -- 81
     x1 <= x"F3"; -- 243
     wait for CLOCK_PERIOD;

     x2 <= x"09"; -- 9
     x1 <= x"00"; -- 0
     wait for CLOCK_PERIOD;


     x2 <= x"00"; -- 9
     x1 <= x"00"; -- 0
     wait for CLOCK_PERIOD;
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
