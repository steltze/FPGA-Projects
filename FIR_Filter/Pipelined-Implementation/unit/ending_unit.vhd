library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity ending_unit is
  port (
      rst   : in  std_logic;
      clk   : in  std_logic;

      x : in std_logic_vector(7 downto 0);
      coeff : in std_logic_vector(7 downto 0);
      prev_sum : in std_logic_vector(18 downto 0);

      -- x_dot : out std_logic_vector(7 downto 0);
      total_sum : out std_logic_vector(18 downto 0) -- 16+1 bits
    );
end ending_unit;

architecture structural of ending_unit is
    -- signal product : std_logic_vector(18 downto 0);

begin

  operations: process(rst, clk)
  begin
  	if rst = '0' then
  		total_sum <= (others => '0');
  	elsif falling_edge(clk) then
  		total_sum <= prev_sum + coeff * x;
  	end if;
  end process;

end architecture;
