library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity desafio2 is
    Port ( chaves : in  STD_LOGIC_VECTOR (7 downto 0);
           LEDs : out  STD_LOGIC_VECTOR (7 downto 0));
end desafio2;

architecture Behavioral of desafio2 is

begin

LEDs(3 downto 0) <= chaves(3 downto 0) and chaves(7 downto 4);
LEDs(7 downto 4) <= chaves(3 downto 0) or chaves(7 downto 4);

end Behavioral;

