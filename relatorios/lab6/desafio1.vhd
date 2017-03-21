library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity desafio1 is
    generic(div_clock_max: integer := 25_000_000); -- 2Hz
    port(
        clk : in std_logic;
        seven_seg : out std_logic_vector(6 downto 0);
        en : out std_logic_vector(3 downto 0)
        );
           
end desafio1;

architecture Behavioral of desafio1 is

    component display7seg
    port(
        num : in integer range 0 to 9;
        seg : out std_logic_vector(6 downto 0));
    end component;
    
    signal sig_count : integer range 0 to 9 := 0;

begin
    
    unt: display7seg port map (
        num => sig_count,
        seg => seven_seg
    );
    
    en <= "1110";
    
    process(clk)
        variable count : integer range 0 to 9;
        variable div_clock : integer range 0 to div_clock_max;
        
    begin
        if(clk'EVENT and clk = '1') then
            div_clock := div_clock + 1;
            if(div_clock = div_clock_max) then
                count := count + 1;
                if(count = 10) then
                    count := 0;
                end if;
                div_clock := 0;
            end if;
        end if;
        
        sig_count <= count;
        
    end process;

end Behavioral;
