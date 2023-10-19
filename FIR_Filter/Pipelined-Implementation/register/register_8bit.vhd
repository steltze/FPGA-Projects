library IEEE;
use IEEE.std_logic_1164.all;

entity DFF_8bit is
port(
		D: in std_logic_vector(7 downto 0);
		valid_in : in std_logic;
		clk: in std_logic;
		rst: in std_logic;
		S: out std_logic_vector(7 downto 0)
	);
end entity;

architecture behavioral of DFF_8bit is
begin
	process(rst, clk)
	begin
		if rst = '0' then
			S <= (others => '0');
		elsif rising_edge(clk) and valid_in = '1' then
			S <= D;
		end if;
	end process;
end architecture;
