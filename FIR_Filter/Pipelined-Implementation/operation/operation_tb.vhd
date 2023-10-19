library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity operation_tb is
end entity;

architecture bench of operation_tb is
component operation is
  port (
      x: in std_logic_vector(7 downto 0);
      coeff: in std_logic_vector(7 downto 0);
      prev_sum : in std_logic_vector(18 downto 0);
      clk: in std_logic;
      rst: in std_logic;
      product : out std_logic_vector(18 downto 0)
    );
end component;

signal clk, rst :  std_logic;
signal x, coeff : std_logic_vector(7 downto 0);
signal product, prev_sum : std_logic_vector(18 downto 0);

constant CLOCK_PERIOD : time := 10 ns;

begin
uut: operation
--  generic map (coeff_width => 8)
  port map(
      x => x,
      coeff => coeff,
      prev_sum => prev_sum,
      rst=>rst,
      clk=>clk,
      product => product
    );

stimulus: process
	begin
    rst <= '0';
    prev_sum <= "000" & x"0002";
    wait for CLOCK_PERIOD*2;

    rst <= '1';
    x <= x"0F";
    coeff <= x"0F";
    wait for CLOCK_PERIOD;

    x <= x"18";
    coeff <= x"9C";
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
