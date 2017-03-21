library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
----------------------------------------------------
entity sequence_detector is
    port(   input, reset, clock :   in  std_logic;
            output              :   out std_logic);
end sequence_detector;
----------------------------------------------------
architecture Behavioral of sequence_detector is
    type state is (
    state_ini,                                -- estado inicial
    state_0A, state_0B, state_0C, state_0D,   -- sequencia de 'zeros'
    state_1A, state_1B, state_1C, state_1D);  -- sequencia de 'uns'
    
    signal pr_state, nx_state   : state     := state_ini;    
----------------------------------------------------
begin
----------------------------------------------------
    process(reset, clock)
    begin
        if(reset='1') then
            pr_state <= state_ini;
        elsif(clock'event and clock='1') then
            pr_state <= nx_state;
        end if;
    end process;
----------------------------------------------------
    process(input, pr_state)
    begin
        case pr_state is
            ---------------------------    
            when state_ini =>
                output <= '0';
                if(input='0') then
                    nx_state <= state_0A;
                else
                    nx_state <= state_1A;
                end if;
            ---------------------------    
            when state_0A =>
                output <= '0';
                if(input='0') then
                    nx_state <= state_0B;
                else
                    nx_state <= state_1A;
                end if;
            ---------------------------    
            when state_0B =>
                output <= '0';
                if(input='0') then
                    nx_state <= state_0C;
                else
                    nx_state <= state_1A;
                end if;
            ---------------------------    
            when state_0C =>
                output <= '0';
                if(input='0') then
                    nx_state <= state_0D;
                else
                    nx_state <= state_1A;
                end if;
            ---------------------------    
            when state_0D =>
                output <= '1';
                if(input='0') then
                    nx_state <= state_0D;
                else
                    nx_state <= state_1A;
                end if;
            ---------------------------    
            when state_1A =>
                output <= '0';
                if(input='1') then
                    nx_state <= state_1B;
                else
                    nx_state <= state_0A;
                end if;
            ---------------------------    
            when state_1B =>
                output <= '0';
                if(input='1') then
                    nx_state <= state_1C;
                else
                    nx_state <= state_0A;
                end if;
            ---------------------------    
            when state_1C =>
                output <= '0';
                if(input='1') then
                    nx_state <= state_1D;
                else
                    nx_state <= state_0A;
                end if;
            ---------------------------    
            when state_1D =>
                output <= '1';
                if(input='1') then
                    nx_state <= state_1D;
                else
                    nx_state <= state_0A;
                end if;
        end case;
    end process;
----------------------------------------------------
end Behavioral;
