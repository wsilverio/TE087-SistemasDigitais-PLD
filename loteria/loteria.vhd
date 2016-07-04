---------------------------------------------------- cabecalho
-- LOTERIA MW
-- Autores: Marco Antonio Rios, Wendeurick Silverio
-- Disciplina: Projetos de Sistemas Digitais em PLD - TE087 - UFPR 2016/1
--
-- Descricao: Sorteia 6 numeros, nao repetidos, entre 01 e 60
-- e os exibe em um monitor VGA (800x600) e nos diplays de 7 segmentos
-- do kit Digilent Nexys2 
---------------------------------------------------- bibliotecas
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
---------------------------------------------------- entidade
entity loteria is
------------------------------- portas
    port(
        -- general
        rst : in std_logic; -- reset quando 1
        clk : in std_logic; -- 50 MHz
        button : in std_logic;
        -- VGA
        r : out std_logic_vector(2 downto 0); -- componente r
        g : out std_logic_vector(2 downto 0); -- componente g
        b : out std_logic_vector(1 downto 0); -- componente b
        h_sync : out std_logic; -- sincronismo horizontal
        v_sync : out std_logic; -- sincronismo vertical
        -- display 7 seg
        seven_seg : out std_logic_vector(6 downto 0); -- display 7 segmentos
        en : out std_logic_vector(3 downto 0);  -- seletor de display
        point : out std_logic); -- apaga o 'ponto' dos displays
end loteria;

---------------------------------------------------- hardware
architecture Behavioral of loteria is

------------------------------- sinais
-- vga
signal sig_row : std_logic_vector(9 downto 0); -- linha processada
signal sig_col : std_logic_vector(10 downto 0); -- coluna processada
signal sig_draw_en : std_logic; -- regiao ativa
signal sig_r : std_logic; -- componente R
signal sig_g : std_logic; -- componente G
signal sig_b : std_logic; -- componente B
----- sorteio
signal sig_selected_number_un : integer range 0 to 9; -- unidades
signal sig_selected_number_dez: integer range 0 to 5; -- dezenas
signal sig_index : integer range 0 to 7; -- indice da maquina de estado do sorteio

------------------------------- componentes
---- sorteador
component sorteador is
		 port(
            clk : in std_logic; -- clock
			button : in std_logic; -- botao sorteio
			rst : in std_logic; -- reset
			selected_number_un : out integer range 0 to 9; -- unidade numero sorteado
			selected_number_dez : out integer range 0 to 5; -- dezena numero sorteado
			seven_seg : out std_logic_vector(6 downto 0); -- display 7 segmentos
			point : out std_logic; -- apaga 'ponto' displays
			index : out integer range 0 to 7; -- indice da maquina de estado do sorteio
			en : out std_logic_vector(3 downto 0)); -- seletor de display
end component sorteador;

-- vga_controller
component vga_controller is
    port(
        rst : in std_logic; -- reset
        clk : in std_logic; -- 50MHz
        h_sync : out std_logic; -- sincronismo horizontal
        v_sync : out std_logic; -- sincronismo vertical
        row : out std_logic_vector(9 downto 0); -- indice linha processada
        col : out std_logic_vector(10 downto 0); -- indice coluna processada
        disp_en : out std_logic); -- regiao ativa
end component vga_controller;

-- pixel_gen 
component vga_pixel_gen is
    port(
        rst : in std_logic; -- entrada para reiniciar o estado do controlador
        clk : in std_logic; -- entrada de clock (50 mhz)
        en : in std_logic; -- indica a regiao ativa do frame
        row : in std_logic_vector(9 downto 0); -- indice da linha que esta sendo processada
        col : in std_logic_vector(10 downto 0); -- indice da coluna que esta sendo processada
        r_out : out std_logic; -- componente r
        g_out : out std_logic; -- componente g
        b_out : out std_logic; -- componente b
		selected_number_un : in integer range 0 to 9; -- unidade ultimo numero sorteado
		selected_number_dez: in integer range 0 to 5; -- dezena ultimo numero sorteado
        index : in integer range 0 to 7); -- indice da maquina de estado do sorteio
end component vga_pixel_gen;

------------------------------- logica
begin

------------------------------- mapeamento
    -- sorteador
    unt_sorteador: sorteador port map(
        clk => clk,
        button => button,
		rst => rst,
		selected_number_un => sig_selected_number_un,
		selected_number_dez => sig_selected_number_dez ,
		seven_seg => seven_seg,
		point => point,
		index => sig_index,
		en => en);        
    -- controlador vga
    unt_vga_ctrl: vga_controller port map(
        rst => rst,
        clk => clk,
        h_sync => h_sync,
        v_sync => v_sync,
        row => sig_row,
        col => sig_col,
        disp_en => sig_draw_en);
    -- gerador de pixels
    unt_vga_pixel_generator: vga_pixel_gen port map(
        rst => rst,
        clk => clk,
        en => sig_draw_en,
        row => sig_row,
        col => sig_col,
        r_out => sig_r,
        g_out => sig_g,
        b_out => sig_b,
        selected_number_un => sig_selected_number_un,
        selected_number_dez => sig_selected_number_dez,
        index => sig_index);

-- atribui 0 ou 1 aos componentes de cada cor
with sig_r select
    r <= (others => '1') when '1', (others => '0') when others;
with sig_g select
    g <= (others => '1') when '1', (others => '0') when others;
with sig_b select
    b <= (others => '1') when '1', (others => '0') when others;

end Behavioral;
---------------------------------------------------- fim
