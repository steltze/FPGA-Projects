library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity filter_tb is
end entity;

architecture bench of filter_tb is
component filter
  port (
      rst     : in  std_logic;
      clk     : in  std_logic;
      valid_in : in  std_logic;
      x : in std_logic_vector(7 downto 0);
      filter_output : out std_logic_vector(18 downto 0);
      valid_output : out std_logic
    );
end component;

signal clk, rst, valid_in, valid_output : std_logic;
signal x : std_logic_vector(7 downto 0);
signal filter_output : std_logic_vector(18 downto 0);

constant CLOCK_PERIOD : time := 10 ns;

begin
 uut : filter
  port map (
            rst=>rst,
            clk => clk,
            valid_in => valid_in,
            x => x,
            filter_output => filter_output,
            valid_output => valid_output
           );


stimulus: process
	begin
    rst<='0';
    valid_in<='0';
    x <= (others => '0');
    wait for CLOCK_PERIOD*2;

    rst<='1';
    valid_in<='1';

    x <= x"C2"; -- 194
    valid_in <= '1';
    wait for CLOCK_PERIOD;
    valid_in <= '0';
    wait for CLOCK_PERIOD*7;

    x<= x"BE";  -- 190
    valid_in <= '1';
    wait for CLOCK_PERIOD;
    valid_in <= '0';
    wait for CLOCK_PERIOD*7;

    x<= x"65"; -- 101
    valid_in <= '1';
    wait for CLOCK_PERIOD;
    valid_in <= '0';
    wait for CLOCK_PERIOD*7;

    x<= x"A8"; -- 168
    valid_in <= '1';
    wait for CLOCK_PERIOD;
    valid_in <= '0';
    wait for CLOCK_PERIOD*7;

    x<= x"2C"; -- 44
    valid_in <= '1';
    wait for CLOCK_PERIOD;
    valid_in <= '0';
    wait for CLOCK_PERIOD*7;

    x<= x"B5"; -- 181
    valid_in <= '1';
    wait for CLOCK_PERIOD;
    valid_in <= '0';
    wait for CLOCK_PERIOD*7;

    x<= x"09"; -- 9
    valid_in <= '1';
    wait for CLOCK_PERIOD;
    valid_in <= '0';
    wait for CLOCK_PERIOD*7;

    x<= x"47"; -- 71
    valid_in <= '1';
    wait for CLOCK_PERIOD;
    valid_in <= '0';
    wait for CLOCK_PERIOD*7;

    x<= x"0C"; -- 12
    valid_in <= '1';
    wait for CLOCK_PERIOD;
    valid_in <= '0';
    wait for CLOCK_PERIOD*7;

    x<= x"19"; -- 25
    valid_in <= '1';
    wait for CLOCK_PERIOD;
    valid_in <= '0';
    wait for CLOCK_PERIOD*7;

    x<= x"D2"; -- 210
    valid_in <= '1';
    wait for CLOCK_PERIOD;
    valid_in <= '0';
    wait for CLOCK_PERIOD*7;

    x<= x"B2"; -- 178
    valid_in <= '1';
    wait for CLOCK_PERIOD;
    valid_in <= '0';
    wait for CLOCK_PERIOD*7;

    x<= x"51"; -- 81
    valid_in <= '1';
    wait for CLOCK_PERIOD;
    valid_in <= '0';
    wait for CLOCK_PERIOD*7;

    x<= x"F3"; -- 243
    valid_in <= '1';
    wait for CLOCK_PERIOD;
    valid_in <= '0';
    wait for CLOCK_PERIOD*7;


    x<= x"09"; -- 9
    valid_in <= '1';
    wait for CLOCK_PERIOD;
    valid_in <= '0';
    wait for CLOCK_PERIOD*7;

    x<= x"00"; -- 0
    valid_in <= '1';
    wait for CLOCK_PERIOD;
    valid_in <= '0';
    wait for CLOCK_PERIOD*7;

    x<= x"00"; -- 0
    valid_in <= '1';
    wait for CLOCK_PERIOD;
    valid_in <= '0';
    wait for CLOCK_PERIOD*7;

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
