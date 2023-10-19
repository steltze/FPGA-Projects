library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
-- use ieee.numeric_std.all;

entity MAC_unit_tb is
end entity;

architecture bench of MAC_unit_tb is
component MAC_unit
  generic (
           SIZEIN  : natural := 9; -- width of the inputs
           SIZEOUT : natural := 40  -- width of the output
          );
  port (
        clk         : in std_logic;
        ce          : in std_logic;
        sload       : in  std_logic;
        a           : in  std_logic_vector (SIZEIN-1 downto 0);
        b           : in  std_logic_vector (SIZEIN-1 downto 0);
        accum_out   : out std_logic_vector (SIZEOUT-1 downto 0);
        valid_out : out std_logic
      );
end component;

signal clk, sload, ce, valid_out : std_logic;
signal a : std_logic_vector(7 downto 0);
signal b : std_logic_vector(7 downto 0);
signal accum_out : std_logic_vector(18 downto 0);

constant CLOCK_PERIOD : time := 10 ns;

begin
 uut : MAC_unit
  generic map (
                SIZEIN =>   8, -- width of the inputs
                SIZEOUT =>  19  -- width of the output
          )
  port map (
            clk => clk,
            ce => ce,
            sload => sload,
            a => a,
            b => b,
            accum_out => accum_out,
            valid_out=>valid_out
           );


stimulus: process
	begin
--	wait for CLOCK_PERIOD/2;
    sload<='1';
    ce<='0';
    a<="00000000";
    b<="00000000";
    wait for CLOCK_PERIOD*2;
    
    
--    ce<='1';
    sload<='0';
    wait for CLOCK_PERIOD;
    
    ce<='1';
    a<="00000001";
    b<="00000001";
    wait for CLOCK_PERIOD;

    a<="00000010";
    b<="00000001";
    wait for CLOCK_PERIOD;

    a<="00000011";
    b<="00000001";
    wait for CLOCK_PERIOD;
    
    ce <= '0';
    a<="00000100";
    b<="00000001";
    wait for CLOCK_PERIOD;
    
    ce <= '1';
    a<="00000100";
    b<="00000001";
    wait for CLOCK_PERIOD;

    a<="00000101";
    b<="00000011";
    wait for CLOCK_PERIOD;
    
    a<="00000110";
    b<="00001001";
    wait for CLOCK_PERIOD;

    a<="00000111";
    b<="00000001";
    wait for CLOCK_PERIOD;

    a<="00000001";
    b<="00000001";
    wait for CLOCK_PERIOD;

    sload<='1';
        a<="00000010";
    b<="00000010";
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
