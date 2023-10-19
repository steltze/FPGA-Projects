library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity cu_new is
  port (
      rst     : in  std_logic;
      clk     : in  std_logic;
      valid_in : in  std_logic;
      mac_init : out std_logic;
      we : out std_logic;
      en : out std_logic;
      rom_address : out std_logic_vector(2 downto 0);
      ram_address : out std_logic_vector(2 downto 0)
    );
end cu_new;

architecture rtl of cu_new is
   signal counter : std_logic_vector(2 downto 0) := (others => '0');
   signal transient_state: std_logic_vector(2 downto 0) := (others => '0');
   signal rom_address_reg, ram_address_reg : std_logic_vector(2 downto 0);
   signal en_reg, mac_init_reg, we_reg : std_logic;

   signal cout_reg : std_logic;
   signal sum_reg : std_logic_vector(2 downto 0);

   component up_counter is
   port(
        clk, rst, count_en : in std_logic;
        cout : out std_logic;
        sum : out std_logic_vector(2 downto 0)
   );
 end component;
begin

  counter_aaaaaaaaaaaaaaaaaaaaaa : up_counter
    port map (
      clk=>clk,
      rst=>rst,
      count_en=>valid_in,
      cout=>cout_reg,
      sum=>sum_reg
    );

  control : process (clk, rst)
  begin
    if rst = '0' then
      rom_address_reg <= (others => '0');
      ram_address_reg <= (others => '0');
      en <= '0';
      mac_init <= '1'; -- initialize mac to zero
      we <= '0';
    elsif falling_edge(clk) then
      if (valid_in = '0') then
        en <= '0';
        we <= '0';
      else
        en <= '1';
        if transient_state < 7 then
          mac_init <= cout_reg;
          transient_state <= transient_state + 1;
          rom_address_reg <= 7 - sum_reg;
          ram_address_reg <= sum_reg;
          we <= '1';
        else
          we <= cout_reg;
          mac_init <= cout_reg;
          rom_address_reg <= sum_reg;
          ram_address_reg <= sum_reg;

        end if;
      end if;
    end if;
  end process;

    rom_address <= rom_address_reg; 
    ram_address <= ram_address_reg;        
end architecture;
