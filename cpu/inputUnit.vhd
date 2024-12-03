library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; 

entity inputUnit is
    Port ( inputEnable : in  STD_LOGIC;
			  entradaPlaca: in STD_LOGIC_VECTOR(7 downto 0);
           recebeuInput: out STD_LOGIC_VECTOR(7 downto 0);
			  clk			: in STD_LOGIC
			 );
end inputUnit;

architecture Behavioral of inputUnit is
begin
	process(clk)
	begin
		if rising_edge(clk) then
			if inputEnable='1' then
				recebeuInput <= entradaPlaca;
			end if;
		end if;
	end process;
	
end Behavioral;
