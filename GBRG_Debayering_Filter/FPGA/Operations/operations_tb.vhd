library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity Operations_tb is
end entity;

architecture bench of Operations_tb is
component Operations is
  generic (N : integer);
  port (
      OUT_1 : in std_logic_vector(7 downto 0);
      OUT_2 : in std_logic_vector(7 downto 0);
      OUT_3 : in std_logic_vector(7 downto 0);
      OUT_4 : in std_logic_vector(7 downto 0);
      OUT_5 : in std_logic_vector(7 downto 0);
      OUT_6 : in std_logic_vector(7 downto 0);
      OUT_7 : in std_logic_vector(7 downto 0);
      OUT_8 : in std_logic_vector(7 downto 0);
      OUT_9 : in std_logic_vector(7 downto 0);
      color_case: in std_logic_vector(1 downto 0);
      state : in std_logic_vector(3 downto 0);
      R : out std_logic_vector(7 downto 0);
      G : out std_logic_vector(7 downto 0);
      B : out std_logic_vector(7 downto 0)
    );
end component;

signal color_case : std_logic_vector(1 downto 0);
signal state : std_logic_vector(3 downto 0);
signal clk, rst :  std_logic;
signal R, G, B, OUT_1, OUT_2, OUT_3, OUT_4, OUT_5, OUT_6, OUT_7, OUT_8, OUT_9 : std_logic_vector(7 downto 0) := (others => '0');

constant CLOCK_PERIOD : time := 10 ns;

begin
uut: Operations
 generic map (N => 4)
  port map(
      rst=>rst,
      clk=>clk,
      color_case => color_case,
      state => state,
      OUT_1 => OUT_1,
      OUT_2 => OUT_2,
      OUT_3 => OUT_3,
      OUT_4 => OUT_4,
      OUT_5 => OUT_5,
      OUT_6 => OUT_6,
      OUT_7 => OUT_7,
      OUT_8 => OUT_8,
      OUT_9 => OUT_9
    );

stimulus: process
	begin
    rst <= '0';
    wait for CLOCK_PERIOD*2;

    rst <= '1';
    OUT_1 <= x"01";
    wait for CLOCK_PERIOD;

    OUT_1 <= x"02";
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
