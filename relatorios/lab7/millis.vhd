library ieee;
use ieee.std_logic_1164.all;
 
entity millis is
    port(
        rst   : in std_logic;
        clk   : in std_logic;
        milli : out std_logic);
end millis;
 
architecture behavioral of millis is 
    signal sig_milli : std_logic := '0';
begin
    process(clk)
        variable counter : integer range 0 to 50_000; -- 1ms p/ clk = 50MHz
    begin
        if(rst='1') then
        
        end if;
        
        if(clk'event and clk='1') then
            counter := counter + 1;
            if(counter = 25_000) then
                sig_milli <= sig_milli xor '1'; -- inverte o estado
                counter := 0;
            end if;
        end if;
    end process;
    
    milli <= sig_milli;
    
end behavioral;
