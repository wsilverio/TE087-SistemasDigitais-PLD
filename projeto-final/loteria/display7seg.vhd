---------------------------------------------------------
-- componente: display 7 seg
-- descricao: decodificador para display de 7 segmentos
---------------------------------------------------------
-- bibliotecas
library ieee;
use ieee.std_logic_1164.all;
-- portas 
entity display7seg is
    port(
        num : in integer range 0 to 9; -- numero entre 0 e 9
        seg : out std_logic_vector(6 downto 0)); -- saida decodificada
end display7seg;
-- hardware 
architecture behavior of display7seg is 
begin
    -- aciona os segmentos 
    -- referente a entrada
	with num select
    seg <=
        "1000000" when 0,
        "1111001" when 1, 
        "0100100" when 2, 
        "0110000" when 3, 
        "0011001" when 4,
        "0010010" when 5,
        "0000011" when 6,
        "1111000" when 7,
        "0000000" when 8,
        "0011000" when others;
end;
