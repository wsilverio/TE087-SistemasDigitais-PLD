library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity cronometro is
    Port ( en         : out  STD_LOGIC_VECTOR (3 downto 0);
           seven_seg  : out  STD_LOGIC_VECTOR (6 downto 0);
           clk        : in  STD_LOGIC;
           rst        : in  STD_LOGIC;
           pse        : in  STD_LOGIC;
           swi        : in  STD_LOGIC);
end cronometro;

----------------------------------------
architecture Behavioral of cronometro is

    component display7seg
    port(
        num : in integer range 0 to 9;
        seg : out std_logic_vector(6 downto 0));
    end component;
-------    
    component millis
    port(
        rst   : in std_logic;
        clk   : in std_logic;
        milli : out std_logic);
    end component;
-------    
    signal num         : integer range 0 to 9   := 0;
    signal milli       : std_logic;
    signal sig_en      : std_logic_vector(3 downto 0) :="1110";
     
    signal count_milli     :INTEGER RANGE 0 TO 1000    := 0;
    signal count_seg_un    :INTEGER RANGE 0 TO 10      := 0;
    signal count_seg_dez   :INTEGER RANGE 0 TO 6       := 0;
    signal count_min_un    :INTEGER RANGE 0 TO 10      := 0;
    signal count_min_dez   :INTEGER RANGE 0 TO 6       := 0;
    signal count_hora_un   :INTEGER RANGE 0 TO 10      := 0;
    signal count_hora_dez  :INTEGER RANGE 0 TO 10      := 0;     
-------
begin

    unt_segment: display7seg port map (
        num => num,
        seg => seven_seg
    );

    unt_milli: millis port map (
        rst => rst,
        clk => clk,
        milli => milli
    );
    
    
    process(milli,rst)
    begin
        if(rst = '1') then         
             count_milli    <= 0;
             count_seg_un   <= 0;        
             count_seg_dez  <= 0;      
             count_min_un   <= 0;    
             count_min_dez  <= 0;      
             count_hora_un  <= 0;       
             count_hora_dez <= 0;      
    
        elsif(milli'event and milli = '1') then     
                     
            if (count_milli < 999 and pse = '0') then
                 count_milli <= count_milli + 1;
            else            
                 count_milli <= 0;
                 if(pse = '0')then
                    count_seg_un <= count_seg_un + 1;
                 end if;
            end if;
                 
            if (count_seg_un > 9) then
                 count_seg_un <= 0;
                 count_seg_dez <= count_seg_dez + 1;
            end if;
             
            if (count_seg_dez > 5) then
                 count_seg_dez <= 0;
                 count_min_un <= count_min_un + 1;
            end if;             
             
            if (count_min_un > 9) then
                 count_min_un <= 0;
                 count_min_dez <= count_min_dez + 1;
            end if;
             
            if (count_min_dez > 5) then
                 count_min_dez <= 0;
                 count_hora_un <= count_hora_un + 1;
            end if;
             
            if (count_hora_un > 5) then
                 count_hora_un <= 0;
                 count_hora_dez <= count_hora_dez + 1;
            end if;
                         
            en <= sig_en;
                    
            case sig_en is 
                 when "1110" =>
                      if(swi='0') then
                            num <= count_seg_un;
                      else 
                            num <= count_min_un;
                      end if;
                            sig_en <= "1101";
                            
                 when "1101" => 
                      if(swi='0') then
                            num <= count_seg_dez;
                      else
                            num <= count_min_dez;
                      end if;
                      sig_en <= "1011";
                            
                 when "1011" => 
                      if(swi='0') then
                            num <= count_min_un;
                      else
                            num <= count_hora_un;
                      end if;
                      sig_en <= "0111";
                            
                 when others => 
                      if(swi='0') then
                            num <= count_min_dez;
                      else
                            num <= count_hora_dez;
                      end if;
                      sig_en <= "1110";
            end case;       
        end if;
     end process;
end Behavioral;
