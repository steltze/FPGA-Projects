library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity unit_tb is
end entity;

architecture bench of unit_tb is
component unit is
  port (
      rst   : in  std_logic;
      clk   : in  std_logic;

      x : in std_logic_vector(7 downto 0);
      coeff : in std_logic_vector(7 downto 0);
      prev_sum : in std_logic_vector(18 downto 0);

      x_dot : out std_logic_vector(7 downto 0);
      total_sum : out std_logic_vector(18 downto 0)
    );
end component;

signal clk, rst :  std_logic;
signal x, coeff, x_dot : std_logic_vector(7 downto 0);
signal prev_sum, total_sum : std_logic_vector(18 downto 0);

constant CLOCK_PERIOD : time := 10 ns;

begin
uut: unit
--  generic map (coeff_width => 8)
  port map(
      rst=>rst,
      clk=>clk,
      x => x,
      coeff => coeff,
      x_dot => x_dot,
      prev_sum => prev_sum,
      total_sum => total_sum
    );

stimulus: process
	begin
    rst <= '0';
    wait for CLOCK_PERIOD*2;

    rst <= '1';
    x <= x"0F";
    coeff <= x"01";
    prev_sum <= "000" & x"0000";
    wait for CLOCK_PERIOD;

    x <= x"12";
    coeff <= x"02";
    prev_sum <= "000" & x"0001";
    wait for CLOCK_PERIOD;

    x <= x"76";
    coeff <= x"03";
    prev_sum <= "000" & x"0034";
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
