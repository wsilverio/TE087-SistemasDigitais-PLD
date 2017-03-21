library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Desafio is
    Port ( chaves : in  STD_LOGIC_VECTOR (7 downto 0);
           LEDs : out  STD_LOGIC_VECTOR (7 downto 0));
end Desafio;

architecture Behavioral of Desafio is

begin
 
 LEDs <= NOT ( NOT chaves); 

end Behavioral;