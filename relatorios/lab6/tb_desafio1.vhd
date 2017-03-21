LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY tb_desafio1 IS
END tb_desafio1;
 
ARCHITECTURE behavior OF tb_desafio1 IS 
    COMPONENT desafio1
    PORT(
         clk : IN  std_logic;
         seven_seg : OUT  std_logic_vector(6 downto 0);
         en : OUT  std_logic_vector(3 downto 0)
        );
    END COMPONENT;	 	 
  
   signal clk : std_logic := '0';
   signal seven_seg : std_logic_vector(6 downto 0);
   signal en : std_logic_vector(3 downto 0);

   constant clk_period : time := 20 ns;
 
BEGIN
    uut: desafio1 PORT MAP (
          clk => clk,
          seven_seg => seven_seg,
          en => en
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
