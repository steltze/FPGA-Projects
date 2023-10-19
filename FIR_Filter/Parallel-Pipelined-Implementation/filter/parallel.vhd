library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity parallel_filter is
   port (
       rst   : in  std_logic;
       clk   : in  std_logic;
       x1 : in std_logic_vector(7 downto 0);
       x2 : in std_logic_vector(7 downto 0);
       valid_in : in std_logic;
       valid_out : out std_logic;
       y1 : out std_logic_vector(18 downto 0);
       y2 : out std_logic_vector(18 downto 0)
    );
end parallel_filter;

architecture structural of parallel_filter is
    type x_type is array (6 downto 0) of std_logic_vector (7 downto 0);
    signal x_int : x_type;

    type sum_type is array (6 downto 0) of std_logic_vector (18 downto 0);
    signal sum_int : sum_type;

   type coeff_type is array (7 downto 0) of std_logic_vector (7 downto 0);
   signal coeff : coeff_type := ("00001000", "00000111", "00000110", "00000101", "00000100", "00000011", "00000010",
                            "00000001");

    signal starting_sum : std_logic_vector(18 downto 0) := (others => '0');
    signal x_dot : std_logic_vector(7 downto 0);
    
    type out_type is array (4 downto 0) of std_logic_vector (18 downto 0);
    signal out_int1, out_int2 : out_type := (others => (others => '0'));

  component sector is
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

  sector_odd_y_odd_x : sector
  generic map (
      coeff1 => x"01",
      coeff2 => x"03",
      coeff3 => x"05",
      coeff4 => x"07"
  )
  port map (
      rst=>rst,
      clk=>clk,
      x => x1,
      x_dot => x_dot,
      valid_in=>valid_in,
      y => sum_int(0)
  );

  sector_odd_y_even_x : sector
  generic map (
      coeff1 => x"02",
      coeff2 => x"04",
      coeff3 => x"06",
      coeff4 => x"08"
  )
  port map (
      rst=>rst,
      clk=>clk,
      x => x2,
      valid_in=>valid_in,
      y => sum_int(1)
  );

  sector_even_y_odd_x : sector
   generic map (
      coeff1 => x"02",
      coeff2 => x"04",
      coeff3 => x"06",
      coeff4 => x"08"
  )
  port map (
      rst=>rst,
      clk=>clk,
      x => x_dot,
      valid_in=>valid_in,
      y => sum_int(2)
  );

  sector_even_y_even_x : sector
  generic map (
      coeff1 => x"01",
      coeff2 => x"03",
      coeff3 => x"05",
      coeff4 => x"07"
  )
  port map (
      rst=>rst,
      clk=>clk,
      x => x2,
      valid_in=>valid_in,
      y => sum_int(3)
  );
   
  out_int2(0) <= sum_int(2) + sum_int(3); -- y2
  
  y2_register1 : DFF_19bit
  port map (
      D => out_int2(0),
      valid_in => valid_in,
      rst=>rst,
      clk=>clk,
      S => out_int2(1)
  ); 
  
    y2_register2 : DFF_19bit
  port map (
      D => out_int2(1),
      valid_in => valid_in,
      rst=>rst,
      clk=>clk,
      S => out_int2(2)
  ); 
  
    y2_register3 : DFF_19bit
  port map (
      D => out_int2(2),
      valid_in => valid_in,
      rst=>rst,
      clk=>clk,
      S => out_int2(3)
  ); 
  
    y2_register4 : DFF_19bit
  port map (
      D => out_int2(3),
      valid_in => valid_in,
      rst=>rst,
      clk=>clk,
      S => y2
  ); 
  
    y1_register1 : DFF_19bit
  port map (
      D => out_int1(0),
      valid_in => valid_in,
      rst=>rst,
      clk=>clk,
      S => out_int1(1)
  ); 
  
    y1_register2 : DFF_19bit
  port map (
      D => out_int1(1),
      valid_in => valid_in,
      rst=>rst,
      clk=>clk,
      S => out_int1(2)
  ); 
  
    y1_register3 : DFF_19bit
  port map (
      D => out_int1(2),
      valid_in => valid_in,
      rst=>rst,
      clk=>clk,
      S => out_int1(3)
  ); 
  
    y1_register4 : DFF_19bit
  port map (
      D => out_int1(3),
      valid_in => valid_in,
      rst=>rst,
      clk=>clk,
      S => out_int1(4)
  );
  
  out_int1(0) <= sum_int(0) + sum_int(1);
  
  counter : process(clk, rst)
  variable counter : integer := 0;
  begin
    if rst = '0' then
      valid_out <= '0';
    elsif rising_edge(clk) then
      if valid_in = '0' then
        valid_out <= '0';
      else
          if (counter < 4) then
            valid_out <= '0';
          else
            valid_out <= '1';
          end if;
          counter := counter + 1;
        end if;
    end if;
  end process;

  outputs : process(clk, rst)
  begin
    if rst = '0' then
      y1 <= (others => '0');
    elsif rising_edge(clk) then
      y1 <= out_int1(4);
    end if;
  end process;

end architecture;
