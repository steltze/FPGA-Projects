library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity ser_to_par_tb is
end entity;

architecture bench of ser_to_par_tb is
component ser_to_par is
  generic (N : integer := 8);
  port (
      rst   : in  std_logic;
      clk   : in  std_logic;
      valid_in   : in  std_logic;
      D: in std_logic_vector(7 downto 0);
      OUT_1 : out std_logic_vector(7 downto 0);
      OUT_2 : out std_logic_vector(7 downto 0);
      OUT_3 : out std_logic_vector(7 downto 0);
      OUT_4 : out std_logic_vector(7 downto 0);
      OUT_5 : out std_logic_vector(7 downto 0);
      OUT_6 : out std_logic_vector(7 downto 0);
      OUT_7 : out std_logic_vector(7 downto 0);
      OUT_8 : out std_logic_vector(7 downto 0);
      OUT_9 : out std_logic_vector(7 downto 0)
    );
end component;

signal clk, rst, valid_in :  std_logic;
signal D, OUT_1, OUT_2, OUT_3, OUT_4, OUT_5, OUT_6, OUT_7, OUT_8, OUT_9 : std_logic_vector(7 downto 0);

constant CLOCK_PERIOD : time := 10 ns;

begin
uut: ser_to_par
 generic map (N => 4)
  port map(
      rst=>rst,
      clk=>clk,
      D => D,
      valid_in => valid_in,
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
    valid_in <= '1';
    D <= x"01";
    wait for CLOCK_PERIOD;

    D <= x"02";
    wait for CLOCK_PERIOD;

    D <= x"03";
    wait for CLOCK_PERIOD;

    D <= x"04";
    wait for CLOCK_PERIOD;

    D <= x"05";
    wait for CLOCK_PERIOD;

    D <= x"06";
    wait for CLOCK_PERIOD;

    D <= x"07";
    wait for CLOCK_PERIOD;

    D <= x"08";
    wait for CLOCK_PERIOD;

    D <= x"09";
    wait for CLOCK_PERIOD;

    D <= x"0A";
    wait for CLOCK_PERIOD;

    D <= x"0B";
    wait for CLOCK_PERIOD;

    D <= x"0C";
    wait for CLOCK_PERIOD;

    D <= x"0D";
    wait for CLOCK_PERIOD;


    D <= x"0E";
    wait for CLOCK_PERIOD;

    D <= x"0F";
    wait for CLOCK_PERIOD;
    
        D <= x"10";
    wait for CLOCK_PERIOD;

    D <= x"11";
    wait for CLOCK_PERIOD;

    D <= x"12";
    wait for CLOCK_PERIOD;

    D <= x"13";
    wait for CLOCK_PERIOD;


    D <= x"14";
    wait for CLOCK_PERIOD;

    D <= x"15";
    wait for CLOCK_PERIOD;

    D <= x"16";
    wait for CLOCK_PERIOD;

    D <= x"17";
    wait for CLOCK_PERIOD;

    D <= x"18";
    wait for CLOCK_PERIOD;

    D <= x"19";
    wait for CLOCK_PERIOD;

    D <= x"1A";
    wait for CLOCK_PERIOD;

    D <= x"1B";
    wait for CLOCK_PERIOD;

    D <= x"1C";
    wait for CLOCK_PERIOD;

    D <= x"1D";
    wait for CLOCK_PERIOD;


    D <= x"1E";
    wait for CLOCK_PERIOD;

    D <= x"1F";
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
