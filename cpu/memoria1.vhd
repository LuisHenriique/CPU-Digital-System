library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; 

ENTITY memoria1 IS
	PORT
	(
		address		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		clock		: IN STD_LOGIC;
		data		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		wren		: IN STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
	);
END memoria1;

ARCHITECTURE behavioral OF memoria1 IS
	component memoria
        Port (
            address		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
				clock		: IN STD_LOGIC;
				data		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
				wren		: IN STD_LOGIC ;
				q		: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
        );
    end component; 

begin
	inst1 : memoria
        port map (
            address	=> address,
				clock		=> clock,
				data		=> data,
				wren		=> wren,
				q			=> q
        );
end behavioral;
