library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity cu_tb is
end entity;

architecture bench of cu_tb is
component cu_new is
  port (
      rst     : in  std_logic;
      clk     : in  std_logic;
      valid_in : in  std_logic;
      mac_init : out std_logic;
      we : out std_logic;
      en : out std_logic;
      rom_address : out std_logic_vector(2 downto 0);
      ram_address : out std_logic_vector(2 downto 0)
    );
end component;

signal clk, rst, valid_in  :  std_logic;
signal en, we, mac_init :  std_logic;
signal ram_address : std_logic_vector(2 downto 0);
signal rom_address : std_logic_vector(2 downto 0);

constant CLOCK_PERIOD : time := 10 ns;

begin
uut: cu_new
--  generic map (coeff_width => 8)
  port map(
      rst=>rst,
      clk=>clk,
  	  valid_in=>valid_in,
  	  we=>we,
      mac_init=>mac_init,
      en=>en,
      rom_address=>rom_address,
      ram_address=>ram_address
    );

stimulus: process
	begin
    rst <= '0';
    valid_in<='0';
    wait for CLOCK_PERIOD*2;

    rst <= '1';
    valid_in<='1';
    wait for CLOCK_PERIOD*5;

    valid_in<='0';
    wait for CLOCK_PERIOD*2;

    valid_in<='1';
    wait for CLOCK_PERIOD*20;

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
