library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;

entity cu is
  port (
      rst     : in  std_logic;
      clk     : in  std_logic;
      valid_in : in  std_logic;
      mac_init : out std_logic;
      we : out std_logic;
      en : out std_logic;
      counter : out std_logic_vector(2 downto 0);
      rom_address : out std_logic_vector(2 downto 0);
      ram_address : out std_logic_vector(2 downto 0)
    );
end cu;

architecture rtl of cu is
   signal counter_reg : std_logic_vector(2 downto 0);

   signal rom_address_reg, ram_address_reg : std_logic_vector(2 downto 0);
   signal en_reg, mac_init_reg, we_reg : std_logic;
begin

  control : process (clk, rst)
  begin
    if (rst = '0') then
      counter_reg <= (others => '0');
      rom_address <= (others => '0');
      ram_address <= (others => '0');
      en <= '0';
      mac_init <= '1'; -- initialize mac to zero
      we <= '0';
    elsif falling_edge(clk) then
      counter_reg <= counter_reg + 1;
      en <= '1';
        rom_address <= counter_reg;
        ram_address <= counter_reg;
        if valid_in = '1' then
          we <= '1';
          mac_init <= '1';
        else
          we <= '0';
          mac_init <= '0';
        end if;
     counter <= std_logic_vector(counter_reg);
    end if;
  end process;

end architecture;
