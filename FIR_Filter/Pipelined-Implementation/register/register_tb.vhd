library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity DFF_8bit_tb is
end entity;

architecture bench of DFF_8bit_tb is
component DFF_8bit is
  port (
      D: in std_logic_vector(7 downto 0);
      clk: in std_logic;
      rst: in std_logic;
      S: out std_logic_vector(7 downto 0)
    );
end component;

signal clk, rst :  std_logic;
signal D, S : std_logic_vector(7 downto 0);

constant CLOCK_PERIOD : time := 10 ns;

begin
uut: DFF_8bit
--  generic map (coeff_width => 8)
  port map(
      D => D,
      rst=>rst,
      clk=>clk,
      S => S
    );

stimulus: process
	begin
    rst <= '0';
    wait for CLOCK_PERIOD*2;

    rst <= '1';
    D <= x"0F";
    wait for CLOCK_PERIOD;

    D <= x"12";
    wait for CLOCK_PERIOD;

    D <= x"76";
    wait for CLOCK_PERIOD;

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
