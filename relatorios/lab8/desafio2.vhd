library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity desafio2 is
    port(   clk    :   in  std_logic;
            output :   out std_logic);
end desafio2;

architecture Behavioral of desafio2 is
	TYPE state IS (high, low);
	signal pr_state: state := low;
	signal nx_state: state := high;
	signal timer: INTEGER RANGE 0 to 40 := 20;
begin
	process(clk)
		variable count: integer range 0 to 40;
	begin 
		if (clk'event and clk ='1') then 
			count := count + 1;
			if (count >= timer) then 
				pr_state <= nx_state;
				count := 0;
			end if;
		end if;
	end process;
		
	process(pr_state)
	begin 
		case pr_state is 
			when high => 
					output <= '1';
					timer <= 20;
					nx_state <= low;
			when others =>
					output <= '0';
					timer <= 40;
					nx_state <= high;
		end case;					
	end process;	
end Behavioral;

