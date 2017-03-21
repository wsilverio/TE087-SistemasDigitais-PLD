---------------------------------------------------------
-- componente: random
-- descricao: Psuedo Random Sequence Generator (PSRG) de 6 bits
-- polinomio: 1+x^5+x^6
---------------------------------------------------------


 
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity random is
    port(
        clk: in std_logic;
        random_num: out std_logic_vector (5 downto 0));   --output vector           
end random;

architecture Behavioral of random is
    begin
    process(clk)
        variable rand_temp: std_logic_vector(5 downto 0):=(5 => '1',others => '0');
        variable temp : std_logic := '0';
        begin
            if(rising_edge(clk)) then
                temp := rand_temp(5) xor rand_temp(4);
                rand_temp(5 downto 1) := rand_temp(4 downto 0);
                rand_temp(0) := temp;
            end if;
                --if para nao fornecer numero de acima de 60 ou igual a zero
	 	if (rand_temp /= "000000" and rand_temp /= "111111" and
		    rand_temp /= "111110" and rand_temp /= "111101" and
		    rand_temp /= "111100") then
				 
			random_num <= rand_temp;					
		end if;			 
	 end process;
end Behavioral;