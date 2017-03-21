LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

 
ENTITY Desafio3_tb IS
END Desafio3_tb;
 
ARCHITECTURE behavior OF Desafio3_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Desafio3
    PORT(
         A : IN  std_logic;
         B : IN  std_logic;
         C : IN  std_logic;
         D : IN  std_logic;
         W : OUT  std_logic;
         Z : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal input : std_logic_vector(3 downto 0) := (others => '0');

 	--Outputs
   signal W : std_logic;
   signal Z : std_logic;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Desafio3 PORT MAP (
          A => input(3),
          B => input(2),
          C => input(1),
          D => input(0),
          W => W,
          Z => Z
        );
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;

		input <= "0001";
		wait for 100 ns;
		input <= "0010";
		wait for 100 ns;
		input <= "0011";
		wait for 100 ns;
		input <= "0100";
		wait for 100 ns;
		input <= "0101";
		wait for 100 ns;
		input <= "0110";
		wait for 100 ns;
		input <= "0111";
		wait for 100 ns;
		input <= "1000";
		wait for 100 ns;
		input <= "1001";
		wait for 100 ns;
		input <= "1010";
		wait for 100 ns;
		input <= "1011";
		wait for 100 ns;
		input <= "1100";
		wait for 100 ns;
		input <= "1101";
		wait for 100 ns;
		input <= "1110";
		wait for 100 ns;
		input <= "1111";
		wait for 100 ns;		
		
      wait;
   end process;

END;
