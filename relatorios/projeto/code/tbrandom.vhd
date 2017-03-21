LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY tb2 IS
END tb2;
 
ARCHITECTURE behavior OF tb2 IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT random
    PORT(
         clk : IN  std_logic;
         random_num : OUT  std_logic_vector(5 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';

 	--Outputs
   signal random_num : std_logic_vector(5 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: random PORT MAP (
          clk => clk,
          random_num => random_num
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;


END;