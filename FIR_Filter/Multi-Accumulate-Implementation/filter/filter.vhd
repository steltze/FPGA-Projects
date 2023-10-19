library ieee;
use ieee.std_logic_1164.all;

entity filter is
  port (
      rst     : in  std_logic;
      clk     : in  std_logic;
      valid_in : in  std_logic;
      x : in std_logic_vector(7 downto 0);
      filter_output : out std_logic_vector(18 downto 0);
      valid_output : out std_logic
          );
end filter;

architecture structural of filter is
    signal mac_init_reg, we_reg, en_reg, pulse_reg : std_logic;
    signal rom_address_reg, ram_address_reg : std_logic_vector(2 downto 0);
    signal ram_out_reg, rom_out_reg : std_logic_vector(7 downto 0);
    signal counter_reg : std_logic_vector(2 downto 0);

  component cu is
    port (
        rst     : in  std_logic;
        clk     : in  std_logic;
        valid_in : in  std_logic;
        mac_init : out std_logic;
        we : out std_logic;
        en : out std_logic;
        counter : out std_logic_vector(2 downto 0) := (others => '0');
        rom_address : out std_logic_vector(2 downto 0);
        ram_address : out std_logic_vector(2 downto 0)
      );
  end component;

  component MAC_unit is
    generic (
             SIZEIN  : natural := 16; -- width of the inputs
             SIZEOUT : natural := 40  -- width of the output
            );
    port (
        pulse : in std_logic;
          counter : in std_logic_vector(2 downto 0);
          ce          : in std_logic;
          sload       : in  std_logic;
          a           : in  std_logic_vector(SIZEIN-1 downto 0);
          b           : in  std_logic_vector(SIZEIN-1 downto 0);
          accum_out   : out std_logic_vector(SIZEOUT-1 downto 0);
          valid_out : out std_logic := '0'
        );
  end component;

  component RAM_unit is
  	 generic (
  		data_width : integer := 8  				--- width of data (bits)
  	 );
      port (
  				rst  : in std_logic;
  				counter : in std_logic_vector(2 downto 0);
          we   : in std_logic;						--- memory write enable
  			 	en : in std_logic;				--- operation enable
          addr : in std_logic_vector(2 downto 0);			-- memory address
          di   : in std_logic_vector(data_width-1 downto 0);		-- input data
          do   : out std_logic_vector(data_width-1 downto 0); -- output data
          pulse : out std_logic
  			);
  end component;

  component ROM_unit is
  	 generic (
  		coeff_width : integer := 8	--- width of coefficients (bits)
  	 );

  		Port (
  				counter : in std_logic_vector(2 downto 0);
  		  	en : in  STD_LOGIC;				--- operation enable
  		    addr : in  STD_LOGIC_VECTOR (2 downto 0);			-- memory address
  		    rom_out : out  STD_LOGIC_VECTOR (coeff_width-1 downto 0)
  			);	-- output data
  end component;

begin
--------------------------------------------------------------- CU


Control_unit: cu
  port map (
    clk=>clk,
    rst=>rst,
    valid_in=>valid_in,
    mac_init=>mac_init_reg,
    we=>we_reg,
    en=>en_reg,
    counter => counter_reg,
    rom_address=>rom_address_reg,
    ram_address=>ram_address_reg
  );

--------------------------------------------------------------- ROM
mem_ram: RAM_unit
  port map (
      counter => counter_reg,
      rst=>rst,
      we=>we_reg,
      en=>en_reg,
      addr=>ram_address_reg,
      di=>x,
      do=>ram_out_reg,
      pulse => pulse_reg
  );
--------------------------------------------------------------- RAM
mem_rom: ROM_unit
  port map (
      counter => counter_reg,
      en=>en_reg,
      addr=>rom_address_reg,
      rom_out=>rom_out_reg
  );

--------------------------------------------------------------- MAC
mac_u : MAC_unit
 generic map (
               SIZEIN =>   8, -- width of the inputs
               SIZEOUT =>  19  -- width of the output
         )
 port map (
           pulse => pulse_reg,
           counter => counter_reg,
           ce => en_reg,
           sload => mac_init_reg,
           a => rom_out_reg,
           b => ram_out_reg,
           accum_out => filter_output,
           valid_out=>valid_output
          );

end architecture;
