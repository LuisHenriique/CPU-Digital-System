library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;   -- Opcional, se você for usar tipos aritméticos
use IEEE.STD_LOGIC_UNSIGNED.ALL;  -- Opcional, se você precisar fazer operações com vetores de bits


entity fullAdder is
    Port (
        A    : in  STD_LOGIC;
        B    : in  STD_LOGIC;
        Cin  : in  STD_LOGIC;
        Sum  : out STD_LOGIC;
        Cout : out STD_LOGIC
    );
end fullAdder;

architecture Behavioral of fullAdder is
begin
    -- Somador de 1 bit
    Sum <= (A xor B) xor Cin;  -- Soma é a XOR dos três bits
    Cout <= ((A xor B) and Cin) or (A and B); -- Carry-out é a combinação dos ands
end Behavioral;
