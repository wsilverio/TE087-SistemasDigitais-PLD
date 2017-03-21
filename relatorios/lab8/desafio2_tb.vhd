LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY desafio2_tb IS
END desafio2_tb;
 
ARCHITECTURE behavior OF desafio2_tb IS 
 
    COMPONENT desafio2
    PORT(
         clk : IN  std_logic;
         output : OUT  std_logic
        );
    END COMPONENT;    

   --Inputs
   signal clk : std_logic := '0';

 	--Outputs
   signal output : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: desafio2 PORT MAP (
          clk => clk,
          output => output
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
