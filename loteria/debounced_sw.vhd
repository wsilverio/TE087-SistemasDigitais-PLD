---------------------------------------------------------
-- componente: debounced_sw
-- descricao: aplica metodo de debounce para leitura de "push button"
--
---------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
-------------------------------
-- entidade
entity debounced_sw is
    port(
        clk:        in  std_logic;  -- f=1kHz -> T=1ms
        input:      in  std_logic;  -- entrada
        normal_st:  in  std_logic;  -- estado normal
        output:     out std_logic   -- saida
    );
end debounced_sw;
----------------------------------------------------
architecture Behavioral of debounced_sw is
-------------------------------
constant time_ms : integer := 5; -- 5ms
signal timer : integer range 0 to time_ms := time_ms; -- contador regressivo

type state is(
        wait_press,    -- aguarda pressionamento do botao
        wait_ms_a,     -- debounce A
        wait_release,  -- aguarda botao livre
        wait_ms_b      -- debounce B
    );

signal pr_state : state := wait_press; -- estado atual
signal nx_state : state := wait_press; -- prox. estado
-------------------------------
begin
----------------------------------------------------
	process(clk)
		variable count: integer range 0 to time_ms := 0; -- contador debounce
	begin 
		if (clk'event and clk ='1') then -- borda de subida
			count := count + 1; -- incremento
			if (count > timer) then -- debounce
				pr_state <= nx_state; -- atualiza estado
				count := 0; -- reset da contagem (debounce)
			end if;
		end if;
	end process;
----------------------------------------------------
	process(input, normal_st, pr_state)
	begin 
		case pr_state is 
-------------------------------
            when wait_press => -- aguarda pressionamento do botao
					timer <= 0; -- sem debounce
                    output <= normal_st; -- nao pressionado
                    
					if(input = normal_st) then -- se(botao_nao_pressionado)
					    nx_state <= wait_press; -- permanece estado atual
					else
                        nx_state <= wait_ms_a; -- proximo estado
                    end if;
-------------------------------
			when wait_ms_a => -- debounce A
                    timer <= time_ms; -- atribui tempo de debounce
                    output <= not(normal_st); -- botao pressionado
					nx_state <= wait_release; -- proximo estado
-------------------------------
            when wait_release => -- aguarda botao livre
					timer <= 0; -- sem debounce
                    output <= not(normal_st); -- botao pressionado
					
					if(input = normal_st) then -- se(botao_nao_pressionado)
					    nx_state <= wait_ms_b; -- proximo estado
					else
                        nx_state <= wait_release; -- permanece estado atual
                    end if;                    
-------------------------------
            when wait_ms_b => -- debounce B
					timer <= time_ms; -- atribui tempo de debounce
                    output <= normal_st; -- botao nao pressionado
					nx_state <= wait_press; -- volta para estado inicial
		end case;					
	end process;
----------------------------------------------------
end Behavioral;
