library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
--use IEEE.numeric_std.ALL;

entity dual_sector is
  generic (
        coeff1 : std_logic_vector(7 downto 0) := x"01";
        coeff2 : std_logic_vector(7 downto 0) := x"03";
        coeff3 : std_logic_vector(7 downto 0) := x"05";
        coeff4 : std_logic_vector(7 downto 0) := x"07";
        coeff5 : std_logic_vector(7 downto 0) := x"02";
        coeff6 : std_logic_vector(7 downto 0) := x"04";
        coeff7 : std_logic_vector(7 downto 0) := x"06";
        coeff8 : std_logic_vector(7 downto 0) := x"08"
    );
   port (
       rst   : in  std_logic;
       clk   : in  std_logic;
       x1 : in std_logic_vector(7 downto 0);
       x2 : in std_logic_vector(7 downto 0);
       valid_in : in std_logic;
       valid_out : out std_logic;
       y : out std_logic_vector(18 downto 0)
    );
end dual_sector;

architecture structural of dual_sector is
    type x_type is array (3 downto 0) of std_logic_vector (7 downto 0);
    signal x_int : x_type;

    type sum_type is array (3 downto 0) of std_logic_vector (18 downto 0);
    signal sum_int : sum_type;

    signal starting_sum : std_logic_vector(18 downto 0) := (others => '0');
    signal x_dot : std_logic_vector(7 downto 0);
        signal valid_flags : std_logic_vector(3 downto 0);


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
          valid_out : out std_logic;
          y : out std_logic_vector(18 downto 0);
          x_dot : out std_logic_vector(7 downto 0)
       );
  end component;

begin

  sector_odd_x : sector
  generic map (
      coeff1 => coeff1,
      coeff2 => coeff2,
      coeff3 => coeff3,
      coeff4 => coeff4
  )
  port map (
      rst=>rst,
      clk=>clk,
      x => x1,
      x_dot => x_dot,
      valid_in=>valid_in,
      valid_out=>valid_flags(0),
      y => sum_int(0)
  );

  sector_even_x : sector
  generic map (
      coeff1 => coeff5,
      coeff2 => coeff6,
      coeff3 => coeff7,
      coeff4 => coeff8
  )
  port map (
      rst=>rst,
      clk=>clk,
      x => x2,
      valid_in=>valid_in,
      valid_out=>valid_flags(1),
      y => sum_int(1)
  );

  counter : process(clk, rst)
  begin
    if rst = '0' then
      valid_out <= '0';
      y <= (others => '0');
    elsif rising_edge(clk) then
      y <= sum_int(0) + sum_int(1);
      valid_out <= valid_flags(0) and valid_flags(1);
    end if;
  end process;

end architecture;
