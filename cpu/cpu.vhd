library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; 

entity cpu is
    Port ( inputPlaca : in  STD_LOGIC_VECTOR(7 downto 0);
           outputPlaca : out STD_LOGIC_VECTOR(7 downto 0);
			  reset : in STD_LOGIC;
			  clk			: in STD_LOGIC;
			  outputClk : out STD_LOGIC
			 );
end cpu;

architecture Behavioral of cpu is

   type state_type is (FETCH, DECODE, EXECUTE, MEM_ACCESS, WRITE_BACK, ADD1, SUB1, 
	AND1, OR1, NOT1, CMP1, PROXIMA_LINHA_ENDERECO, PROXIMA_LINHA_ENDERECO1, LOAD, LOAD1,
	STORE, STORE1, MOV, MOV1, FETCH1, LOAD2, LOAD3, LOAD4, STORE2, STORE3, STORE4, WAIT1,
	LER_IMEDIATO, LER_IMEDIATO1, LER_IMEDIATO2, LER_IMEDIATO3, CMP2, PROXIMA_LINHA_ENDERECO2);
	signal state : state_type := FETCH;    -- Estado inicial
	
	type rom_type is array (0 to 255) of STD_LOGIC_VECTOR(7 downto 0);
    
	signal pc_reg : STD_LOGIC_VECTOR(7 downto 0);
	signal instruction_reg : STD_LOGIC_VECTOR(7 downto 0);
	
	signal alu_comando : STD_LOGIC_VECTOR(3 downto 0);
	signal alu_input1: STD_LOGIC_VECTOR(7 downto 0);
	signal alu_input2: STD_LOGIC_VECTOR(7 downto 0);
	signal alu_result: STD_LOGIC_VECTOR(7 downto 0);
	signal alu_flag_0        : STD_LOGIC;
   signal alu_flag_overflow : STD_LOGIC;
   signal alu_flag_signal   : STD_LOGIC;
   signal alu_flag_carry    : STD_LOGIC;
	
	signal reg_flag_0: STD_LOGIC;
	signal reg_flag_signal : STD_LOGIC;
	
	signal temp : STD_LOGIC_VECTOR(7 downto 0);
	
   signal reg1 : STD_LOGIC_VECTOR(7 downto 0);
	signal reg2 : STD_LOGIC_VECTOR(7 downto 0);
	signal reg_data : STD_LOGIC_VECTOR(7 downto 0);
	signal address : STD_LOGIC_VECTOR(7 downto 0);
	
	signal data : STD_LOGIC_VECTOR(7 downto 0);
	
	signal opCode : STD_LOGIC_VECTOR(3 downto 0);
	signal registerCode : STD_LOGIC_VECTOR(3 downto 0);
	
	-- signals de memoria
	signal endereco : STD_LOGIC_VECTOR(7 downto 0);
	signal data_in : STD_LOGIC_VECTOR(7 downto 0);
	signal habilitar_escrita : STD_LOGIC;
	signal data_out : STD_LOGIC_VECTOR(7 downto 0);
	
	component alu
        Port (
            comando       : in STD_LOGIC_VECTOR(3 downto 0);
            input1        : in STD_LOGIC_VECTOR(7 downto 0);
            input2        : in STD_LOGIC_VECTOR(7 downto 0);
            output        : out STD_LOGIC_VECTOR(7 downto 0);
            flag_0        : out STD_LOGIC;
            flag_overflow : out STD_LOGIC;
            flag_signal   : out STD_LOGIC;
            flag_carry    : out STD_LOGIC
        );
    end component;
	
	component memoria1
			Port (
            address	: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
				clock		: IN STD_LOGIC;
				data		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
				wren		: IN STD_LOGIC;
				q		: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
        );
    end component;
	 
begin
	alu_inst : alu
        port map (
            comando       => alu_comando,
            input1        => alu_input1,
            input2        => alu_input2,
            output        => alu_result,
            flag_0        => alu_flag_0,
            flag_overflow => alu_flag_overflow,
            flag_signal   => alu_flag_signal,
            flag_carry    => alu_flag_carry
        );
	outputClk <= clk;

	memoria_inst : memoria1
        port map (
            address	=> endereco,
				clock		=> clk,
				data		=> data_in,
				wren		=> habilitar_escrita,
				q			=> data_out
        );
	outputClk <= clk;
	
   process(reset,clk)
	begin
		if reset = '1' then
            state <= FETCH;                -- Resetar o estado para FETCH
            pc_reg <= "00000000";          -- Resetar o PC
            reg_data <= "00000000";        -- Limpar dados dos registradores
            instruction_reg <= "00000000"; -- Limpar a instrução
				outputPlaca <= "00000000";
				reg1 <= "00000000";
				reg2 <= "00000000";
				state <= FETCH;
        elsif rising_edge(clk) then
                -- Etapa de Fetch
					case state is
					 when LER_IMEDIATO =>
						endereco <= std_logic_vector(unsigned(pc_reg));
						habilitar_escrita <= '0';
						state <= LER_IMEDIATO1;
					 when LER_IMEDIATO1 =>
						state <= LER_IMEDIATO2;
					 when LER_IMEDIATO2 =>
						alu_input2 <= data_out;
						state <= LER_IMEDIATO3; 	
					when LER_IMEDIATO3 =>
						case opCode is
							when "0110" =>
								state <= NOT1; -- PRECISA SER FLEXIVEL
							when "0100" =>
								state <= AND1;
							when "0101" =>
								state <= OR1;
							when "0010" =>
								state <= ADD1;
							when "0011" =>
								state <= SUB1;
							when "0111" =>
								state <= CMP1;
							when others =>
								state <= FETCH;
						end case;
					 when PROXIMA_LINHA_ENDERECO =>
						 --pc_reg <= std_logic_vector(unsigned(pc_reg) - 1); -- Atualizar o PC	
						 endereco <= std_logic_vector(unsigned(pc_reg) -1);
						 habilitar_escrita <= '0';
						 state <= PROXIMA_LINHA_ENDERECO1;
					 when PROXIMA_LINHA_ENDERECO1 =>
					    state <= PROXIMA_LINHA_ENDERECO2;
					 when PROXIMA_LINHA_ENDERECO2 =>
						 pc_reg <= data_out;
						 state <= FETCH;
                when FETCH =>
                    -- Buscar a instrução da memória (usando o PC)
						  endereco <= pc_reg;
						  habilitar_escrita <= '0';
						  state <= FETCH1;
                -- Etapa de Decode
					 when FETCH1 =>
							instruction_reg <= data_out;
							opCode <= instruction_reg(7 downto 4);
							registerCode <= instruction_reg(3 downto 0);
							state <= DECODE;
                when DECODE =>
						  case opCode is
								when "0000" => -- OUT REG1
									-- codigo
									case registerCode is
										when "0000" =>
											outputPlaca <= reg1;
										when "0001" =>
											outputPlaca <= reg2;
										when "0010" =>
											--reg_data <= alu_result;
											outputPlaca <= reg_data;
										when others =>
											state <= FETCH;
									end case;
									pc_reg <= std_logic_vector(unsigned(pc_reg) + 1); -- Atualizar o PC
									state <= FETCH;
								when "0001" => -- IN REG1
									case registerCode is
										when "0000" =>
											reg1 <= inputPlaca;
										when "0001" =>
											reg2 <= inputPlaca;
										when others =>
											state <= FETCH;
									end case;
									pc_reg <= std_logic_vector(unsigned(pc_reg) + 1); -- Atualizar o PC
									state <= FETCH;
								when "0010" => -- ADICAO ULA
									alu_comando <= "0000";
									case registerCode is
										when "0001" =>
											alu_input1 <= reg1; -- A + B
											alu_input2 <= reg2;
										when "0010" =>
											alu_input1 <= reg1; -- A + R
											alu_input2 <= reg_data;
										when "0110" =>
											alu_input1 <= reg2; -- B + R
											alu_input2 <= reg_data;
										when "0011" =>
											alu_input1 <= reg1; -- A + IMEDIATO
										when "0111" =>
											alu_input1 <= reg2; -- B + IMEDIATO
										when "1011" =>
											alu_input1 <= reg_data; -- R + IMEDIATO
										when others =>
											state <= FETCH;
									end case;
									if registerCode = "0011" or registerCode = "0111" or registerCode = "1011" then
										pc_reg <= std_logic_vector(unsigned(pc_reg) - 1);
										state <= LER_IMEDIATO;
									else
										state <= ADD1;
									end if;
								when "0011" => -- SUBTRACAO ULA
									alu_comando <= "0001";
									case registerCode is
										when "0001" => -- A - B
											alu_input1 <= reg1;
											alu_input2 <= reg2;
										when "0100" => -- B - A
											alu_input1 <= reg2;
											alu_input2 <= reg1;
										when "0010" => -- A - R
											alu_input1 <= reg1;
											alu_input2 <= reg_data;
										when "1000" => -- R - A
											alu_input1 <= reg_data;
											alu_input2 <= reg1;
										when "0110" => -- B - R
											alu_input1 <= reg2;
											alu_input2 <= reg_data;
										when "1001" => -- R - B
											alu_input1 <= reg_data;
											alu_input2 <= reg2;
										-- COM IMEDIATO -----------------------
										when "0011" => -- A - IMEDIATO
											alu_input1 <= reg1;
										when "0111" => -- B - IMEDIATO
											alu_input1 <= reg2;
										when "1011" => -- R - IMEDIATO
											alu_input1 <= reg_data;
										-- COM IMEDIATO -------------------
										when "1100" => -- IMEDIATO - A
											-- definir alu_input1 conforme a proxima linha lida
											alu_input2 <= reg1;
										when "1101" => -- IMEDIATO - B
											-- definir alu_input1 conforme a proxima linha lida
											alu_input2 <= reg2;
										when "1110" => -- IMEDIATO - R
											-- definir alu_input1 conforme a proxima linha lida
											alu_input2 <= reg_data;
										when others =>
											state <= FETCH;
									end case;
									if registerCode = "0011" or registerCode = "0111" or registerCode = "1011" then
										pc_reg <= std_logic_vector(unsigned(pc_reg) - 1);
										state <= LER_IMEDIATO;
									else
										state <= SUB1;
									end if;
								when "0100" => -- AND ULA
									alu_comando <= "0010";
									case registerCode is
										when "0001" => -- A AND B
											alu_input1 <= reg1;
											alu_input2 <= reg2;
										when "0010" => -- A AND R
											alu_input1 <= reg1;
											alu_input2 <= reg_data;
										when "0110" => -- B AND R
											alu_input1 <= reg2;
											alu_input2 <= reg_data;
										when "0011" => -- A AND IMEDIATO
											alu_input1 <= reg1;
										when "0111" => -- B AND IMEDIATO
											alu_input1 <= reg2;
										when "1011" => -- R AND IMEDIATO
											alu_input1 <= reg_data;
										when others =>
											state <= FETCH;
									end case;
									if registerCode = "0011" or registerCode = "0111" or registerCode = "1011" then
										pc_reg <= std_logic_vector(unsigned(pc_reg) - 1);
										state <= LER_IMEDIATO;
									else
										state <= AND1;
									end if;
								when "0101" => -- OR ULA
									alu_comando <= "0011";
									case registerCode is
										when "0001" => -- A OR B
											alu_input1 <= reg1;
											alu_input2 <= reg2;
										when "0010" => -- A OR R
											alu_input1 <= reg1;
											alu_input2 <= reg_data;
										when "0110" => -- B OR R
											alu_input1 <= reg2;
											alu_input2 <= reg_data;
										when "0011" => -- A OR IMEDIATO
											alu_input1 <= reg1;
											--alu_input2 <= reg_data;
										when "0111" => -- B OR IMEDIATO
											alu_input1 <= reg2;
										when "1011" => -- R OR IMEDIATO
											alu_input1 <= reg_data;
										when others =>
											state <= FETCH;
									end case;
									if registerCode = "0011" or registerCode = "0111" or registerCode = "1011" then
										pc_reg <= std_logic_vector(unsigned(pc_reg) - 1);
										state <= LER_IMEDIATO;
									else
										state <= OR1;
									end if;
								when "0110" => -- NOT ULA
									alu_comando <= "0100";
									case registerCode is
										when "0000" => -- NOT A
											alu_input2 <= reg1;
											--alu_input2 <= reg2;
										when "0001" => -- NOT B
											alu_input2 <= reg2;
											--alu_input2 <= reg_data;
										when "0010" => -- NOT R
											alu_input2 <= reg_data;
											--alu_input2 <= reg_data;
										--when "0011" => -- NOT IMEDIATO
											--state <= LER_IMEDIATO;
										when others =>
											state <= FETCH;
									end case;
									if registerCode = "0011" then
										pc_reg <= std_logic_vector(unsigned(pc_reg) - 1);
										state <= LER_IMEDIATO;
									else
										state <= NOT1;
									end if;
								when "0111" => -- COMPARE ULA
									alu_comando <= "0001";
									case registerCode is
										when "0000" =>
											alu_input1 <= reg1; -- A + B
											alu_input2 <= reg2;
										when "0001" =>
											alu_input1 <= reg1; -- A + R
											alu_input2 <= reg_data;
										when "0010" =>
											alu_input1 <= reg2; -- B + R
											alu_input2 <= reg_data;
										when "0011" => -- A OR IMEDIATO
											alu_input1 <= reg1;
											--alu_input2 <= reg_data;
										when "0111" => -- B OR IMEDIATO
											alu_input1 <= reg2;
										when "1011" => -- R OR IMEDIATO
											alu_input1 <= reg_data;
										when others =>
											state <= FETCH;
									end case;
									if registerCode = "0011" or registerCode = "0111" or registerCode = "1011" then
										pc_reg <= std_logic_vector(unsigned(pc_reg) - 1);
										state <= LER_IMEDIATO;
									else
										state <= CMP1;
									end if;
								when "1000" => -- JMP
									state <= PROXIMA_LINHA_ENDERECO;
									pc_reg <= std_logic_vector(unsigned(pc_reg) + 1);
								when "1001" => -- JEQ
									if(reg_flag_0 = '1') then
											pc_reg <= std_logic_vector(unsigned(pc_reg) + 1);
											state <= PROXIMA_LINHA_ENDERECO;
									else state <= FETCH;
									end if;
								when "1010" => -- JGR
									if(reg_flag_signal = '0' and reg_flag_0 /= '1') then
											state <= PROXIMA_LINHA_ENDERECO;
									else state <= FETCH;
									end if;
								when "1011" => -- LOAD----------------------------------------------------------------------
									endereco <= std_logic_vector(unsigned(pc_reg) - 1); -- endereco 5
									habilitar_escrita <= '0';
									state <= LOAD1;
								when "1100" => -- STORE
									endereco <= std_logic_vector(unsigned(pc_reg) - 1); -- endereco 5
									habilitar_escrita <= '0';
									state <= STORE1;
								when "1101" => -- MOVE
									case registerCode is
										when "0001" => -- reg1 para reg 2
											reg2 <= reg1;
										when "0100" => -- reg2 para reg1
											reg1 <= reg2;
										when "1000" => -- reg_data para reg1
											reg1 <= reg_data;
										when "0010" =>		-- reg1 para reg_data
											reg_data <= reg1;
										when "1001" => -- reg_data para reg2
											reg2 <= reg_data;
										when "0110" =>		-- reg2 para reg_data
											reg_data <= reg2;
										when others => 
											state <= FETCH;
									end case;
									pc_reg <= std_logic_vector(unsigned(pc_reg) + 1); -- Atualizar o PC									
									state <= FETCH;
								when others =>
									state <= FETCH;
						  end case;
					 when ADD1 =>
									reg_data <= alu_result;
									pc_reg <= std_logic_vector(unsigned(pc_reg) + 1); -- Atualizar o PC									
									state <= FETCH;
					 when SUB1 =>
									reg_data <= alu_result;
									pc_reg <= std_logic_vector(unsigned(pc_reg) + 1); -- Atualizar o PC									
									state <= FETCH;
					 when AND1 =>
									reg_data <= alu_result;
									pc_reg <= std_logic_vector(unsigned(pc_reg) + 1); -- Atualizar o PC									
									state <= FETCH;
                when OR1 =>
									reg_data <= alu_result;
									pc_reg <= std_logic_vector(unsigned(pc_reg) + 1); -- Atualizar o PC									
									state <= FETCH;
					 when NOT1 =>
									reg_data <= alu_result;
									pc_reg <= std_logic_vector(unsigned(pc_reg) + 1); -- Atualizar o PC									
									state <= FETCH;
					 when CMP1 => 
									reg_flag_0 <= alu_flag_0;
									reg_flag_signal <= alu_flag_signal;
									state <= CMP2;
					 when CMP2 =>
									pc_reg <= std_logic_vector(unsigned(pc_reg) + 1); -- Atualizar o PC									
									state <= FETCH;
					 when LOAD1 =>
								state <= LOAD2;
					 when LOAD2 =>
								endereco <= data_out;
								habilitar_escrita <= '0';
								state <= LOAD3;
					 when LOAD3 =>
								state <= LOAD4;
					 when LOAD4 =>
									case registerCode is
										when "0001" =>
											reg1 <= data_out;
										when "0010" =>
											reg2 <= data_out;
										when "0011" =>
											reg_data <= data_out;
										when others =>
											state <= FETCH;
									end case;
								state <= FETCH;
					 when STORE1 =>
								state <= STORE2;
					 when STORE2 =>
								endereco <= data_out;
								case registerCode is
									when "0001" =>
										data_in <= reg1;
									when "0010" =>
										data_in <= reg2;
									when "0011" =>
										data_in <= reg_data;
									when others =>
										state <= FETCH;
								end case;
								habilitar_escrita <= '1';
								state <= STORE3;
					 when STORE3 =>
								state <= STORE4;
					 when STORE4 =>
								state <= FETCH;	 
					 when others =>
                    state <= FETCH;  -- Caso não entre em nenhum estado conhecido, voltar para Fetch
				end case;
        end if;
		
	end process;
end Behavioral;
