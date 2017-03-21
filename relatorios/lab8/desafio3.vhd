library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
---------------------------------------------------
entity desafio3 is
    port (clk, rst: in STD_LOGIC;
          -----------------------------------------
          en: out  STD_LOGIC_VECTOR (3 downto 0);
          seven_seg: out  STD_LOGIC_VECTOR (6 downto 0));
end desafio3;
---------------------------------------------------
architecture Behavioral of desafio3 is
    --estados da fms
    type state is(zero, um, dois, tres, quatro, cinco, seis,
                  sete, oito, nove, a, b, c, d, e, f);
    signal pr_state, nx_state: state;
    --componente 7seg indo de 0 ate F
    component display7seg
    port(
        num : in integer range 0 to 15;
        seg : out std_logic_vector(6 downto 0));
    end component;
    signal num: integer range 0 to 15:= 0;
---------------------------------------------------
begin
    unt_segment: display7seg port map (
        num => num,
        seg => seven_seg
    );
---------------------------------------------------
    process(rst, clk)
	 variable count: integer range 0 to 3125000;
    begin
        if(rst ='1') then
            pr_state <= zero;
        elsif(clk'event and clk = '1') then
            count := count + 1;
				if (count >= 3125000) then 
					pr_state <= nx_state;
					count := 0;
				end if;
        end if;
    end process;
---------------------------------------------------
    process(pr_state)
    begin
        case pr_state is
            when zero =>
                    num <= 0;
                    nx_state <= um;
            when um =>
                    num <= 1;
                    nx_state <= dois;
            when dois =>
                    num <= 2;
                    nx_state <= tres;
            when tres =>
                    num <= 3;
                    nx_state <= quatro;
            when quatro =>
                    num <= 4;
                    nx_state <= cinco;
            when cinco =>
                    num <= 5;
                    nx_state <= seis;
            when seis =>
                    num <= 6;
                    nx_state <= sete;
            when sete =>
                    num <= 7;
                    nx_state <= oito;
            when oito =>
                    num <= 8;
                    nx_state <= nove;
            when nove =>
                    num <= 9;
                    nx_state <= a;
            when a =>
                    num <= 10;
                    nx_state <= b;
            when b => 
                    num <= 11;
                    nx_state <= c;
            when c =>
                    num <= 12;
                    nx_state <= d;
            when d =>
                    num <= 13;
                    nx_state <= e;
            when e =>
                    num <= 14;
                    nx_state <= f;
            when f => 
                    num <= 15;
                    nx_state <= zero;
        end case;
    end process;
	 
	 en <= "1110";
end Behavioral;
