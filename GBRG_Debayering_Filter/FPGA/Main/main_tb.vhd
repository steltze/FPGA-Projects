library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
use std.textio.all;

entity check_tb is
end entity;

architecture bench of check_tb is
component check is
  generic (N : integer := 8);
  port (
      rst, valid_in, new_image   : in  std_logic;
      clk   : in  std_logic;
      D: in std_logic_vector(7 downto 0);
      R : out std_logic_vector(7 downto 0);
      G : out std_logic_vector(7 downto 0);
      B : out std_logic_vector(7 downto 0);
      valid_out : out std_logic;
      image_finished : out std_logic
  );
end component;

signal clk, rst, valid_in, new_image, image_finished, valid_out:  std_logic;
signal R, G, B, D : std_logic_vector(7 downto 0);
constant N : integer := 32;
constant CLOCK_PERIOD : time := 10 ns;

begin
uut: check
 generic map (N => N)
  port map(
      rst=>rst,
      clk=>clk,
      valid_in => valid_in,
      new_image => new_image,
      R => R,
      G => G,
      B => B,
      D => D,
      image_finished => image_finished,
      valid_out => valid_out
    );

    reset_proc : process
    variable counter : integer := 0;
    begin
        if counter < 2 then
         rst <= '0';
         counter := counter + 1;
         wait for CLOCK_PERIOD;
        else
          rst <= '1';
          wait;
        end if;
    end process reset_proc;
    
    input_gen : process
            variable counter, rows : integer := 0;
            file inp_file : text open read_mode is "/home/steltze/Stelios/Material/School/8th_Semester/VLSI/Lab5/C/inputs.txt";
            variable inline : line;
            variable in_int : integer range 0 to 255;
        begin
          if rst = '0' then
          
          else
              if rows <= N then
                valid_in <= '1';
                if rows = 0 then
                  new_image <= '1';
                else
                  new_image <= '0';
                end if;
                if counter = 0 then
--                 readline(inp_file, inline);
                 rows := rows + 1;
                end if;
                counter := counter + 1;
                readline(inp_file, inline);
                read(inline, in_int);
                D <= std_logic_vector(to_unsigned(in_int, 8));
                if counter = N then
                 counter := 0;
                end if;
              else
                valid_in <= '1';
              end if;
            end if;
            wait for CLOCK_PERIOD;
        end process input_gen;
    
--    input_gen : process
--            variable counter, rows : integer := 0;
--            file inp_file : text open read_mode is "/home/steltze/Stelios/Material/School/8th_Semester/VLSI/Lab5/C/inputs.txt";
--            variable inline : line;
--            variable in_int : integer range 0 to 255;
--        begin
--          if rst = '0' then
          
--          else
--              if rows <= N then
--                valid_in <= '1';
--                if rows = 0 then
--                  new_image <= '1';
--                else
--                  new_image <= '0';
--                end if;
--                if counter = 0 then
--                 readline(inp_file, inline);
--                 rows := rows + 1;
--                end if;
--                counter := counter + 1;
--                read(inline, in_int);
--                D <= std_logic_vector(to_unsigned(in_int, 8));
--                if counter = N then
--                 counter := 0;
--                end if;
--              else
--                valid_in <= '1';
--              end if;
--            end if;
--            wait for CLOCK_PERIOD;
--        end process input_gen;
    output_gen : process
	    variable counter, rows : integer := 0;
	    variable latency : integer := 0;
		file out_file : text open write_mode is "/home/steltze/Stelios/Material/School/8th_Semester/VLSI/Lab5/C/outputs_vhdl.txt";
		variable outline : line;
		variable out_int : integer;
	begin
	   if rst = '0' then
	   
      else
		  if (rows < N and valid_out = '1') then
			
			write(outline, string'("(R"));  
			out_int := to_integer(unsigned(R));
			write(outline, out_int);
			write(outline, string'(" G"));  
			out_int := to_integer(unsigned(G));
			write(outline, out_int);
			write(outline, string'(" B"));  
			out_int := to_integer(unsigned(B));
			write(outline, out_int);
			write(outline, string'(")"));  
		
		     if counter = N-1 then
                 writeline(out_file, outline);
                 rows := rows + 1;
                 counter := 0;
             else 
             counter := counter + 1;
			end if;
            else
                latency := latency + 1;
		  end if;
		end if;
		wait for CLOCK_PERIOD;
	end process output_gen;
	
	generate_clock : process
begin
	clk <= '0';
	wait for CLOCK_PERIOD/2;
	clk <= '1';
	wait for CLOCK_PERIOD/2;
end process;

--stimulus: process
--	begin
--    rst <= '0';
--    wait for CLOCK_PERIOD*2;

--    rst <= '1';
--    valid_in <= '1';
--    new_image <= '1';
--    D <= x"08";
--    wait for CLOCK_PERIOD;

--    new_image <= '0';
--    D <= x"59";
--    wait for CLOCK_PERIOD;

--    D <= x"7B";
--    wait for CLOCK_PERIOD;
    
--    D <= x"CE";
--    wait for CLOCK_PERIOD;
    
--    D <= x"00";
--    wait for CLOCK_PERIOD;

--    D <= x"4D";
--    wait for CLOCK_PERIOD;

--    D <= x"A5";
--    wait for CLOCK_PERIOD;

--        D <= x"22";
--    wait for CLOCK_PERIOD;
    
--    D <= x"06";
--    wait for CLOCK_PERIOD;

--    D <= x"65";
--    wait for CLOCK_PERIOD;

--            D <= x"7A";
--    wait for CLOCK_PERIOD;
    
--    D <= x"F0";
--    wait for CLOCK_PERIOD;
    

--        D <= x"0A";
--    wait for CLOCK_PERIOD;

--    D <= x"32";
--    wait for CLOCK_PERIOD;

--    D <= x"44";
--    wait for CLOCK_PERIOD;
    
--        D <= x"09";
--    wait for CLOCK_PERIOD;

--     wait for CLOCK_PERIOD*9;
    
--    ---------------------------------
    
--    valid_in <= '1';
--    new_image <= '1';
--    D <= x"01";
--    wait for CLOCK_PERIOD;

--    new_image <= '0';
--    D <= x"02";
--    wait for CLOCK_PERIOD;

--    D <= x"03";
--    wait for CLOCK_PERIOD;
    
--    D <= x"04";
--    wait for CLOCK_PERIOD;
    
--    D <= x"01";
--    wait for CLOCK_PERIOD;

--    D <= x"02";
--    wait for CLOCK_PERIOD;

--    D <= x"03";
--    wait for CLOCK_PERIOD;

--        D <= x"04";
--    wait for CLOCK_PERIOD;
    
--    D <= x"01";
--    wait for CLOCK_PERIOD;

--    D <= x"02";
--    wait for CLOCK_PERIOD;

--    D <= x"03";
--    wait for CLOCK_PERIOD;
    
--    valid_in <= '0';
--    wait for CLOCK_PERIOD*2;
    
--    valid_in <= '1';
--        D <= x"04";
--    wait for CLOCK_PERIOD;
    
--        D <= x"01";
--    wait for CLOCK_PERIOD;

--    D <= x"02";
--    wait for CLOCK_PERIOD;

--    D <= x"03";
--    wait for CLOCK_PERIOD;
    
--        D <= x"04";
--    wait for CLOCK_PERIOD;


--    --
--    -- D <= x"04";
--    -- wait for CLOCK_PERIOD;


--	wait;
--end process;

end bench;
