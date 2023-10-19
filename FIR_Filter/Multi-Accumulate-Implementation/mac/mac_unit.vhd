library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity MAC_unit is
  generic (
           SIZEIN  : natural := 16; -- width of the inputs
           SIZEOUT : natural := 40  -- width of the output
          );
  port (
        pulse : in std_logic;
        counter     : in std_logic_vector(2 downto 0);
        ce          : in std_logic;
        sload       : in  std_logic;
        a           : in  std_logic_vector(SIZEIN-1 downto 0);
        b           : in  std_logic_vector(SIZEIN-1 downto 0);
        accum_out   : out std_logic_vector(SIZEOUT-1 downto 0);
        valid_out : out std_logic := '0'
      );
end entity;

architecture rtl of MAC_unit is

signal old_result : std_logic_vector(SIZEOUT-1 downto 0) := (others => '0');

begin

process (pulse)
 begin
  if ce = '1' then

    if counter = 7 then
      valid_out <= '1';
    else
      valid_out <= '0';
    end if;
    if sload = '1' then
      old_result <= "000" & a*b;
    else
      old_result <= old_result + a * b;
    end if;
  end if;
end process;

accum_out <= old_result;

end rtl;
