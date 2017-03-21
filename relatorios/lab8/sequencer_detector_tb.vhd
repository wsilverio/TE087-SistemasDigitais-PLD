LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY sequencer_detector_tb IS
END sequencer_detector_tb;
 
ARCHITECTURE behavior OF sequencer_detector_tb IS 
  
    COMPONENT sequence_detector
    PORT(
         input, reset, clock    :   IN   std_logic;
         output                 :   OUT  std_logic);
    END COMPONENT;

   --Inputs
   signal input : std_logic := '0';
   signal reset : std_logic := '0';
   signal clock : std_logic := '0';

 	--Outputs
   signal output      : std_logic;

   -- Clock period definitions
   constant clock_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: sequence_detector PORT MAP (
          input => input,
          reset => reset,
          clock => clock,
          output => output);

   -- Clock process definitions
   clock_process :process
   begin
		clock <= '1';
		wait for clock_period/2;
		clock <= '0';
		wait for clock_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      reset <= '1';    
      wait for clock_period/2;
      reset <= '0';
      wait for clock_period*4.5;
      input <= not input;
      wait for clock_period*6;
      input <= not input;
      wait for clock_period*5;
      wait;
   end process;

END;
