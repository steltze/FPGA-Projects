library ieee;
use ieee.std_logic_1164.all;

entity ser_to_par is
  generic (N : integer := 8);
  port (
      rst   : in  std_logic;
      clk   : in  std_logic;
      valid_in   : in  std_logic;
      D: in std_logic_vector(7 downto 0);
      OUT_1 : out std_logic_vector(7 downto 0);
      OUT_2 : out std_logic_vector(7 downto 0);
      OUT_3 : out std_logic_vector(7 downto 0);
      OUT_4 : out std_logic_vector(7 downto 0);
      OUT_5 : out std_logic_vector(7 downto 0);
      OUT_6 : out std_logic_vector(7 downto 0);
      OUT_7 : out std_logic_vector(7 downto 0);
      OUT_8 : out std_logic_vector(7 downto 0);
      OUT_9 : out std_logic_vector(7 downto 0)
    );
end ser_to_par;

architecture structural of ser_to_par is
  type fifo_tuple is array (3 downto 0) of std_logic_vector(7 downto 0);
  signal D_mid, DFF_mid_1, DFF_mid_2, DFF_mid_3 : fifo_tuple;

  component DFF_8bit is
  port(
  		D: in std_logic_vector(7 downto 0);
      clk: in std_logic;
      valid_in   : in  std_logic;
  		rst: in std_logic;
  		S: out std_logic_vector(7 downto 0)
  	);
  end component;

  component FIFO is
    generic (N : integer := 8);
    port (
        rst   : in  std_logic;
        clk   : in  std_logic;
        valid_in   : in  std_logic;
        D: in std_logic_vector(7 downto 0);
        S: out std_logic_vector(7 downto 0)
      );
  end component;

begin
  D_mid(0) <= D;

  FIFO_regs: for i in 0 to 2 generate
      FIFOX : FIFO
        generic map (N => N)
        port map (
          rst => rst,
          clk => clk,
          valid_in => valid_in,
          D => D_mid(i),
          S => D_mid(i+1)
        );
   end generate FIFO_regs;

   DFF_mid_1(0) <= D_mid(1);
   DFF_mid_2(0) <= D_mid(2);
   DFF_mid_3(0) <= D_mid(3);

   three_DFFs_1: for i in 0 to 2 generate
       DFFs_1 : DFF_8bit
         port map (
          D => DFF_mid_1(i),
          clk => clk,
          valid_in => valid_in,
       		rst => rst,
       		S => DFF_mid_1(i+1)
         );
    end generate three_DFFs_1;

   three_DFFs_2: for i in 0 to 2 generate
       DFFs_2 : DFF_8bit
         port map (
           D => DFF_mid_2(i),
           valid_in => valid_in,
           clk => clk,
           rst => rst,
           S => DFF_mid_2(i+1)
         );
    end generate three_DFFs_2;

  three_DFFs_3: for i in 0 to 2 generate
      DFFs_3 : DFF_8bit
        port map (
          D => DFF_mid_3(i),
          valid_in => valid_in,
          clk => clk,
          rst => rst,
          S => DFF_mid_3(i+1)
        );
   end generate three_DFFs_3;

   OUT_1 <= DFF_mid_1(1);
   OUT_2 <= DFF_mid_1(2);
   OUT_3 <= DFF_mid_1(3);
   OUT_4 <= DFF_mid_2(1);
   OUT_5 <= DFF_mid_2(2);
   OUT_6 <= DFF_mid_2(3);
   OUT_7 <= DFF_mid_3(1);
   OUT_8 <= DFF_mid_3(2);
   OUT_9 <= DFF_mid_3(3);

end architecture;
