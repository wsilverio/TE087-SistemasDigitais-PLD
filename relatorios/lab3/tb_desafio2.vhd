LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY tb_desafio2 IS
END tb_desafio2;
 
ARCHITECTURE behavior OF tb_desafio2 IS 

     COMPONENT desafio2 --Component Declaration for the Unit Under Test (UUT)
    PORT(
         chaves : IN  std_logic_vector(7 downto 0);
         LEDs : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;  

   --Inputs and outputs
   signal chaves : std_logic_vector(7 downto 0) := (others => '0');
   signal LEDs : std_logic_vector(7 downto 0);
 
BEGIN
 	-- Instantiate the Unit Under Test (UUT)
   uut: desafio2 PORT MAP (
          chaves => chaves,
          LEDs => LEDs
        );

   stim_proc: process   -- Stimulus process
   begin		
      wait for 250 ns;	     -- hold reset state for 250 ns.
		chaves <= "00000001";
		wait for 250 ns;
		chaves <= "00010011";
		wait for 250 ns;
		chaves <= "00110111";
		wait for 250 ns;
		chaves <= "01111111";
		wait for 250 ns;
		chaves <= "11111110";
		wait for 250 ns;
		chaves <= "11101100";
		wait for 250 ns;
		chaves <= "11001000";
		wait for 250 ns;
		chaves <= "10000000";
		wait for 250 ns;


      wait;
   end process;
END;