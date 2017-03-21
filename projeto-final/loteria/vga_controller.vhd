---------------------------------------------------------
-- componente: vga_controller
-- descricao: gerador de sincronismo para monitor VGA (800x600)
-- 
-- baseado nos artigos de Fernando Deluno Garcia - Portal Embarcados
-- http://www.embarcados.com.br/controlador-vga-parte-1/
---------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
----------------------------------------------------
-- entidade
entity vga_controller is
    port(
        rst : in std_logic; -- entrada para reiniciar o estado do controlador
        clk : in std_logic; -- entrada de clock (50MHz)
        h_sync : out std_logic; -- sinal de controle vga: h_sync
        v_sync : out std_logic; -- sinal de controle vga: v_sync
        row : out std_logic_vector(9 downto 0); -- indice da linha que esta sendo processada
        col : out std_logic_vector(10 downto 0); -- indice da coluna que esta sendo processada
        disp_en : out std_logic -- indica a regiao ativa do frame
    );
end entity vga_controller;
----------------------------------------------------
architecture behavioral of vga_controller is
-- sinais internos
-- controle horizontal
signal h_cmp1 : std_logic; -- indica que o contador horizontal esta com o valor d
signal h_cmp2 : std_logic; -- indica que o contador horizontal esta com o valor d+e
signal h_cmp3 : std_logic; -- indica que o contador horizontal esta com o valor d+e+b
signal h_cmp4 : std_logic;  -- indica que o contador horizontal esta com o valor d+e+b+c
signal h_sync_next : std_logic; -- valor de h_sync no proximo pulso de clock
signal h_sync_prior : std_logic; -- ultimo valor atribuido em h_sync
signal h_dataon_next : std_logic; -- indica que o contador horizontal esta na regiao ativa
signal h_dataon_prior : std_logic; -- ultimo valor atribuido em h_dataon
signal h_count_next : std_logic_vector(10 downto 0); -- proximo valor do contador horizontal
signal h_count_prior : std_logic_vector(10 downto 0); -- valor atual do contador horizontal
-------------------------------
-- controle vertical
signal v_cmp1 : std_logic; -- indica que o contador vertical esta com o valor r
signal v_cmp2 : std_logic; -- indica que o contador vertical esta com o valor r+s
signal v_cmp3 : std_logic;  -- indica que o contador vertical esta com o valor r+s+p
signal v_cmp4 : std_logic; -- indica que o contador vertical esta com o valor r+s+p+q
signal v_sync_next : std_logic; -- valor de v_sync no proximo pulso de clock
signal v_sync_prior : std_logic; -- ultimo valor atribuido em v_sync
signal v_dataon_next : std_logic; -- indica que o contador vertical esta na regiao ativa
signal v_dataon_prior : std_logic; -- ultimo valor atribuido em v_dataon
signal v_count_next : std_logic_vector(9 downto 0); -- proximo valor do contador vertical
signal v_count_prior : std_logic_vector(9 downto 0); -- valor atual do contador vertical

-------------------------------
begin
    -------------------------------
    -- sinais de controle do modulo vga
    h_sync <= h_sync_prior;
    v_sync <= v_sync_prior;
    row <= v_count_prior;
    col <= h_count_prior;
    disp_en <= h_dataon_prior and v_dataon_prior;
    
    -------------------------------
    -- atualiza o sinal de saida dos ffd conforme o 
    -- sinal de clock/reset
    process(clk, rst)
    begin
        if (rst = '1') then
            h_count_prior <= (others => '0');
            v_count_prior <= (others => '0');
            h_sync_prior <= '0';
            v_sync_prior <= '0';
            h_dataon_prior <= '0';
            v_dataon_prior <= '0';
        elsif rising_edge(clk) then
            -- contadores
            h_count_prior <= h_count_next;
            v_count_prior <= v_count_next;
            --sinais de sincronismo
            h_sync_prior <= h_sync_next;
            v_sync_prior <= v_sync_next;
            h_dataon_prior <= h_dataon_next;
            v_dataon_prior <= v_dataon_next;
        end if;
    end process;
    
    -------------------------------
    -- contadores
    -- contador - horizontal
    -- o contador e reiniciado apos 1040 pulsos
    h_count_next <= (others => '0') when h_cmp4 = '1' else
                   h_count_prior + 1;
    
    -- contador - vertical
    -- o contador e reiniciado apos 666 pulsos
    -- o contador e incrementado somente apos a finalizacao de uma linha
    v_count_next <= (others => '0') when v_cmp4 = '1' else
                   v_count_prior + 1 when h_cmp4 = '1' else
                   v_count_prior;
                        
    -------------------------------
    --comparadores
    -- contador: d = 800
    h_cmp1 <= '1' when h_count_prior = 799 else '0';
    -- contador: d + e = 800 + 56 = 856
    h_cmp2 <= '1' when h_count_prior = 855 else '0';
    -- contador: d + e + b = 800 + 56 + 120 = 976
    h_cmp3 <= '1' when h_count_prior = 975 else '0';
    -- contador: d + e + b + c = 800 + 56 + 120 + 64 = 1040
    h_cmp4 <= '1' when h_count_prior = 1039 else '0';
    -- contador: r = 600
    v_cmp1 <= '1' when v_count_prior = 599 else '0';
    -- contador: r + s = 600 + 37 = 637
    v_cmp2 <= '1' when v_count_prior = 636 else '0';
    -- contador: r + s + p = 600 + 37 + 6 = 643
    v_cmp3 <= '1' when v_count_prior = 642 else '0';
    -- contador: r + s + p + q = 600 + 37 + 6 + 23 = 666
    v_cmp4 <= '1' when v_count_prior = 665 else '0';
    
    -------------------------------
    -- valores de entrada dos ffd
    
    -- sincronizacao - horizontal
    -- h_sync = 0 apos 856 pulsos e permanece em zero ate 976 pulsos
    h_sync_next <= '0' when h_cmp2 = '1' else -- reset
                  '1' when h_cmp3 = '1' else --set
                  h_sync_prior; -- memoria
    
    -- sincronizacao vertical
    -- v_sync = 0 apos 637 pulsos e permanece em zero ate 643 pulsos  
    v_sync_next <= '0' when v_cmp2 = '1' else -- reset
                  '1' when v_cmp3 = '1' else --set
                  v_sync_prior; -- memoria
    
    -- regiao ativa - horizontal
    h_dataon_next <= '0' when h_cmp1 = '1' else -- reset
                    '1' when h_cmp4 = '1' else --set
                    h_dataon_prior; -- memoria

    -- regiao ativa - vertical
    v_dataon_next <= '0' when v_cmp1 = '1' else -- reset
                    '1' when v_cmp4 = '1' else --set
                    v_dataon_prior; -- memoria
    
end architecture behavioral;
