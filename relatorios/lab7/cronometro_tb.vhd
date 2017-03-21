LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY cronometro_tb IS
END cronometro_tb;
 
ARCHITECTURE behavior OF cronometro_tb IS 
 
    COMPONENT cronometro
    PORT(
         en         : OUT  std_logic_vector(3 downto 0);
         seven_seg  : OUT  std_logic_vector(6 downto 0);
         clk        : IN  std_logic;
         rst        : IN  std_logic;
         pse        : IN  std_logic;
         swi        : IN  std_logic);
    END COMPONENT;

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal pse : std_logic := '0';
   signal swi : std_logic := '0';

  --Outputs
   signal en        : std_logic_vector(3 downto 0);
   signal seven_seg : std_logic_vector(6 downto 0);

   -- Clock period definitions
   constant clk_period : time := 20 ns; -- 50MHz
 
BEGIN
 
  -- Instantiate the Unit Under Test (UUT)
   uut: cronometro PORT MAP (
          en => en,
          seven_seg => seven_seg,
          clk => clk,
          rst => rst,
          pse => pse,
          swi => swi);

   -- Clock process definitions
   clk_process :process
   begin
    clk <= '0';
    wait for clk_period/2;
    clk <= '1';
    wait for clk_period/2;
   end process;
 
   stim_proc: process
   begin    
        swi <= '0';
        rst <= '1';
        wait for 2*clk_period;
        rst <= '0';
      wait;
   end process;

END;
