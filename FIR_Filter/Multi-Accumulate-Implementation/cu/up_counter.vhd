library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity up_counter is
port(
     clk, rst, count_en : in std_logic;
     cout : out std_logic;
     sum : out std_logic_vector(2 downto 0)
);
end entity;

architecture behave of up_counter is
  signal count: std_logic_vector(2 downto 0) := (others=>'0');

begin
process(clk, rst)
begin
  if rst = '0' then
       count <= (others=>'0');
       cout <= '0';
  elsif falling_edge(clk) then
       if count_en = '1' then
         cout <= count(0) and count(1) and count(2);
         count <= count+1;
       end if;
  end if;
  sum <= count;
end process;

end behave;
