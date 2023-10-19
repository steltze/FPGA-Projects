library ieee;
use ieee.std_logic_1164.all;

entity FIFO is
  generic (N : integer := 8);
  port (
      rst   : in  std_logic;
      clk   : in  std_logic;
      valid_in   : in  std_logic;
      D: in std_logic_vector(7 downto 0);
      S: out std_logic_vector(7 downto 0)
    );
end FIFO;

architecture structural of FIFO is
  type fifo_array is array (N downto 0) of std_logic_vector(7 downto 0);
  signal DIN: fifo_array;


  component DFF_8bit is
  port(
		D: in std_logic_vector(7 downto 0);
		valid_in   : in  std_logic;
		clk: in std_logic;
		rst: in std_logic;
		S: out std_logic_vector(7 downto 0)
  	);
  end component;

begin
    DIN(0) <= D;
    S <= DIN(N);

  GEN_REG: for I in 0 to N-1 generate
      REGX : DFF_8bit
        port map (
            D => DIN(I),
            valid_in => valid_in, 
            clk => clk, 
            rst => rst, 
            S => DIN(I+1)
          );
   end generate GEN_REG;

end architecture;
