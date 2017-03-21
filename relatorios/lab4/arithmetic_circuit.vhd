library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; -- operacoes aritmeticas

entity arithmetic_circuit is
    generic(N : INTEGER := 8);
    port(
        A   : in  std_logic_vector(N-1 downto 0);
        B   : in  std_logic_vector(N-1 downto 0);
        CIN : in  std_logic;
        OP  : in  std_logic_vector(2 downto 0);
        Y   : out std_logic_vector(N-1 downto 0);
        COUT: out std_logic
    );
end arithmetic_circuit;

architecture Behavioral of arithmetic_circuit is
    -- recebe soma considerando o sinal
    signal sSoma : signed(N downto 0);
    -- recebe soma desconsiderando o sinal
    signal uSoma : unsigned(N downto 0);
    -- recebe os bits da soma (generica: sig ou unsig)
    signal soma  : std_logic_vector(N downto 0);
    -- recebe CIN no bit 0
    signal vC    : std_logic_vector(N-1 downto 0) := (others => '0');
begin

	vC(0) <= CIN; -- CIN na ultima posicao
    
    -- soma considerando o sinal
    with OP(1 downto 0) select
        sSoma <=
            signed(A)+signed(B)            when "00",
            signed(A)-signed(B)            when "01",
            signed(B)-signed(A)            when "10",
            signed(A)+signed(B)+signed(vC) when others;

    -- soma desconsiderando o sinal
    with OP(1 downto 0) select
        uSoma <=
            unsigned(A)+unsigned(B)              when "00",
            unsigned(A)-unsigned(B)              when "01",
            unsigned(B)-unsigned(A)              when "10",
            unsigned(A)+unsigned(B)+unsigned(vC) when others;

    -- armazena o valor em forma de vetor
    soma <= std_logic_vector(uSoma) when OP(2) = '0' else std_logic_vector(sSoma);
    -- transfere para a saida os N bits
    Y    <= soma(N-1 downto 0);
    -- transfere o carry
    COUT <= soma(N);
    
end Behavioral;

