library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity fullAdder8bits is
    Port (
        A        : in  STD_LOGIC_VECTOR(7 downto 0);
        B        : in  STD_LOGIC_VECTOR(7 downto 0);
        Cin      : in  STD_LOGIC; -- Cin é um único bit para o carry-in
        Cout     : out STD_LOGIC;
        SUM      : out STD_LOGIC_VECTOR(7 downto 0);
        overflow  : out STD_LOGIC
    );
end fullAdder8bits;

architecture Behavioral of fullAdder8bits is

    -- Definindo o tipo de um somador completo de 1 bit
    component fullAdder is
        Port (
            A    : in  STD_LOGIC;
            B    : in  STD_LOGIC;
            Cin  : in  STD_LOGIC;
            Sum  : out STD_LOGIC;
            Cout : out STD_LOGIC
        );
    end component;

    -- Sinais internos para os carrys
    signal C : STD_LOGIC_VECTOR(8 downto 0);  -- Usaremos 9 bits para os carries, para o carry final também

begin

    -- Inicializando o carry-in do primeiro bit
    C(0) <= Cin;  -- O carry-in inicial é a entrada Cin

    -- Instanciando os somadores completos (1 bit para cada par de bits)
    FA0: fullAdder port map (
        A => A(0),
        B => B(0),
        Cin => C(0),
        Sum => SUM(0),
        Cout => C(1)
    );

    FA1: fullAdder port map (
        A => A(1),
        B => B(1),
        Cin => C(1),
        Sum => SUM(1),
        Cout => C(2)
    );

    FA2: fullAdder port map (
        A => A(2),
        B => B(2),
        Cin => C(2),
        Sum => SUM(2),
        Cout => C(3)
    );

    FA3: fullAdder port map (
        A => A(3),
        B => B(3),
        Cin => C(3),
        Sum => SUM(3),
        Cout => C(4)
    );

    FA4: fullAdder port map (
        A => A(4),
        B => B(4),
        Cin => C(4),
        Sum => SUM(4),
        Cout => C(5)
    );

    FA5: fullAdder port map (
        A => A(5),
        B => B(5),
        Cin => C(5),
        Sum => SUM(5),
        Cout => C(6)
    );

    FA6: fullAdder port map (
        A => A(6),
        B => B(6),
        Cin => C(6),
        Sum => SUM(6),
        Cout => C(7)
    );

    FA7: fullAdder port map (
        A => A(7),
        B => B(7),
        Cin => C(7),
        Sum => SUM(7),
        Cout => C(8)
    );

    -- A saída carry-out é o carry final, que é C(8)
    Cout <= C(8);

    -- Detectando overflow: se o carry-out final for diferente do carry-in inicial, ocorre overflow
    overflow <= C(7) xor C(8);  -- Overflow ocorre se os dois bits mais significativos gerarem carry diferente

end Behavioral;

