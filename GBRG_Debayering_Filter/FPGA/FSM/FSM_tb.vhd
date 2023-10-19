library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity FSM_tb is
end entity;

architecture bench of FSM_tb is
component FSM is
  generic (N : integer := 8);
  port (
    valid_in, new_image, clk, rst : in std_logic;
    color_case : out std_logic_vector(1 downto 0);
    state : out std_logic_vector(3 downto 0);
    image_finished, valid_out : out std_logic
  );
end component;

signal clk, rst, valid_in, new_image, image_finished, valid_out :  std_logic;
signal color_case: std_logic_vector(1 downto 0);
signal state : std_logic_vector(3 downto 0);

constant CLOCK_PERIOD : time := 10 ns;

begin
uut: FSM
 generic map (N => 4)
  port map(
      rst=>rst,
      clk=>clk,
      valid_in => valid_in,
      new_image => new_image,
      color_case => color_case,
      state => state,
      image_finished => image_finished,
      valid_out => valid_out
    );

stimulus: process
	begin
    rst <= '0';
    wait for CLOCK_PERIOD*2;

    rst <= '1';
    valid_in <= '1';
    new_image <= '1';
    wait for CLOCK_PERIOD;

    new_image <= '0';
    wait for CLOCK_PERIOD;

    -- D <= x"03";
     wait for CLOCK_PERIOD*20;
    --
    -- D <= x"04";
    -- wait for CLOCK_PERIOD;


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
