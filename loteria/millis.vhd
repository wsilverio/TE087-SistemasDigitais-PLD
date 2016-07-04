---------------------------------------------------------
-- componente: millis
-- descricao: gera borda de subida a cada 1ms
--            entrada @50MHz
---------------------------------------------------------
-- bibliotecas
library ieee;
use ieee.std_logic_1164.all;
-- portas
entity millis is
    port(
        rst   : in std_logic; -- reset
        clk   : in std_logic; -- entrada @50MHz
        output : out std_logic); -- saida @1kHz: T=1ms
end millis;

-- hardware
architecture behavioral of millis is 
    signal sig_milli : std_logic := '0'; -- sinal intermediario
begin
    process(clk, rst)
        variable counter : integer range 0 to 25_000:= 0; -- contador
    begin
        if(rst='1') then
            counter := 0; -- reset
        elsif(clk'event and clk='1') then
            counter := counter + 1; -- incremento a cada borda de subida
            if(counter = 25_000) then
                sig_milli <= sig_milli xor '1'; -- inverte o estado a cada 0,5ms
                counter := 0; -- reinicia a contagem
            end if;
        end if;
    end process;
    
    output <= sig_milli; -- atribui o sinal a saida
    
end behavioral;
