library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Operations is
  generic (N : integer := 8);
  port (
    clk, rst : in std_logic;
    OUT_1 : in std_logic_vector(7 downto 0);
    OUT_2 : in std_logic_vector(7 downto 0);
    OUT_3 : in std_logic_vector(7 downto 0);
    OUT_4 : in std_logic_vector(7 downto 0);
    OUT_5 : in std_logic_vector(7 downto 0);
    OUT_6 : in std_logic_vector(7 downto 0);
    OUT_7 : in std_logic_vector(7 downto 0);
    OUT_8 : in std_logic_vector(7 downto 0);
    OUT_9 : in std_logic_vector(7 downto 0);
    color_case: in std_logic_vector(1 downto 0);
    state : in std_logic_vector(3 downto 0);
    R : out std_logic_vector(7 downto 0);
    G : out std_logic_vector(7 downto 0);
    B : out std_logic_vector(7 downto 0)
    -- image_finished, valid_out : in std_logic
  );
end Operations;

architecture str of Operations is
    signal R_reg, G_reg, B_reg : std_logic_vector(9 downto 0);

begin

  R <= R_reg(7 downto 0);
  G <= G_reg(7 downto 0);
  B <= B_reg(7 downto 0);

  process(OUT_1, OUT_2, OUT_3, OUT_4, OUT_5, OUT_6, OUT_7, OUT_8, OUT_9, color_case, state)
  begin
--    if rst = '0' then
--      R <= (others => '0');
--      G <= (others => '0');
--      B <= (others => '0');
--    else
      case state is
        when "0000" =>
            R_reg <= std_logic_vector(shift_right(unsigned(("00" & OUT_2)), 1));
            G_reg <= ("00" & OUT_5);
            B_reg <= std_logic_vector(shift_right(unsigned(("00" & OUT_4)), 1));
        when "0001" =>
          if color_case = "00" then
            R_reg <= std_logic_vector(shift_right(unsigned(("00" & OUT_2)), 1));
            G_reg <= ("00" & OUT_5);
            B_reg <= std_logic_vector(shift_right(unsigned(("00" & OUT_6)), 1));
          else
            R_reg <= std_logic_vector(shift_right(unsigned(("00" & OUT_3)), 2));
            G_reg <= std_logic_vector(shift_right(unsigned((("00" & OUT_2) + ("00" & OUT_6))), 2));
            B_reg <= ("00" & OUT_5);
          end if;

        when "0010" =>
          if color_case = "00" then
            R_reg <= std_logic_vector(shift_right(unsigned(("00" & OUT_8)), 1));
            G_reg <= ("00" & OUT_5);
            B_reg <= std_logic_vector(shift_right(unsigned(("00" & OUT_4)), 1));
          elsif color_case = "01" then
            R_reg <= std_logic_vector(shift_right(unsigned(("00" & OUT_4)), 1));
            G_reg <= ("00" & OUT_5);
            B_reg <= std_logic_vector(shift_right(unsigned(("00" & OUT_8)), 1));
          elsif color_case = "10" then
            R_reg <= std_logic_vector(shift_right(unsigned(("00" & OUT_7)), 2));
            G_reg <= std_logic_vector(shift_right(unsigned((("00" & OUT_4) + ("00" & OUT_8))), 2));
            B_reg <= ("00" & OUT_5);
          else
            R_reg <= ("00" & OUT_5);
            G_reg <= std_logic_vector(shift_right(unsigned((("00" & OUT_4) + ("00" & OUT_8))), 2));
            B_reg <= std_logic_vector(shift_right(unsigned(("00" & OUT_7)), 2));
          end if;

        when "0011" =>
          if color_case = "00" then
            R_reg <= std_logic_vector(shift_right(unsigned(("00" & OUT_8)), 1));
            G_reg <= ("00" & OUT_5);
            B_reg <= std_logic_vector(shift_right(unsigned(("00" & OUT_6)), 1));
          elsif color_case = "01" then
            R_reg <= std_logic_vector(shift_right(unsigned(("00" & OUT_6)), 1));
            G_reg <= ("00" & OUT_5);
            B_reg <= std_logic_vector(shift_right(unsigned(("00" & OUT_8)), 1));
          elsif color_case = "10" then
            R_reg <= std_logic_vector(shift_right(unsigned(("00" & OUT_9)), 2));
            G_reg <= std_logic_vector(shift_right(unsigned((("00" & OUT_6) + ("00" & OUT_8))), 2));
            B_reg <= ("00" & OUT_5);
          else
            R_reg <= ("00" & OUT_5);
            G_reg <= std_logic_vector(shift_right(unsigned((("00" & OUT_6) + ("00" & OUT_8))), 2));
            B_reg <= std_logic_vector(shift_right(unsigned(("00" & OUT_9)), 2));
          end if;

        when "0100" =>
          if color_case = "00" then
            R_reg <= std_logic_vector(shift_right(unsigned((("00" & OUT_2) + ("00" & OUT_8))), 1));
            G_reg <= ("00" & OUT_5);
            B_reg <= std_logic_vector(shift_right(unsigned(("00" & OUT_6)), 1));
          elsif color_case = "01" then
            R_reg <= std_logic_vector(shift_right(unsigned(("00" & OUT_6)), 1));
            G_reg <= ("00" & OUT_5);
            B_reg <= std_logic_vector(shift_right(unsigned((("00" & OUT_2) + ("00" & OUT_8))), 1));
          elsif color_case = "10" then
            R_reg <= std_logic_vector(shift_right(unsigned((("00" & OUT_3) + ("00" & OUT_9))), 2));
            G_reg <= std_logic_vector(shift_right(unsigned((("00" & OUT_2) + ("00" & OUT_6) + ("00" & OUT_8))), 2));
            B_reg <= ("00" & OUT_5);
          else
            R_reg <= ("00" & OUT_5);
            G_reg <= std_logic_vector(shift_right(unsigned((("00" & OUT_2) + ("00" & OUT_6) + ("00" & OUT_8))), 2));
            B_reg <= std_logic_vector(shift_right(unsigned((("00" & OUT_3) + ("00" & OUT_9))), 2));
          end if;

        when "0101" =>
          if color_case = "00" then
            R_reg <= std_logic_vector(shift_right(unsigned((("00" & OUT_2) + ("00" & OUT_8))), 1));
            G_reg <= ("00" & OUT_5);
            B_reg <= std_logic_vector(shift_right(unsigned(("00" & OUT_4)), 1));
          elsif color_case = "01" then
            R_reg <= std_logic_vector(shift_right(unsigned(("00" & OUT_4)), 1));
            G_reg <= ("00" & OUT_5);
            B_reg <= std_logic_vector(shift_right(unsigned((("00" & OUT_2) + ("00" & OUT_8))), 1));
          elsif color_case = "10" then
            R_reg <= std_logic_vector(shift_right(unsigned((("00" & OUT_1) + ("00" & OUT_7))), 2));
            G_reg <= std_logic_vector(shift_right(unsigned((("00" & OUT_2) + ("00" & OUT_4) + ("00" & OUT_8))), 2));
            B_reg <= ("00" & OUT_5);
          else
            R_reg <= ("00" & OUT_5);
            G_reg <= std_logic_vector(shift_right(unsigned((("00" & OUT_2) + ("00" & OUT_4) + ("00" & OUT_8))), 2));
            B_reg <= std_logic_vector(shift_right(unsigned((("00" & OUT_1) + ("00" & OUT_7))), 2));
          end if;

        when "0110" =>
          if color_case = "00" then
            R_reg <= std_logic_vector(shift_right(unsigned(("00" & OUT_2)), 1));
            G_reg <= ("00" & OUT_5);
            B_reg <= std_logic_vector(shift_right(unsigned((("00" & OUT_4) + ("00" & OUT_6))), 1));
          elsif color_case = "01" then
            R_reg <= std_logic_vector(shift_right(unsigned((("00" & OUT_4) + ("00" & OUT_6))), 1));
            G_reg <= ("00" & OUT_5);
            B_reg <= std_logic_vector(shift_right(unsigned(("00" & OUT_2)), 1));
          elsif color_case = "10" then
            R_reg <= std_logic_vector(shift_right(unsigned(((("00" & OUT_1)) + (("00" & OUT_3)))), 2));
            G_reg <= std_logic_vector(shift_right(unsigned((("00" & OUT_2) + ("00" & OUT_4) + ("00" & OUT_6))), 2));
            B_reg <= ("00" & OUT_5);
          end if;
        when "0111" =>
          if color_case = "00" then
            R_reg <= std_logic_vector(shift_right(unsigned(("00" & OUT_8)), 1));
            G_reg <= ("00" & OUT_5);
            B_reg <= std_logic_vector(shift_right(unsigned((("00" & OUT_4) + ("00" & OUT_6))), 1));
          elsif color_case = "01" then
            R_reg <= std_logic_vector(shift_right(unsigned((("00" & OUT_4) + ("00" & OUT_6))), 1));
            G_reg <= ("00" & OUT_5);
            B_reg <= std_logic_vector(shift_right(unsigned(("00" & OUT_8)), 1));
          elsif color_case = "10" then
            R_reg <= std_logic_vector(shift_right(unsigned((("00" & OUT_7) + ("00" & OUT_9))), 2));
            G_reg <= std_logic_vector(shift_right(unsigned((("00" & OUT_4) + ("00" & OUT_6) + ("00" & OUT_8))), 2));
            B_reg <= ("00" & OUT_5);
          else
            R_reg <= ("00" & OUT_5);
            G_reg <= std_logic_vector(shift_right(unsigned((("00" & OUT_4) + ("00" & OUT_6) + ("00" & OUT_8))), 2));
            B_reg <= std_logic_vector(shift_right(unsigned((("00" & OUT_7) + ("00" & OUT_9))), 2));
          end if;
        when "1000" =>
          if color_case = "00" then
            R_reg <= std_logic_vector(shift_right(unsigned((("00" & OUT_2) + ("00" & OUT_8))), 1));
            G_reg <= ("00" & OUT_5);
            B_reg <= std_logic_vector(shift_right(unsigned((("00" & OUT_4) + ("00" & OUT_6))), 1));
          elsif color_case = "01" then
            R_reg <= std_logic_vector(shift_right(unsigned((("00" & OUT_4) + ("00" & OUT_6))), 1));
            G_reg <= ("00" & OUT_5);
            B_reg <= std_logic_vector(shift_right(unsigned((("00" & OUT_2) + ("00" & OUT_8))), 1));
          elsif color_case = "10" then
            R_reg <= std_logic_vector(shift_right(unsigned((("00" & OUT_1) + ("00" & OUT_3) + ("00" & OUT_7) + ("00" & OUT_9))), 2));
            G_reg <= std_logic_vector(shift_right(unsigned((("00" & OUT_2) + ("00" & OUT_4) + ("00" & OUT_6) + ("00" & OUT_8))), 2));
            B_reg <= ("00" & OUT_5);
          else
            R_reg <= ("00" & OUT_5);
            G_reg <= std_logic_vector(shift_right(unsigned((("00" & OUT_2) + ("00" & OUT_4) + ("00" & OUT_6) + ("00" & OUT_8))), 2));
            B_reg <= std_logic_vector(shift_right(unsigned((("00" & OUT_1) + ("00" & OUT_3) + ("00" & OUT_7) + ("00" & OUT_9))), 2));
          end if;
         when others =>
           R_reg <= (others => '1');
           G_reg <= (others => '1');
           B_reg <= (others => '1');
      end case;

--    end if;
  end process;
end architecture;
