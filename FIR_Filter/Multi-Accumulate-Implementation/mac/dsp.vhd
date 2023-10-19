library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity macc is
  generic (
           SIZEIN  : natural := 16; -- width of the inputs
           SIZEOUT : natural := 40  -- width of the output
          );
  port (
        clk         : in std_logic;
        ce          : in std_logic;
        sload       : in  std_logic;
        a           : in  std_logic_vector(SIZEIN-1 downto 0);
        b           : in  std_logic_vector(SIZEIN-1 downto 0);
        accum_out   : out std_logic_vector(SIZEOUT-1 downto 0));
end entity;

architecture rtl of macc is
  -- Declare registers for intermediate values
signal sload_reg             : std_logic := '0';
signal adder_out, old_result : std_logic_vector(SIZEOUT-1 downto 0);

begin

process (adder_out, sload_reg)
 begin
  if sload_reg = '1' then
      old_result <= (others => '0');
  else
      -- 'sload' is now active (=low) and opens the accumulation loop.
      -- The accumulator takes the next multiplier output in
      -- the same cycle.
      old_result <= adder_out;
  end if;
end process;

process (clk)
 begin
  if rising_edge(clk) then
    if ce = '1' then
        sload_reg <= sload;
        adder_out <= old_result + a*b;
    end if;
  end if;
end process;

-- Output accumulation result
accum_out <= adder_out;

end rtl;
