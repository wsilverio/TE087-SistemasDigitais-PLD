LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
 
ENTITY arithmetic_circuit_tb IS
END arithmetic_circuit_tb;
 
ARCHITECTURE behavior OF arithmetic_circuit_tb IS 
 
    COMPONENT arithmetic_circuit
    PORT(
         A    : IN  std_logic_vector(7 downto 0);
         B    : IN  std_logic_vector(7 downto 0);
         CIN  : IN  std_logic;
         OP   : IN  std_logic_vector(2 downto 0);
         Y    : OUT std_logic_vector(7 downto 0);
         COUT : OUT std_logic
        );
    END COMPONENT;

   signal A    : std_logic_vector(7 downto 0) := (others => '0');
   signal B    : std_logic_vector(7 downto 0) := (others => '0');
   signal CIN  : std_logic := '0';
   signal OP   : std_logic_vector(2 downto 0) := (others => '0');
   signal Y    : std_logic_vector(7 downto 0);
   signal COUT : std_logic;
  
BEGIN

   uut: arithmetic_circuit PORT MAP (
          A    => A,
          B    => B,
          CIN  => CIN,
          OP   => OP,
          Y    => Y,
          COUT => COUT
        );

   stim_proc: process
   begin

        wait for 100 ns;
        CIN <= '1';
        wait for 100 ns;
        A <= "01010101";
        B <= "10101010";
        OP <= "000";
        wait for 100 ns;
        OP <= "001";
        wait for 100 ns;
        OP <= "010";
        wait for 100 ns;
        OP <= "011";
        wait for 100 ns;
        OP <= "100";
        wait for 100 ns;
        OP <= "101";
        wait for 100 ns;
        OP <= "110";
        wait for 100 ns;
        OP <= "111";
        wait for 100 ns;

      wait;
   end process;

END;
