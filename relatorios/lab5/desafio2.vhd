library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity desafio2 is
     generic(N: integer := 15); -- 2x = 30 bits
     Port ( clk : in  STD_LOGIC;
           LEDs : out  STD_LOGIC_VECTOR (N*2-1 downto 0));
end desafio2;

architecture Behavioral of desafio2 is
    signal LSBcounter: std_logic_vector (N-1 downto 0) := (others => '0');
    signal MSBcounter: std_logic_vector (N-1 downto 0) := (others => '0');
begin

process(clk)
begin
    if(clk'EVENT and clk = '1') then
        LSBcounter <= LSBcounter + '1';
        MSBcounter <= MSBcounter + LSBcounter(N-1);
    end if;
end process;

    LEDs <= MSBcounter & LSBcounter;

end Behavioral;

