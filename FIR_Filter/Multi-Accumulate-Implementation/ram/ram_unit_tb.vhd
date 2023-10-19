library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity RAM_unit_tb is
end entity;

architecture bench of RAM_unit_tb is
component RAM_unit is
  generic (
   data_width : integer := 8  				--- width of data (bits)
  );
   port (
       rst  : in std_logic;
       clk  : in std_logic;
       we   : in std_logic;						--- memory write enable
       en : in std_logic;				--- operation enable
       addr : in std_logic_vector(2 downto 0);			-- memory address
       di   : in std_logic_vector(data_width-1 downto 0);		-- input data
       do   : out std_logic_vector(data_width-1 downto 0) -- output data
     );
end component;

signal clk, rst, we  :  std_logic;
signal en    :  std_logic;
signal addr  :  std_logic_vector(2 downto 0);
signal di, do  :  STD_LOGIC_VECTOR (7 downto 0);

constant CLOCK_PERIOD : time := 10 ns;

begin
uut: RAM_unit
--  generic map (coeff_width => 8)
  port map(
      rst=>rst,
  		clk=>clk,
      we=>we,
      en=>en,
      addr=>addr,
      di=>di,
      do=>do
  	);

stimulus: process
	begin
    rst <= '0';
    en<='0';
    addr<="111";
    di<= x"00";
    we <= '0';
    wait for CLOCK_PERIOD*2;
    
    rst <= '1';
    en<='1';
    we<='1';    
    di<= x"2F"; -- 47
    addr<="001";
    wait for CLOCK_PERIOD;

    we<='0';
    addr<="001";
    wait for CLOCK_PERIOD;

    we<='1';
    di<= x"0D"; -- 13
    addr<="001";
    wait for CLOCK_PERIOD;

    we<='0';
    addr<="000";
    wait for CLOCK_PERIOD;
    
    we<='1';
    di<= x"0F"; -- 15
    addr<="000";
    wait for CLOCK_PERIOD;
    
    en <= '0';
    we<='0';
    addr<="001";
    wait for CLOCK_PERIOD;
    
    we<='1';
    addr<="010";
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
