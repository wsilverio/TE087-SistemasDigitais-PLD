LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY tb_millis IS
END tb_millis;
 
ARCHITECTURE behavior OF tb_millis IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT millis
    PORT(
         rst : IN  std_logic;
         clk : IN  std_logic;
         output : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal rst : std_logic := '0';
   signal clk : std_logic := '0';

 	--Outputs
   signal output : std_logic;

   -- Clock period definitions
   constant clk_period : time := 20 ns; -- 50MHz
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: millis PORT MAP (
          rst => rst,
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
      -- conta 5ms
      wait for 5 ms;
      -- aciona reset por 5ms
      rst <= '1';
      wait for 5 ms;
      -- retorna a contagem
      rst <= '0';

      wait;
   end process;

END;
