library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity fifo_tb is
end entity;

architecture bench of fifo_tb is
component fifo is
  generic (N : integer);
  port (
      rst   : in  std_logic;
      clk   : in  std_logic;
      D: in std_logic_vector(7 downto 0);
      S: out std_logic_vector(7 downto 0)
    );
end component;

signal clk, rst :  std_logic;
signal D, S : std_logic_vector(7 downto 0);

constant CLOCK_PERIOD : time := 10 ns;

begin
uut: fifo
 generic map (N => 4)
  port map(
      rst=>rst,
      clk=>clk,
      D => D,
      S => S
    );

stimulus: process
	begin
    rst <= '0';
    wait for CLOCK_PERIOD*2;

    rst <= '1';
    D <= x"01";
    wait for CLOCK_PERIOD;

    D <= x"02";
    wait for CLOCK_PERIOD;

    D <= x"03";
    wait for CLOCK_PERIOD;

    D <= x"04";
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
