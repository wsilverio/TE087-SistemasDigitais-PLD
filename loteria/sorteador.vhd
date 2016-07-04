---------------------------------------------------------
-- componente: sorteador
-- descricao: esse componente tem a finalidade de escolher 
-- os numeros sorteados e tratá-los. Em seus ports de saida 
-- os números são entregues já separados em unidades e dezenas.
-- É entregado também um indice que informa em qual parte da 
-- maquina de estados se encontra.
---------------------------------------------------------
	library IEEE;
	use IEEE.STD_LOGIC_1164.ALL;
	use IEEE.numeric_std.all;
	-------------------------------------------------------------
	entity sorteador is
		 port(
				clk                : in std_logic; 
				button             : in std_logic;
				rst			       : in std_logic;
				selected_number_un : out integer range 0 to 9;
				selected_number_dez: out integer range 0 to 5;
				seven_seg          : out std_logic_vector(6 downto 0);
				point 			   : out std_logic;
				index              : out integer range 0 to 7;
				en 				   : out std_logic_vector(3 downto 0)
				);   
	end loterica;
	-------------------------------------------------------------
	architecture Behavioral of sorteador is
	
		TYPE state IS (starting, first, second, third, fourth, fifth, sixth, ending);
		--inicializações dos estados
		signal pr_state   : state := starting; 
		signal nx_state   : state := first;		
		
		--sinal para receber o valor random
		signal random_num_int : integer range 1 to 60;
		signal random_num_aux : std_logic_vector(5 downto 0);
		
		--sinal para receber o numero sorteado
		signal selected_number:  integer range 1 to 60;
		signal selected_number1: integer range 1 to 60;
		--sinais para receber os numeros sorteados e fazer
		--a verificação de repetido
		signal selected_number2: integer range 1 to 60;
		signal selected_number3: integer range 1 to 60;
		signal selected_number4: integer range 1 to 60;
		signal selected_number5: integer range 1 to 60;
		signal selected_number6: integer range 1 to 60;
		signal selected_number_old: integer range 1 to 60;
		
		--sinal num para escrever no display, componente
		signal num            : integer range 0 to 9;
		
		--sinal para a contagem de 1ms, componente
		signal milli          : std_logic;
		
		--sinal para o debounce, componente
		signal debounced   	  : std_logic;
		
		--sinal para a escolha do anodo do display
		signal sig_en         : std_logic_vector(3 downto 0) :="0111";
		--7seg numeros
		signal seg            : std_logic_vector(6 downto 0);
		--7seg mensagem 
		signal mseg           : std_logic_vector(6 downto 0);
		
		--true: starting, false: ending
		signal message		  : boolean;
		--true: message, false: numbers
		signal type_seg		  : boolean;

		signal whatCharacter  : integer range 0 to 20;
		signal deslocador     : integer range -3 to 13:=-3;

---------------------------------------------------------   
		 --componente para a messagem de inicio e fim
		 component messages
		 port (whatCharacter : in integer range 0 to 20;
			    message       : in BOOLEAN;
             medisplay7seg : out STD_LOGIC_VECTOR (6 downto 0));
		 end component;
		 
		 --componente do numero random
		 component random
		 port(
			  clk : in std_logic;
			  random_num : out std_logic_vector (5 downto 0));
		 end component;

		--componente display
		 component display7seg
		 port(
			  num : in integer range 0 to 9;
			  seg : out std_logic_vector(6 downto 0));
		 end component;
		 
		 --componente millis
		 component millis
		 port(
			  rst   : in std_logic;
			  clk   : in std_logic;
			  output: out std_logic);
		 end component;
		 
		--componente debounced
		component debounced_sw 
		 port(
			  clk:        in  std_logic;  -- f=1kHz -> T=1ms
			  input:      in  std_logic;  -- entrada
			  normal_st:  in  std_logic;  -- estado normal
			  output:     out std_logic);  -- saida
		 end component;
	-----------------------------------------------------------    
		 begin
		 --apagar o ponto do display
		 point <= '1';
	-----------------------------------------------------------    
			  
			  --port maps
			  
			  unt_rand: random port map (
			  clk => clk,
			  random_num => random_num_aux
			  ); 
			  
			  unt_disp: display7seg port map (
			  num => num,
			  seg => seg
			  );
			  
			  unt_milli: millis port map (
			  rst => rst,
			  clk => clk,
			  output => milli
			  );
			  
			  unt_sw: debounced_sw port map (
			  clk => milli,
			  input => button,
			  normal_st => '0',
			  output => debounced
			  );
			  
			  unt_mess: messages port map (
			  whatCharacter => whatCharacter,
			  message => message,
        	  medisplay7seg => mseg
			  );
	-----------------------------------------------------------
		--primeira parte da maquina de estados
		process(debounced, rst)
			variable v_rand: integer range 1 to 60; 
		begin 
			--verificação para reset
			if (rst ='1') then
				pr_state <= starting;
			elsif (debounced'event and debounced ='1') then 
				pr_state <= nx_state;
			
				v_rand := to_integer(unsigned(random_num_aux));
				
				--while para evitar repetição
				while (v_rand = selected_number1 or 
					   v_rand = selected_number2 or
				       v_rand = selected_number3 or
				       v_rand = selected_number4 or
				       v_rand = selected_number5) loop
						v_rand := to_integer(unsigned(random_num_aux));			
				end loop;			
			
			end if;
			random_num_int <= v_rand;
		end process;
	-----------------------------------------------------------
		process(pr_state)
		begin 
			case pr_state is 
				when starting => 
						index <= 0;
						nx_state <= first;
						message <= true;
						type_seg <= true;
						
				when first => 
						selected_number1 <= random_num_int;
						selected_number <= selected_number1;
						index <= 1;
						nx_state <= second;
						message <= false;
						type_seg <= false;
						
				when second => 
						selected_number2 <= random_num_int;
						selected_number <= selected_number2;
						index <= 2;
						nx_state <= third;
						message <= false;
						type_seg <= false;
						
				when third => 
						selected_number3 <= random_num_int;
						selected_number <= selected_number3;
						index <= 3;
						nx_state <= fourth;
						message <= false;
						type_seg <= false;
						
				when fourth => 
						selected_number4 <= random_num_int;
						selected_number <= selected_number4;
						index <= 4;
						nx_state <= fifth;
						message <= false;
						type_seg <= false;
						
				when fifth => 
						selected_number5 <= random_num_int;
						selected_number <= selected_number5;
						index <= 5;
						nx_state <= sixth;
						message <= false;
						type_seg <= false;
						
				when sixth => 
						selected_number6 <= random_num_int;
						selected_number <= selected_number6;
						index <= 6;
						nx_state <= ending;
						message <= false;
						type_seg <= false;

				when others =>
						index <= 7;
						nx_state <= starting;
						message <= false;
						type_seg <= true;
			end case;					
		end process;	
	------------------------------------------------

		process(milli, clk)
		variable v_count: integer range 0 to 60:= 0;
		variable v_un   : integer range 0 to 9 := 0;
		variable v_dez  : integer range 0 to 6 := 0;
		variable count_ms: integer range 0 to 1500:= 0;
		
		begin				
			if(milli'event and milli = '1') then
				 --case para selecionar o enable do display
				 --7 seg
				  case sig_en is
						
						when "0111" =>  --primeiro display 
							 if(type_seg = false) then
								num<= v_dez;
								seven_seg <= seg;
							 else
								seven_seg <= mseg;
								whatCharacter <= deslocador + 2;
							 end if;
							 sig_en <= "1110";
							 en <= "1110";
							 
						when "1110" => --segundo display
							 if(type_seg = false) then
								num<= v_un;
								seven_seg <= seg;
							 else
								seven_seg <= mseg;
								whatCharacter <= deslocador + 1;
							 end if;
							 sig_en <= "1101";
							 en <= "1101";	
						
						when "1101" => --terceiro display
							 if(type_seg = false) then
								seven_seg <= "1111111";
							 else
								seven_seg <= mseg;
								whatCharacter <= deslocador ;
							 end if;						 
							 sig_en <= "1011";
							 en <= "1011";
						
						when others =>  --quarto display
							if(type_seg = false) then
								seven_seg <= "1111111";
							 else
								seven_seg <= mseg;
								whatCharacter <= deslocador+3;
							 end if;
							 sig_en <= "0111";
							 en <= "0111";
				  end case;
				  
				--esse bloco conta 400ms para fazer o deslocamento
				--das mensagens de inicio e fim
				if(count_ms < 400) then
					count_ms := count_ms + 1;
				else
					deslocador <= deslocador + 1;
					count_ms := 0;
				end if;
				if(deslocador > 13) then
					deslocador <= -3;
				end if;
				
				--para evitar ter que fazer divisão e assim economizar 
				--hardware, o metodo para dividir unidade e dezena do
				--numero sorteado foi o de contagem.
				if(selected_number /= selected_number_old) then
					v_count := 0;
					v_un :=0;
					v_dez := 0;
				end if;
				selected_number_old <= selected_number;	
				if(selected_number > v_count) then 
					v_count := v_count + 1;
					v_un := v_un + 1;
					if(v_un > 9) then
						v_dez := v_dez + 1;
						v_un := 0;
					end if;
					if(v_dez > 5) then
						v_dez := 5;
					end if;
				else
					selected_number_un <= v_un;
					selected_number_dez <= v_dez;						
				end if;
							
			end if;	
		end process;
	end Behavioral;
	