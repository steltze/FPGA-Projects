library ieee;
use ieee.std_logic_1164.all;

entity check is
  generic (N : integer := 128);
  port (
    rst, valid_in, new_image   : in  std_logic;
    clk   : in  std_logic;
    D: in std_logic_vector(7 downto 0);
    R : out std_logic_vector(7 downto 0);
    G : out std_logic_vector(7 downto 0);
    B : out std_logic_vector(7 downto 0);
    valid_out : out std_logic;
    image_finished : out std_logic
    -- image_finished, valid_out : in std_logic
  );
end check;

architecture str of check is
  signal OUT_1, OUT_2, OUT_3, OUT_4, OUT_5, OUT_6, OUT_7, OUT_8, OUT_9 : std_logic_vector(7 downto 0);
  signal color_case_reg : std_logic_vector(1 downto 0);
  signal state_reg : std_logic_vector(3 downto 0);

  component FSM is
    generic (N : integer := 8);
    port (
      valid_in, new_image, clk, rst : in std_logic;
      color_case : out std_logic_vector(1 downto 0);
      state : out std_logic_vector(3 downto 0);
      image_finished, valid_out : out std_logic
    );
  end component;

  component Operations is
    generic (N : integer := 8);
    port (
      clk, rst : in std_logic;
      OUT_1 : in std_logic_vector(7 downto 0);
      OUT_2 : in std_logic_vector(7 downto 0);
      OUT_3 : in std_logic_vector(7 downto 0);
      OUT_4 : in std_logic_vector(7 downto 0);
      OUT_5 : in std_logic_vector(7 downto 0);
      OUT_6 : in std_logic_vector(7 downto 0);
      OUT_7 : in std_logic_vector(7 downto 0);
      OUT_8 : in std_logic_vector(7 downto 0);
      OUT_9 : in std_logic_vector(7 downto 0);
      color_case: in std_logic_vector(1 downto 0);
      state : in std_logic_vector(3 downto 0);
      R : out std_logic_vector(7 downto 0);
      G : out std_logic_vector(7 downto 0);
      B : out std_logic_vector(7 downto 0)
      -- image_finished, valid_out : in std_logic
    );
  end component;

  component ser_to_par is
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
  end component;
begin
  stage_1 : FSM
   generic map (N => N)
    port map(
      valid_in => valid_in,
      new_image => new_image,
      clk => clk,
      rst => rst,
      color_case => color_case_reg,
      state => state_reg,
      image_finished => image_finished,
      valid_out => valid_out
      );

  stage_2 : ser_to_par
   generic map (N => N)
    port map(
        rst=>rst,
        clk=>clk,
        valid_in => valid_in,
        D => D,
        OUT_1 => OUT_1,
        OUT_2 => OUT_2,
        OUT_3 => OUT_3,
        OUT_4 => OUT_4,
        OUT_5 => OUT_5,
        OUT_6 => OUT_6,
        OUT_7 => OUT_7,
        OUT_8 => OUT_8,
        OUT_9 => OUT_9
      );

  stage_3 : Operations
   generic map (N => N)
    port map(
        rst=>rst,
        clk=>clk,
        OUT_1 => OUT_1,
        OUT_2 => OUT_2,
        OUT_3 => OUT_3,
        OUT_4 => OUT_4,
        OUT_5 => OUT_5,
        OUT_6 => OUT_6,
        OUT_7 => OUT_7,
        OUT_8 => OUT_8,
        OUT_9 => OUT_9,
        color_case => color_case_reg,
        state => state_reg,
        R => R,
        G => G,
        B => B
      );

end architecture;
