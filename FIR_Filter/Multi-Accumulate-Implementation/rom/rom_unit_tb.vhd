library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity ROM_unit_tb is
end entity;

architecture bench of ROM_unit_tb is
component ROM_unit is
  generic (
   coeff_width : integer := 8	--- width of coefficients (bits)
  );

   Port (
       clk : in  STD_LOGIC;
       en : in  STD_LOGIC;				--- operation enable
       addr : in  STD_LOGIC_VECTOR (2 downto 0);			-- memory address
       rom_out : out  STD_LOGIC_VECTOR (coeff_width-1 downto 0)
     );	-- output data
end component;

signal clk  :  std_logic;
signal en    :  std_logic;
signal addr  :  std_logic_vector(2 downto 0);
signal rom_out  :  STD_LOGIC_VECTOR (7 downto 0);

constant CLOCK_PERIOD : time := 10 ns;

begin
uut: ROM_unit
--  generic map (coeff_width => 8)
  port map(
  		clk=>clk,
      en=>en,
      addr=>addr,
      rom_out=>rom_out
  	);

stimulus: process
	begin
    en<='0';
    addr<="111";
    wait for CLOCK_PERIOD*2;

    en<='1';
--    addr<="000";
    wait for CLOCK_PERIOD*2;
    addr<="001";
    wait for CLOCK_PERIOD*2;
    addr<="010";
    wait for CLOCK_PERIOD*2;
    addr<="011";
    wait for CLOCK_PERIOD*2;


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
