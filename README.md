# CPU em VHDL - Disciplina Sistema Digitais

#### Nome: Gabriel de Araujo Nusp: 14571376

#### Nome: Gabriel Demba Nusp: 156568344

#### Nome: Luis Ponciano Nusp: 15577760

Observação IMPORTANTE!
Conforme falamos por e-mail,iremos realizar algumas mudanças posteriores principalmente em como o registerCode funciona, devido a essa mudança ira alterar o assembly.py

Este projeto simula uma CPU simples utilizando VHDL, implementando um ciclo básico de instruções com unidades de controle, ALU (Unidade Lógica Aritmética), memória e registradores. A CPU executa uma série de operações lógicas e aritméticas, e é capaz de realizar operações de leitura e escrita na memória.

## Descrição do Projeto

O código define uma arquitetura de CPU com suporte a múltiplos tipos de instruções. As instruções são buscadas de uma memória ROM, decodificadas, e em seguida executadas através da ALU ou das operações de acesso à memória. O ciclo de execução segue os estágios clássicos de uma CPU:

1. **FETCH**: Busca a instrução na memória.
2. **DECODE**: Decodifica a instrução e define a operação a ser realizada.
3. **EXECUTE**: Executa a operação (ex: ALU, acesso à memória, etc.).
4. **MEM_ACCESS**: Acesso à memória, se necessário.
5. **WRITE_BACK**: Escreve o resultado de volta nos registradores ou memória.

### Componentes principais

- **ALU**: Responsável por executar operações lógicas e aritméticas (soma, subtração, AND, OR, NOT, etc.).
- **Memória**: Memória RAM simples que armazena dados e instruções.
- **Registradores**: Usados para armazenar dados temporários durante a execução.
- **PC (Program Counter)**: Registra o endereço da próxima instrução a ser executada.

## Estrutura do Código

### Entidade `cpu`

A entidade `cpu` possui os seguintes sinais e portas:

- **Entradas**:
  - `inputPlaca`: Dados de entrada para a CPU (8 bits).
  - `reset`: Sinal de reset da CPU.
  - `clk`: Sinal de clock que controla os ciclos de execução.
- **Saídas**:
  - `outputPlaca`: Dados de saída após o processamento.
  - `outputClk`: Sinal de clock para saída.

### Arquitetura `Behavioral`

A arquitetura `Behavioral` define o comportamento da CPU e seus sinais internos. A CPU é composta por um **estado de controle** e **componentes** como a ALU e memória. O estado da CPU é gerenciado por uma máquina de estados finitos (FSM), com os seguintes estados:

- **FETCH**: Busca uma instrução da memória.
- **DECODE**: Decodifica a instrução.
- **EXECUTE**: Executa a operação correspondente.
- **MEM_ACCESS**: Acessa a memória, se necessário.
- **WRITE_BACK**: Escreve resultados de volta nos registradores ou memória.

### Componentes Internos

- **ALU**: A ALU realiza operações aritméticas e lógicas (como adição, subtração, AND, OR, NOT, comparação e salto condicional).
- **Memória**: A memória (instanciada pelo componente `memoria1`) armazena dados e instruções. A leitura e escrita são controladas pelos sinais de endereço, dados e habilitação de escrita.

### Máquina de Estados

A CPU utiliza uma máquina de estados para controlar o fluxo das instruções. Alguns dos principais estados incluem:

- **FETCH**: A CPU lê uma instrução da memória, baseada no endereço armazenado no PC (Program Counter).
- **DECODE**: A CPU interpreta a instrução e identifica a operação a ser realizada.
- **EXECUTE**: A operação é executada, podendo envolver operações aritméticas com a ALU ou acesso à memória.
- **MEM_ACCESS**: A CPU pode realizar leituras ou gravações de dados na memória.
- **WRITE_BACK**: A CPU escreve o resultado da operação nos registradores ou memória.

### Componentes de Memória

A memória utilizada é implementada por meio do componente `memoria1`, que armazena dados e instruições e permite acessos de leitura e escrita controlados pelos sinais de habilitação de escrita e endereço.

## Como Funciona

A execução das instruções segue uma sequência que começa com o **FETCH** da instrução, seguida pela **DECODE** da operação, e então a execução efetiva da operação na **EXECUTE**. Dependendo do tipo da instrução, a CPU pode acessar a memória ou realizar operações aritméticas com a ALU.

A máquina de estados garante que as transições entre os diferentes estágios de execução sejam feitas de forma ordenada, utilizando os sinais de controle definidos para a ALU, os registradores e a memória.

## Instruções Suportadas

As instruções são definidas pelo `opCode` e `registerCode` extraídos das instruções. Algumas das operações suportadas incluem:

- **MOV**: Movimentação de dados entre registradores.
- **ADD**: Adição de dois valores (usando a ALU).
- **SUB**: Subtração de dois valores (usando a ALU).
- **AND**: Operação lógica AND.
- **OR**: Operação lógica OR.
- **NOT**: Operação lógica NOT.
- **JMP**: Salto incondicional.
- **JEQ**: Salto condicional, se a comparação for igual.
- **JGR**: Salto condicional, se o valor for maior.

## Exemplo de Funcionamento

1. O **Program Counter** (PC) é inicializado.
2. A CPU começa a busca da primeira instrução, ajustando o **PC** e lendo a instrução da memória.
3. A instrução é decodificada, determinando a operação a ser executada.
4. Se a instrução exigir, a CPU executa a operação usando a ALU ou acessa a memória.
5. O resultado da operação é gravado de volta nos registradores ou na memória.

## Requisitos

Este código foi implementado para ser executado em uma plataforma de simulação VHDL, como o ModelSim ou Vivado.

## Conclusão

Este projeto simula uma CPU simples com um conjunto básico de operações. Ele pode ser expandido para incluir mais instruções ou melhorias no gerenciamento de estado e controle. Além disso, pode ser adaptado para se integrar a sistemas mais complexos.


