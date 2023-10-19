library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity RAM_unit is
	 generic (
		data_width : integer := 8  				--- width of data (bits)
	 );
    port (
				rst  : in std_logic;
				counter     : in std_logic_vector(2 downto 0);
        we   : in std_logic;						--- memory write enable
			 	en : in std_logic;				--- operation enable
        addr : in std_logic_vector(2 downto 0) := "000";			-- memory address
        di   : in std_logic_vector(data_width-1 downto 0);		-- input data
        do   : out std_logic_vector(data_width-1 downto 0); -- output data
        pulse : out std_logic
			);
end RAM_unit;

architecture Behavioral of RAM_unit is

    type ram_type is array (7 downto 0) of std_logic_vector (data_width-1 downto 0);
    signal RAM : ram_type := (others => (others => '0'));
    signal pulse_reg : std_logic := '0';

begin
    
    process (counter, rst)
    begin
				if rst = '0' then
						RAM <= (others => (others => '0'));
						pulse_reg <= '0';
        else
            if en = '1' then
                pulse_reg <= not pulse_reg;
                if we = '1' then				-- write operation
										RAM <= RAM(6 downto 0) & di;
                    do <= di;
                else						-- read operation
                    do <= RAM( conv_integer(addr));
                end if;
            end if;
        end if;
    end process;

    pulse <=  pulse_reg;
end Behavioral;
