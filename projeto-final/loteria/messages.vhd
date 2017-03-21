----------------------------------------------------
-- Componente: exibidor de mensagens
-- Descricao: retorna o caracter
--            para as mensagens (inicio e fim)
--
----------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity messages is
  port ( 
          whatCharacter : in integer range 0 to 20; -- caractere solicitado
          message       : in BOOLEAN; -- selecao (msg de inicio ou fim)
          medisplay7seg : out STD_LOGIC_VECTOR (6 downto 0)); -- saida para display
  end messages;
  
architecture Behavioral of messages is
  -- sinais
  signal initialResult, finalResult: STD_LOGIC_VECTOR(6 downto 0) := (OTHERS => '0');

  -- segmentos de cada caractere
  constant I : STD_LOGIC_VECTOR (6 downto 0) := "1001111";
  constant N : STD_LOGIC_VECTOR (6 downto 0) := "1001000";
  constant C : STD_LOGIC_VECTOR (6 downto 0) := "1000110";
  constant O : STD_LOGIC_VECTOR (6 downto 0) := "1000000";
  constant D : STD_LOGIC_VECTOR (6 downto 0) := "0100001";
  constant S : STD_LOGIC_VECTOR (6 downto 0) := "0010010";
  constant R : STD_LOGIC_VECTOR (6 downto 0) := "0101111";
  constant T : STD_LOGIC_VECTOR (6 downto 0) := "0000111";
  constant E : STD_LOGIC_VECTOR (6 downto 0) := "0000110";
  constant F : STD_LOGIC_VECTOR (6 downto 0) := "0001110";
  constant M : STD_LOGIC_VECTOR (6 downto 0) := "1101010";
  constant W : STD_LOGIC_VECTOR (6 downto 0) := "1010101";
  constant ESPACO : STD_LOGIC_VECTOR (6 downto 0) := "1111111";
  constant PROBLEMA : STD_LOGIC_VECTOR (6 downto 0) := "0000000";

begin

  with whatCharacter select
    finalResult <= ESPACO when 0,
                   F when 1,
                   I when 2,
                   M when 3,
                   ESPACO when 4,
                   D when 5,
                   O when 6,
                   ESPACO when 7,
                   S when 8,
                   O when 9,
                   R when 10,
                   T when 11,
                   E when 12,
                   I when 13,
                   O when 14,
                   ESPACO when 15,
                   M when 16,
                   W when 17,
                   ESPACO when others;

  with whatCharacter select
    initialResult <=ESPACO when 0,
                   I when 1,
                   N when 2,
                   I when 3,
                   C when 4,
                   I when 5,
                   O when 6,
                   ESPACO when 7,
                   D when 8,
                   O when 9,
                   ESPACO when 10,
                   S when 11,
                   O when 12,
                   R when 13,
                   T when 14,
                   E when 15,
                   I when 16,
                   O when 17,
                   ESPACO when 18,
                   M when 19,
                   W when 20,
                   ESPACO when others;

     -- retorna caractere correspondente
     with message select
      medisplay7seg <= initialResult when true,
                       finalResult when false;
end Behavioral;
