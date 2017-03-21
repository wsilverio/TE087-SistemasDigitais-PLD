LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY tb_debounced_sw IS
END tb_debounced_sw;
 
ARCHITECTURE behavior OF tb_debounced_sw IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT debounced_sw
    PORT(
         clk : IN  std_logic;
         input : IN  std_logic;
         normal_st : IN  std_logic;
         output : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal input : std_logic := '0';
   signal normal_st : std_logic;
   signal sig_normal_st : std_logic := '0';

 	--Outputs
   signal output : std_logic;

   -- Clock period definitions
   constant clk_period : time := 1 ms;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: debounced_sw PORT MAP (
          clk => clk,
          input => input,
          normal_st => normal_st,
          output => output
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 
   -- estado normal: nivel baixo
   normal_st <= sig_normal_st;

   -- Stimulus process
   stim_proc: process
   begin
      input <= sig_normal_st;
      wait for clk_period/2;
      
      -- botao pressionado + ruido
      for i in 1 to 3 loop
        input <= not sig_normal_st;
        wait for 100 us;
        input <= sig_normal_st;
        wait for 100 us;
      end loop;
      
      -- botao pressionado estabilizado
      input <= not sig_normal_st;
      
      wait for 10 ms;

	  -- botao liberado + ruido
      for i in 1 to 3 loop
        input <= sig_normal_st;
        wait for 100 us;
        input <= not sig_normal_st;
        wait for 100 us;
      end loop;
      
      -- botao liberado estabilizado
      input <= sig_normal_st;

      wait;
   end process;

END;
