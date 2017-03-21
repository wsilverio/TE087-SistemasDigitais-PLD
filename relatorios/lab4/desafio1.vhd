library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity binarytogray is

	GENERIC (n : INTEGER := 4);
	PORT ( binary: IN STD_LOGIC_VECTOR (n-1 DOWNTO 0);
			 gray: OUT STD_LOGIC_VECTOR (n-1 DOWNTO 0));

end binarytogray;

architecture Behavioral of binarytogray is
begin

	gray(n-1) <= binary(n-1);

	btg: FOR i in 0 to n-2 GENERATE
	
		gray(i) <= binary(i+1) xor binary(i);
	
	end GENERATE;
end Behavioral;

