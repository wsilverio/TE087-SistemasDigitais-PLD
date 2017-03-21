LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY des3_tb IS
END des3_tb;
 
ARCHITECTURE behavior OF des3_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT desafio3
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         en : OUT  std_logic_vector(3 downto 0);
         seven_seg : OUT  std_logic_vector(6 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';

 	--Outputs
   signal en : std_logic_vector(3 downto 0);
   signal seven_seg : std_logic_vector(6 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: desafio3 PORT MAP (
          clk => clk,
          rst => rst,
          en => en,
          seven_seg => seven_seg
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
