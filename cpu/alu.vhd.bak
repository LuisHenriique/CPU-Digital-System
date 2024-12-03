library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;  -- Usar numeric_std ao invés de STD_LOGIC_ARITH e STD_LOGIC_UNSIGNED

entity alu is
    Port (
        comando        : in STD_LOGIC_VECTOR(3 downto 0);
        input1         : in STD_LOGIC_VECTOR(7 downto 0);
        input2         : in STD_LOGIC_VECTOR(7 downto 0);
        output         : out STD_LOGIC_VECTOR(7 downto 0);
        flag_0         : out STD_LOGIC;
        flag_overflow  : out STD_LOGIC;
        flag_signal    : out STD_LOGIC;
        flag_carry     : out STD_LOGIC
    );
end alu;

architecture Behavioral of alu is
    -- VARIÁVEIS AUXILIARES DA SOMA
    signal SUM1       : STD_LOGIC_VECTOR(7 downto 0);
    signal COUT1      : STD_LOGIC;
    signal overflow1  : STD_LOGIC;
    
    -- VARIÁVEIS AUXILIARES DA SUBTRAÇÃO
    signal input2invertido : STD_LOGIC_VECTOR(7 downto 0);
    signal SUM2           : STD_LOGIC_VECTOR(7 downto 0);
    signal COUT2          : STD_LOGIC;
    signal overflow2      : STD_LOGIC;
    
    -- SINAL INTERNO PARA O VALOR DE OUTPUT
    signal internal_output : STD_LOGIC_VECTOR(7 downto 0);

    -- DEFININDO O COMPONENTE DO SOMADOR DE 8 BITS
    component fullAdder8bits
        port (
            A        : in  STD_LOGIC_VECTOR(7 downto 0);
            B        : in  STD_LOGIC_VECTOR(7 downto 0);
            Cin      : in  STD_LOGIC; -- Cin é um único bit para o carry-in
            Cout     : out STD_LOGIC;
            SUM      : out STD_LOGIC_VECTOR(7 downto 0);
            overflow : out STD_LOGIC
        );
    end component;
     
    -- DEFININDO O COMPONENTE DO COMPLEMENTO DE DOIS
    component complemento_de_dois
        port (
            num           : in  STD_LOGIC_VECTOR(7 downto 0); -- Entrada de 8 bits
            complemento   : out STD_LOGIC_VECTOR(7 downto 0)   -- Saída do complemento de dois
        );
    end component;
     
begin
    -- INSTANCIANDO O SOMADOR DE 8 BITS PARA SOMA
    somar : fullAdder8bits
        port map (
            A        => input1,
            B        => input2,
            Cin      => '0',
            Cout     => COUT1,
            SUM      => SUM1,
            overflow => overflow1
        );
    
    -- INSTANCIANDO O COMPONENTE DE COMPLEMENTO DE 2 PARA SUBTRAÇÃO
    complemento : complemento_de_dois
        port map (
            num         => input2,
            complemento => input2invertido
        );
  
    -- INSTANCIANDO O SOMADOR DE 8 BITS PARA SUBTRAÇÃO
    subtrair : fullAdder8bits
        port map (
            A        => input1,
            B        => input2invertido,
            Cin      => '0',  -- Carry-in será 1 para somar com o complemento de dois
            Cout     => COUT2,
            SUM      => SUM2,
            overflow => overflow2
        );
    
    -- COM BASE NO COMANDO, DEFINE-SE A OPERAÇÃO A SER REALIZADA
    process(comando, SUM1, SUM2)
    begin
        case comando is
            -- "0000": SOMA
            when "0000" => 
                internal_output <= SUM1;   -- RECEBE O VALOR DA SOMA
                flag_overflow <= overflow1;  -- RECEBE O OVERFLOW DA SOMA
                flag_carry    <= COUT1;   -- RECEBE O ULTIMO CARRY DA SOMA
            
            -- "0001": SUBTRAI
            when "0001" => 
                internal_output <= SUM2;   -- RECEBE O VALOR DA SUBTRAÇÃO
                flag_overflow <= overflow2;  -- RECEBE O OVERFLOW DA SUBTRAÇÃO
                flag_carry    <= COUT2;   -- O CARRY DA SUBTRAÇÃO
                
            -- "0010": AND BIT A BIT
            when "0010" => 
                internal_output <= input1 AND input2;
                
            -- "0011": OR BIT A BIT
            when "0011" => 
                internal_output <= input1 OR input2;
                
            -- "0100": NOT (INVERTE OS BITS DO VETOR)
            when "0100" => 
                internal_output <= NOT input1;
                
            -- Caso padrão
            when others => 
                internal_output <= "00000000";  -- Se o comando não for reconhecido, atribui 0
        end case;
    end process;

    -- PROCESSO PARA ATUALIZAR AS FLAGS
    process(internal_output)
    begin
        -- FLAG 0 (Verifica se o número resultado é zero)
        if (internal_output = "00000000") then
            flag_0 <= '1';
        else
            flag_0 <= '0';
        end if;

        -- FLAG DE SINAL (Se for 1, é negativo; se for 0, é positivo)
        if (internal_output(7) = '1') then
            flag_signal <= '1';
        else
            flag_signal <= '0';
        end if;

        -- Atualiza a saída para o valor calculado internamente
        output <= internal_output;
    end process;
end Behavioral;
