library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Desafio3 is
    Port ( A : in  STD_LOGIC;
           B : in  STD_LOGIC;
           C : in  STD_LOGIC;
           D : in  STD_LOGIC;
           W : out  STD_LOGIC;
           Z : out  STD_LOGIC);
end Desafio3;

architecture Behavioral of Desafio3 is

begin

Z <= ((not A) and (not D)) or ((not A) and C);

W <= ((not B) and (not D)) or ((not A) and B);

end Behavioral;

