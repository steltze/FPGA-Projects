library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity filter is
   port (
      rst   : in  std_logic;
      clk   : in  std_logic;
      x : in std_logic_vector(7 downto 0);
      valid_in : in std_logic;
      valid_out : out std_logic;
      y : out std_logic_vector(18 downto 0) := (others => '0')
    );
end filter;

architecture structural of filter is
    type x_type is array (6 downto 0) of std_logic_vector (7 downto 0);
    signal x_int : x_type;
    type sum_type is array (6 downto 0) of std_logic_vector (18 downto 0);
    signal sum_int : sum_type := (others => (others => '0'));

    type out_type is array (7 downto 0) of std_logic_vector (18 downto 0);
    signal out_int : out_type := (others => (others => '0'));

    type coeff_type is array (7 downto 0) of std_logic_vector (7 downto 0);
    signal coeff : coeff_type := ("00001000", "00000111", "00000110", "00000101", "00000100", "00000011", "00000010",
                             "00000001");
    signal starting_sum, y_reg : std_logic_vector(18 downto 0) := (others => '0');

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

  component ending_unit is
    port (
        rst   : in  std_logic;
        clk   : in  std_logic;

        x : in std_logic_vector(7 downto 0);
        coeff : in std_logic_vector(7 downto 0);
        prev_sum : in std_logic_vector(18 downto 0);

        total_sum : out std_logic_vector(18 downto 0) -- 16+1 bits
      );
  end component;

  component DFF_19bit is
port(
		D: in std_logic_vector(18 downto 0);
		valid_in : in std_logic;
		clk: in std_logic;
		rst: in std_logic;
		S: out std_logic_vector(18 downto 0)
	);
end component;

begin

  stage_1 : unit
  port map (
      rst=>rst,
      clk=>clk,
      x => x,
      valid_in=>valid_in,
      coeff => coeff(0),
      prev_sum => starting_sum,
      x_dot => x_int(0),
      total_sum => sum_int(0)
  );

    stage_2 : unit
  port map (
      rst=>rst,
      clk=>clk,
      valid_in=>valid_in,
      x => x_int(0),
      coeff => coeff(1),
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
      coeff => coeff(2),
      prev_sum => sum_int(1),
      x_dot => x_int(2),
      total_sum => sum_int(2)
  );

    stage_4 : unit
  port map (
      rst=>rst,
      clk=>clk,
      valid_in=>valid_in,
      x => x_int(2),
      coeff => coeff(3),
      prev_sum => sum_int(2),
      x_dot => x_int(3),
      total_sum => sum_int(3)
  );

    stage_5 : unit
  port map (
      rst=>rst,
      clk=>clk,
      valid_in=>valid_in,
      x => x_int(3),
      coeff => coeff(4),
      prev_sum => sum_int(3),
      x_dot => x_int(4),
      total_sum => sum_int(4)
  );

    stage_6 : unit
  port map (
      rst=>rst,
      clk=>clk,
      valid_in=>valid_in,
      x => x_int(4),
      coeff => coeff(5),
      prev_sum => sum_int(4),
      x_dot => x_int(5),
      total_sum => sum_int(5)
  );

    stage_7 : unit
  port map (
      rst=>rst,
      clk=>clk,
      valid_in=>valid_in,
      x => x_int(5),
      coeff => coeff(6),
      prev_sum => sum_int(5),
      x_dot => x_int(6),
      total_sum => sum_int(6)
  );

      out_int(0) <= sum_int(6) + coeff(7) * x_int(6);

   register1 : DFF_19bit
  port map (
      D => out_int(0),
      valid_in => valid_in,
      rst=>rst,
      clk=>clk,
      S => out_int(1)
  );
     register2 : DFF_19bit
  port map (
      D => out_int(1),
      valid_in => valid_in,
      rst=>rst,
      clk=>clk,
      S => out_int(2)
  );
     register3 : DFF_19bit
  port map (
      D => out_int(2),
      valid_in => valid_in,
      rst=>rst,
      clk=>clk,
      S => out_int(3)
  );
     register4 : DFF_19bit
  port map (
      D => out_int(3),
      valid_in => valid_in,
      rst=>rst,
      clk=>clk,
      S => out_int(4)
  );

       register5 : DFF_19bit
  port map (
      D => out_int(4),
      valid_in => valid_in,
      rst=>rst,
      clk=>clk,
      S => out_int(5)
  );

       register6 : DFF_19bit
  port map (
      D => out_int(5),
      valid_in => valid_in,
      rst=>rst,
      clk=>clk,
      S => out_int(6)
  );

       register7 : DFF_19bit
  port map (
      D => out_int(6),
      valid_in => valid_in,
      rst=>rst,
      clk=>clk,
      S => out_int(7)
  );

       register8 : DFF_19bit
  port map (
      D => out_int(7),
      valid_in => valid_in,
      rst=>rst,
      clk=>clk,
      S => y
  );





  counter : process(clk, rst)
  variable counter : integer := 0;
  begin
    if rst = '0' then
      valid_out <= '0';
    elsif rising_edge(clk) then
      if (counter < 7 or valid_in = '0') then
        valid_out <= '0';
      else
        valid_out <= '1';
      end if;
      if valid_in = '1' then
        counter := counter + 1;
      end if;
    end if;
  end process;

end architecture;
