LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY tb_desafio1 IS
END tb_desafio1;
 
ARCHITECTURE behavior OF tb_desafio1 IS 
 
    COMPONENT desafio1
    PORT(
         CLK  : IN   std_logic;
         LEDs : OUT  std_logic_vector(29 downto 0)
        );
    END COMPONENT;
    
   signal CLK  : std_logic := '0';
   signal LEDs : std_logic_vector(29 downto 0);

   constant half_clk_period : time := 1 ns;
 
BEGIN
 
   uut: desafio1 PORT MAP (
          CLK => CLK,
          LEDs => LEDs
        );

   clk_process :process
   begin
        CLK <= CLK xor '1';
        wait for half_clk_period;
   end process;
 
END;
