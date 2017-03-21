LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY tb_desafio2 IS
END tb_desafio2;
 
ARCHITECTURE behavior OF tb_desafio2 IS 
 
    COMPONENT desafio2
    PORT(
         clk  : IN  std_logic;
         LEDs : OUT  std_logic_vector(29 downto 0)
        );
    END COMPONENT;
 
   signal clk  : std_logic := '0';
   signal LEDs : std_logic_vector(29 downto 0);
   constant clk_period : time := 3.5 ns;
 
BEGIN

   uut: desafio2 PORT MAP (
          clk => clk,
          LEDs => LEDs
        );

   clk_process :process
   begin
		clk <= clk xor '1';
		wait for 2*clk_period;
   end process;

END;
