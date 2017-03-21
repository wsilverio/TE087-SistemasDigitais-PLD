---------------------------------------------------------
-- componente: vga pixel generator
-- descricao: posiciona os numeros no monitor VGA 800x600
--
---------------------------------------------------------
-- bibliotecas
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
---------------------------------------------------------
-- entidade
entity vga_pixel_gen is
    port(
        rst : in std_logic; -- entrada para reiniciar o estado do controlador
        clk : in std_logic; -- entrada de clock (50 mhz)
        en : in std_logic; -- indica a regiao ativa do frame
        row : in std_logic_vector(9 downto 0); -- indice da linha que esta sendo processada
        col : in std_logic_vector(10 downto 0); -- indice da coluna que esta sendo processada
        r_out : out std_logic; -- componente r
        g_out : out std_logic; -- componente g
        b_out : out std_logic; -- componente b
        selected_number_un : in integer range 0 to 9; -- unidade do numero sorteado
        selected_number_dez: in integer range 0 to 5; -- dezena do numero sorteado
        index : in integer range 0 to 7); -- indice da maquina de estado do sorteio
end vga_pixel_gen;
---------------------------------------------------------
-- hardware
architecture Behavioral of vga_pixel_gen is
-- constantes
    constant MW_NUM_SIZE : integer := 6; -- qtde de posicoes (nums. sorteados)
    constant SCREEN_WIDTH : integer := 800; -- largura da tela
    constant SCREEN_HEIGHT : integer := 600; -- altura da tela
    constant CHAR_WIDTH: integer := 39; -- largura de cada caractere
    constant CHAR_HEIGHT: integer := 57; -- altura de cada caractere
    constant CHAR_NUMS: integer := 10; -- 10 caracteres
    -- constant CHAR_SPACING : integer := 8; -- 8 px espacamento
    constant ROW_TOP : integer := 120; -- linha horizontal superior
    constant ROW_BOTTOM : integer := 420; -- linha horizontal inferior (120+height/2)
    constant COL_LEFT_A : integer := 90; -- primeiro char coluna esquerda (90)
    constant COL_LEFT_B : integer := 138; -- segundo char coluna esquerda (130+spacing)
    constant COL_CENTER_A : integer := 357; -- primeiro char coluna central (90+width/3)
    constant COL_CENTER_B : integer := 405; -- segundo char coluna central (130+spacing+width/3)
    constant COL_RIGHT_A : integer := 624; -- primeiro char coluna direita (90+2*width/3)
    constant COL_RIGHT_B : integer := 672; -- segundo char coluna direita (130+spacing+2*width/3)
-- user types
    subtype digit is integer range 0 to 9; -- digito
    type num_disp is array(0 to 1) of digit; -- dezena, unidade
    type array_num_disp is array(0 to MW_NUM_SIZE-1) of num_disp; -- 6 numeros
-- sinais
    signal rgb : std_logic := '0';
    signal sig_row_stdlv : std_logic_vector(9 downto 0) := (others => '0'); -- linha tipo std_logic_vector
    signal sig_col_stdlv : std_logic_vector(10 downto 0) := (others => '0'); -- coluna tipo std_logic_vector
    signal sig_row : integer range 0 to (SCREEN_HEIGHT-1) := 0; -- linha sendo processada
    signal sig_col : integer range 0 to (SCREEN_WIDTH-1) := 0; -- coluna sendo processada
    signal sig_addr: integer range 0 to (CHAR_NUMS*CHAR_HEIGHT-1); -- endereco buscado na ROM
    signal sig_data: std_logic_vector(0 to CHAR_WIDTH-1); -- 39 px (linha do char)
    signal selected_numbers : array_num_disp; -- memoria de numeros sorteados
    signal sig_index_range : integer range 0 to 8; -- 
    signal sig_index_filled : std_logic_vector(0 to 5) := (others => '0'); -- indices a serem impressos
    
-- componentes
    component font_rom
    port(
      clk: in std_logic; -- clock
      addr: in integer range 0 to (CHAR_NUMS*CHAR_HEIGHT-1); -- endereco a ser buscao (linha da ROM)
      data: out std_logic_vector(CHAR_WIDTH-1 downto 0)); -- linha retornada
    end component;

begin
-- mapeamento componentes
    unt_font_rom: font_rom port map (
        clk => clk,
        addr => sig_addr,
        data => sig_data
    );
    
    -- ativa cada componente somente se
    -- o frame estiver na regiao ativa
    r_out <= rgb and en;
    g_out <= rgb and en;
    b_out <= rgb and en;
       
    -- converte as entradas para inteiro
    sig_row_stdlv <= row when en = '1' else sig_row_stdlv;
    sig_row <= to_integer(unsigned(sig_row_stdlv));
    sig_col_stdlv <= col when en = '1' else sig_col_stdlv;
    sig_col <= to_integer(unsigned(sig_col_stdlv));
    
    -- converte o indice da maquina de estados para o indice dos numeros na tela
    sig_index_range <= (index-1) when ((index > 0) or (index < 7))
                        else sig_index_range;
    
    -- numeros a serem impressos
    with index select
    sig_index_filled <= (others => '0') when 0,
                        "100000" when 1, -- exibe somente primeiro numero
                        "110000" when 2, -- exibe ate o segundo numero
                        "111000" when 3, -- exibe ate o terceiro numero
                        "111100" when 4, -- exibe ate o quarto numero
                        "111110" when 5, -- exibe ate o quinto numero
                        "111111" when others; -- exibe todos os numeros
    
    -- atribui unidade e dezena conforme seu indice correspondente
    gen_numbers: for i in 0 to 5 generate
        selected_numbers(i) <= (selected_number_dez, selected_number_un) when index = (i+1)
                                else selected_numbers(i);
    end generate gen_numbers;
         
    -- busca na ROM o dado equivalente a posicao do pixel conforme cada numero
    process(clk, rst)
    begin
        if(rst = '1') then -- reset
            rgb <= '0';
        elsif rising_edge(clk) then
            -- linha superior
            if((sig_row >= ROW_TOP) and (sig_row < (ROW_TOP+CHAR_HEIGHT))) then
                -- primeiro char esquerda
                if((sig_col >= COL_LEFT_A) and (sig_col < (COL_LEFT_A+CHAR_WIDTH))) then
                    -- busca endereco
                    sig_addr <= selected_numbers(0)(0)*CHAR_HEIGHT + sig_row-ROW_TOP; -- dezena
                    -- busca bit
                    rgb <= sig_data(sig_col-COL_LEFT_A) and sig_index_filled(0);
                -- segundo char esquerda
                elsif((sig_col >= COL_LEFT_B) and (sig_col < (COL_LEFT_B+CHAR_WIDTH))) then
                    -- busca endereco
                    sig_addr <= selected_numbers(0)(1)*CHAR_HEIGHT + sig_row-ROW_TOP; -- unidade
                    -- busca bit
                    rgb <= sig_data(sig_col-COL_LEFT_B) and sig_index_filled(0);
                -- primeiro char centro
                elsif((sig_col >= COL_CENTER_A) and (sig_col < (COL_CENTER_A+CHAR_WIDTH))) then
                    -- busca endereco
                    sig_addr <= selected_numbers(1)(0)*CHAR_HEIGHT + sig_row-ROW_TOP; -- dezena
                    -- busca bit
                    rgb <= sig_data(sig_col-COL_CENTER_A) and sig_index_filled(1);
                -- segundo char centro
                elsif((sig_col >= COL_CENTER_B) and (sig_col < (COL_CENTER_B+CHAR_WIDTH))) then
                    -- busca endereco
                    sig_addr <= selected_numbers(1)(1)*CHAR_HEIGHT + sig_row-ROW_TOP; -- unidade
                    -- busca bit
                    rgb <= sig_data(sig_col-COL_CENTER_B) and sig_index_filled(1);
                -- primeiro char direita
                elsif((sig_col >= COL_RIGHT_A) and (sig_col < (COL_RIGHT_A+CHAR_WIDTH))) then
                    -- busca endereco
                    sig_addr <= selected_numbers(2)(0)*CHAR_HEIGHT + sig_row-ROW_TOP; -- dezena
                    -- busca bit
                    rgb <= sig_data(sig_col-COL_RIGHT_A) and sig_index_filled(2);
                -- segundo char direita
                elsif((sig_col >= COL_RIGHT_B) and (sig_col < (COL_RIGHT_B+CHAR_WIDTH))) then
                    -- busca endereco
                    sig_addr <= selected_numbers(2)(1)*CHAR_HEIGHT + sig_row-ROW_TOP; -- unidade
                    -- busca bit
                    rgb <= sig_data(sig_col-COL_RIGHT_B) and sig_index_filled(2);
                else
                    rgb <= '0'; -- apaga o pixel
                end if;
            -- linha inferior
            elsif((sig_row >= ROW_BOTTOM) and (sig_row < (ROW_BOTTOM+CHAR_HEIGHT))) then
                -- primeiro char esquerda
                if((sig_col >= COL_LEFT_A) and (sig_col < (COL_LEFT_A+CHAR_WIDTH))) then
                    -- busca endereco
                    sig_addr <= selected_numbers(3)(0)*CHAR_HEIGHT + sig_row-ROW_BOTTOM; -- dezena
                    -- busca bit
                    rgb <= sig_data(sig_col-COL_LEFT_A) and sig_index_filled(3);
                -- segundo char esquerda
                elsif((sig_col >= COL_LEFT_B) and (sig_col < (COL_LEFT_B+CHAR_WIDTH))) then
                    -- busca endereco
                    sig_addr <= selected_numbers(3)(1)*CHAR_HEIGHT + sig_row-ROW_BOTTOM; -- unidade
                    -- busca bit
                    rgb <= sig_data(sig_col-COL_LEFT_B) and sig_index_filled(3);
                -- primeiro char centro
                elsif((sig_col >= COL_CENTER_A) and (sig_col < (COL_CENTER_A+CHAR_WIDTH))) then
                    -- busca endereco
                    sig_addr <= selected_numbers(4)(0)*CHAR_HEIGHT + sig_row-ROW_BOTTOM; -- dezena
                    -- busca bit
                    rgb <= sig_data(sig_col-COL_CENTER_A) and sig_index_filled(4);
                -- segundo char centro
                elsif((sig_col >= COL_CENTER_B) and (sig_col < (COL_CENTER_B+CHAR_WIDTH))) then
                    -- busca endereco
                    sig_addr <= selected_numbers(4)(1)*CHAR_HEIGHT + sig_row-ROW_BOTTOM; -- unidade
                    -- busca bit
                    rgb <= sig_data(sig_col-COL_CENTER_B) and sig_index_filled(4);
                -- primeiro char direita
                elsif((sig_col >= COL_RIGHT_A) and (sig_col < (COL_RIGHT_A+CHAR_WIDTH))) then
                    -- busca endereco
                    sig_addr <= selected_numbers(5)(0)*CHAR_HEIGHT + sig_row-ROW_BOTTOM; -- dezena
                    -- busca bit
                    rgb <= sig_data(sig_col-COL_RIGHT_A) and sig_index_filled(5);
                -- segundo char direita
                elsif((sig_col >= COL_RIGHT_B) and (sig_col < (COL_RIGHT_B+CHAR_WIDTH))) then
                    -- busca endereco
                    sig_addr <= selected_numbers(5)(1)*CHAR_HEIGHT + sig_row-ROW_BOTTOM; -- unidade
                    -- busca bit
                    rgb <= sig_data(sig_col-COL_RIGHT_B) and sig_index_filled(5);
                else
                    rgb <= '0'; -- apaga o pixel
                end if;            
            end if;
        end if;
    end process;

end Behavioral;
