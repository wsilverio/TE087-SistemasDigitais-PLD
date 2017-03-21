LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY tb_desafio1 IS
END tb_desafio1;
 
ARCHITECTURE behavior OF tb_desafio1 IS 
    -- Component Declaration for the Unit Under Test (UUT) 
    COMPONENT binarytogray
    PORT(
         binary : IN  std_logic_vector(3 downto 0);
         gray : OUT  std_logic_vector(3 downto 0)
        );
    END COMPONENT;    

   --Inputs and Outputs
   signal binary : std_logic_vector(3 downto 0) := (others => '0');
	signal gray : std_logic_vector(3 downto 0);
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: binarytogray PORT MAP (
          binary => binary,
          gray => gray
        );

 
 -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

		binary <= "0001";
		wait for 100 ns;
		binary <= "0010";
		wait for 100 ns;
		binary <= "0011";
		wait for 100 ns;
		binary <= "0100";
		wait for 100 ns;
		binary <= "0101";
		wait for 100 ns;
		binary <= "0110";
		wait for 100 ns;
		binary <= "0111";
		wait for 100 ns;
		binary <= "1000";
		wait for 100 ns;
		binary <= "1001";
		wait for 100 ns;
		binary <= "1010";
		wait for 100 ns;
		binary <= "1011";
		wait for 100 ns;
		binary <= "1100";
		wait for 100 ns;
		binary <= "1101";
		wait for 100 ns;
		binary <= "1110";
		wait for 100 ns;
		binary <= "1111";
		wait for 100 ns;		
		
      wait;

   end process;

END;
