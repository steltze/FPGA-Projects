library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
--use IEEE.numeric_std.ALL;

entity sector is
  generic (
        coeff1 : std_logic_vector(7 downto 0) := x"00";
        coeff2 : std_logic_vector(7 downto 0) := x"00";
        coeff3 : std_logic_vector(7 downto 0) := x"00";
        coeff4 : std_logic_vector(7 downto 0) := x"00"
    );
   port (
      rst   : in  std_logic;
      clk   : in  std_logic;
      x : in std_logic_vector(7 downto 0);
      valid_in : in std_logic;
      y : out std_logic_vector(18 downto 0);
      x_dot : out std_logic_vector(7 downto 0)
    );
end sector;

architecture structural of sector is
    type x_type is array (6 downto 0) of std_logic_vector (7 downto 0);
    signal x_int : x_type;

    type sum_type is array (6 downto 0) of std_logic_vector (18 downto 0);
    signal sum_int : sum_type;

    signal starting_sum : std_logic_vector(18 downto 0) := (others => '0');

  component unit is
    port (
        rst   : in  std_logic;
        clk   : in  std_logic;

        x : in std_logic_vector(7 downto 0);
        valid_in   : in  std_logic;
        coeff : in std_logic_vector(7 downto 0);
        prev_sum : in std_logic_vector(18 downto 0);

        x_dot : out std_logic_vector(7 downto 0);
        total_sum : out std_logic_vector(18 downto 0) -- 16+1 bits
      );
  end component;

begin

  stage_1 : unit
  port map (
      rst=>rst,
      clk=>clk,
      x => x,
      valid_in=>valid_in,
      coeff => coeff1,
      prev_sum => starting_sum,
      x_dot => x_int(0),
      total_sum => sum_int(0)
  );

  x_dot <= x_int(0);

    stage_2 : unit
  port map (
      rst=>rst,
      clk=>clk,
      valid_in=>valid_in,
      x => x_int(0),
      coeff => coeff2,
      prev_sum => sum_int(0),
      x_dot => x_int(1),
      total_sum => sum_int(1)
  );

  stage_3 : unit
  port map (
      rst=>rst,
      clk=>clk,
      valid_in=>valid_in,
      x => x_int(1),
      coeff => coeff3,
      prev_sum => sum_int(1),
      x_dot => x_int(2),
      total_sum => sum_int(2)
  );

  counter : process(clk, rst)
  variable counter : integer := 0;
  begin
    if rst = '0' then
      y <= (others => '0');
    elsif rising_edge(clk) and valid_in = '1' then
      y <= sum_int(2) + coeff4 * x_int(2);
    end if;
  end process;

end architecture;
