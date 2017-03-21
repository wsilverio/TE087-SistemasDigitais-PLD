LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY tb_desafio1 IS
END tb_desafio1;

ARCHITECTURE behavior OF tb_desafio1 IS

    COMPONENT Desafio -- Component Declaration for the Unit Under Test (UUT)
    PORT(
         chaves : IN  std_logic_vector(7 downto 0);
         LEDs : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;

   --Inputs and Outputs
   signal chaves : std_logic_vector(7 downto 0) := (others => '0');
   signal LEDs : std_logic_vector(7 downto 0);

BEGIN
    uut: Desafio PORT MAP (    	-- Instantiate the Unit Under Test (UUT)
          chaves => chaves,
          LEDs => LEDs
        );

   -- Stimulus process
   stim_proc: process
   begin

      chaves <= (0 => '1', others => '0');
      wait for 250 ns;
      chaves <= (1 => '1', others => '0');
      wait for 250 ns;
      chaves <= (2 => '1', others => '0');
      wait for 250 ns;
      chaves <= (3 => '1', others => '0');
      wait for 250 ns;
      chaves <= (4 => '1', others => '0');
      wait for 250 ns;
      chaves <= (5 => '1', others => '0');
      wait for 250 ns;
      chaves <= (6 => '1', others => '0');
      wait for 250 ns;
      chaves <= (7 => '1', others => '0');
      wait for 250 ns;

      wait;
   end process;
END;
