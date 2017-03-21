library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity desafio1 is
    generic(N: integer := 30);
     Port (CLK  : in   STD_LOGIC;
           LEDs : out  STD_LOGIC_VECTOR(N-1 downto 0));
end desafio1;

architecture Behavioral of desafio1 is 
    signal counter : std_logic_vector(N-1 downto 0) := (others => '0');
begin

process(CLK)
begin
    if(CLK'EVENT and CLK = '1') then
        counter <= counter + 1;
    end if;
end process;

    LEDs <= counter;

end Behavioral;

