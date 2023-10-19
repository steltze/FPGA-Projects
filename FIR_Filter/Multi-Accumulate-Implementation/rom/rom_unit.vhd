library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;


entity ROM_unit is
	 generic (
		coeff_width : integer := 8	--- width of coefficients (bits)
	 );

		Port (
				counter     : in std_logic_vector(2 downto 0);
		  	en : in  STD_LOGIC;				--- operation enable
		    addr : in  STD_LOGIC_VECTOR (2 downto 0) := "000";			-- memory address
		    rom_out : out  STD_LOGIC_VECTOR (coeff_width-1 downto 0)
			);	-- output data
end ROM_unit;

architecture Behavioral of ROM_unit is

    type rom_type is array (7 downto 0) of std_logic_vector (coeff_width-1 downto 0);
    signal rom : rom_type:= ("00001000", "00000111", "00000110", "00000101",
														 "00000100", "00000011", "00000010", "00000001");      				 -- initialization of rom with user data

    signal rdata : std_logic_vector(coeff_width-1 downto 0) := (others => '0');
begin

    process (counter)
    begin
        if (en = '1') then
            rom_out <= rom(conv_integer(addr));
        end if;
    end process;


end Behavioral;
