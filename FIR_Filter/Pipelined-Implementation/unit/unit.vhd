library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity unit is
  port (
      rst   : in  std_logic;
      clk   : in  std_logic;

      x : in std_logic_vector(7 downto 0);
      valid_in   : in  std_logic;
      coeff : in std_logic_vector(7 downto 0);
      prev_sum : in std_logic_vector(18 downto 0);

      x_dot : out std_logic_vector(7 downto 0);
      total_sum : out std_logic_vector(18 downto 0) 
    );
end unit;

architecture structural of unit is

component DFF_8bit is
  port(
  		D: in std_logic_vector(7 downto 0);
      valid_in : in std_logic;
  		clk: in std_logic;
  		rst: in std_logic;
  		S: out std_logic_vector(7 downto 0)
  	);
  end component;

begin

  x_register : DFF_8bit
  port map (
      D => x,
      valid_in => valid_in,
      rst=>rst,
      clk=>clk,
      S => x_dot
  );
  
  total_sum <= prev_sum + coeff * x;

end architecture;
