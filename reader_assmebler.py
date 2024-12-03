import os

# Mapeamento das instruções Assembly para binário
INSTRUCTION_TO_BINARY = {
    'IN': '0001',
    'MOV': '1101',
    'STORE': '1100',
    'LOAD': '1011',
    'ADD': '0010',
    'SUB': '0011',
    'CMP': '0111',
    'JGR': '1010',
    'JEQ': '1001',
    'JMP': '1000',
    'OUT': '0000',
    'WAIT': '00001011'
}

# Mapeamento dos registradores
REGISTER_TO_BINARY = {
    'A': '0000',
    'B': '0001',
    'R': '00000011',
    '255': '11111111'  # Para o endereço 255
}

# Cabeçalho padrão do arquivo MIF
MIF_HEADER = """
-- Copyright (C) 2021  Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions 
-- and other software and tools, and any partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Intel Program License 
-- Subscription Agreement, the Intel Quartus Prime License Agreement,
-- the Intel FPGA IP License Agreement, or other applicable license
-- agreement, including, without limitation, that your use is for
-- the sole purpose of programming logic devices manufactured by
-- Intel and sold by Intel or its authorized distributors.  Please
-- refer to the applicable agreement for further details, at
-- https://fpgasoftware.intel.com/eula.

-- Quartus Prime generated Memory Initialization File (.mif)

WIDTH=8;
DEPTH=256;

ADDRESS_RADIX=DEC;
DATA_RADIX=BIN;

CONTENT BEGIN
"""

# Rodapé padrão do arquivo MIF
MIF_FOOTER = "END;"

# Função para converter uma linha Assembly para binário
def convert_line_to_binary(line):
    parts = line.split()
    if not parts:
        return None  # Ignora linhas vazias

    instruction = parts[0].upper()
    if instruction in INSTRUCTION_TO_BINARY:
        binary = INSTRUCTION_TO_BINARY[instruction]
        # Adiciona operandos, se houver
        if len(parts) > 1:
            operands = parts[1:]
            for operand in operands:
                if operand.isdigit():  # Caso seja número
                    binary += format(int(operand), '08b')
                else:  # Caso seja um registrador
                    binary += REGISTER_TO_BINARY.get(operand.upper(), '00000000')
        return binary.ljust(8, '0')  # Garante 8 bits para instruções sem operandos
    return None  # Instrução desconhecida

def process_assembler_file(file_path):
    if not os.path.isfile(file_path):
        print(f"Erro: Arquivo não encontrado -> {file_path}")
        return
    
    print(f"Lendo o arquivo: {file_path}")
    mif_content = [f"\t{i} : 00000000;" for i in range(256)]  # Inicializa memória com zeros
    address = 0

    try:
        with open(file_path, 'r') as file:
            for line in file:
                line = line.split(';')[0].strip()  # Remove comentários e espaços
                # Ignora linhas vazias
                if not line:
                    continue

                binary = convert_line_to_binary(line)
                if binary:
                    mif_content[address] = f"\t{address} : {binary};"
                    address += 1
                    if address >= 256:
                        print("Aviso: Memória excedida, truncando instruções.")
                        break
    except Exception as e:
        print(f"Erro ao processar o arquivo: {e}")
        return

    # Escreve o arquivo MIF de saída
    output_file = file_path.replace('.s', '.mif')
    try:
        with open(output_file, 'w') as output:
            output.write(MIF_HEADER)
            output.write("\n".join(mif_content))
            output.write(f"\n{MIF_FOOTER}\n")
        print(f"Arquivo MIF gerado com sucesso: {output_file}")
    except Exception as e:
        print(f"Erro ao escrever o arquivo MIF: {e}")


# Função principal
def main():
    file_path = input("Digite o nome do arquivo Assembly (.s): ").strip()
    if file_path:
        process_assembler_file(file_path)
    else:
        print("Erro: Nenhum arquivo especificado.")

# Chama a função principal
if __name__ == "__main__":
    main()