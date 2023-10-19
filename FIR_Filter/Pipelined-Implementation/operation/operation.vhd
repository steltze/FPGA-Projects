library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity operation is
port(
		x: in std_logic_vector(7 downto 0);
    coeff: in std_logic_vector(7 downto 0);
    prev_sum : in std_logic_vector(18 downto 0);
		product : out std_logic_vector(18 downto 0)
	);
end entity;

architecture dataflow of operation is
begin
  	product <= prev_sum + coeff * x;
end architecture;
