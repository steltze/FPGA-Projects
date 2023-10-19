library ieee;
use ieee.std_logic_1164.all;

entity FSM is
  generic (N : integer := 8);
  port (
    valid_in, new_image, clk, rst : in std_logic;
    color_case : out std_logic_vector(1 downto 0);
    state : out std_logic_vector(3 downto 0);
    image_finished, valid_out : out std_logic
  );
end FSM;

architecture kappa of FSM is
  signal latency_counter : integer := 0;
  -- signal state, next_state : state_type;

begin
   SYNC_PROC: process (clk, rst)
   variable counter_row, counter_column : integer range 0 to N-1;
   begin
      if rst = '0' then
         state <= "0000";
         color_case <= "00";
         valid_out <= '0';
         counter_row := 0;
         counter_column := 0;
         image_finished <= '0';
         latency_counter <= 0;
   		elsif rising_edge(clk) and valid_in = '1' then
            if new_image = '1' then
              state <= "0000";
              color_case <= "00";
              counter_row := 0;
              counter_column := 0;
              latency_counter <= 1;
              image_finished <= '0';
              valid_out <= '0';
            else

              -- int m_row = row % 2, m_column = column % 2;
              if latency_counter >= N+N+2-1 then
                    valid_out <= '1';
                  if (((counter_row mod 2 = 0) and (counter_column mod 2 = 0))) then
                    color_case <= "00"; -- Green next to to blue
                  elsif (((counter_row mod 2 = 1) and (counter_column mod 2 = 1))) then
                    color_case <= "01"; -- Green next to to red
                  elsif ((counter_row mod 2 = 0) and (counter_column mod 2 = 1)) then
                    color_case <= "10"; -- Blue
                  else
                    color_case <= "11"; -- Red
                  end if;

                  if (counter_row = 0) and (counter_column = 0) then
                    state <= "0000";
                    counter_column := counter_column + 1;
                  elsif (counter_row = 0) and (counter_column = N-1) then
                    state <= "0001";
                    counter_row := counter_row + 1;
                    counter_column := 0;
                  elsif (counter_row = N-1) and (counter_column = 0) then
                    state <= "0010";
                    counter_column := counter_column + 1;
                  elsif (counter_row = N-1) and (counter_column = N-1) then
                    state <= "0011";
--                    counter_row := counter_row + 1;
--                    counter_column := 0;
                  elsif counter_column = N-1 then
                    counter_row := counter_row + 1;
                    counter_column := 0;
                    state <= "0100";
                  elsif counter_column = 0 then
                    state <= "0101";
                    counter_column := counter_column + 1;
                  elsif counter_row = 0 then
                    state <= "0110";
                    counter_column := counter_column + 1;
                  elsif counter_row = N-1 then
                    state <= "0111";
                    counter_column := counter_column + 1;
                  else
                    state <= "1000";
                    counter_column := counter_column + 1;
                  end if;

              end if;
              if latency_counter = N+N+N*N then
                image_finished <= '1';
                valid_out <= '1';
              end if;
              latency_counter <= latency_counter + 1;
             end if;
   		end if;
   end process;

end architecture;
