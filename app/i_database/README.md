# Automatizando_a_documentacao_do_ambiente_de_banco_de_dados

### Objetivo:
Este dicionário tem como função primária listar todos os servidores de bancos de dados e seus objetos internos, disponibilizando ao operador uma visão geral do ambiente e o significado dos meta dados dos bancos.

#### [Manual de implantação do projeto:](https://github.com/maxabelardo/monitodatabase/blob/master/DicionarioDeDados/Scripts%20do%20banco/manual_de_instala%C3%A7%C3%A3o.md)
#### [Conhecendo o  banco de dados de destino.](https://github.com/maxabelardo/monitodatabase/tree/master/DicionarioDeDados/Scripts%20do%20banco)

#### [Conhecendo o metodo de ETL utilizado no projeto.](https://github.com/maxabelardo/monitodatabase/blob/master/DicionarioDeDados/Scripts%20do%20banco/Conhecendo%20o%20metodo%20de%20ETL%20utilizado.md)


### Descrição:
Será criado uma estrutura automatizada que armazene todos os meta dados das bases de dados e suas estruturas internas, a documentação será atualizada de modo constante, por jobs e ETL de extração, sem intervenção manual.

### Topologia:
O ambiente será composto por dois servidores:
*   Servidor de banco de dados (MS SQL Server); e
*   servidor de ETL's. (SSIS e JOBS do SQL Agent).

### Dados que serão extraídos dos servidores:
* Configuração interna do SGBD:
  * CPU disponível para instância.
  * Memória configurada para instância.
  * Discos "HD":
    * Volumetria Total (Gb);
    * Espaço utilizado (Gb); e
    * Espaço livre (Gb).
   
* Lista de todas as bases de dados:
  * Nome;
  * Owner;
  * Volume (Mb);
  * Data de criação; e
  * outras.
 
* Lista das tabelas de cada base de dados.
* Lista das colunas.
* Lista dos index.

## As informações serão apresentadas por painéis e relatórios dentro do Power BI.
O Power BI oferece a capacidade de criar relatórios acessíveis, conectando facilmente os dados, modelá-los e visualizá-los para criar relatórios que forneçam insights a fim de tomar decisões melhores.
É utilizado o Power BI Desktop, em sua versão imediatamente anterior a última versão existente. No momento é usada a versão 2.100.1381.0 64-bit (janeiro de 2022).
*  Nos painéis disponíveis aqui são usados os seguintes padrões de cores e fontes:
   * Fundo de página: #E6E6E6 (cinza), saturação 32%;
   * Título de página: Segoe UI Light, tamanho 28, #667996 (azul);
   * Fundo dos Gráficos e Cartões: #FFFFFF (branco);
   * Rótulo dos Cartões: Segoe UI, tamanho 12, #666666 (cinza escuro);
   * Rótulo de dados dos Cartões: Segoe UI, tamanho 32, #667996 (azul);
   * Cores para visuais: #667996 (azul) e #E66C37 (laranja);
   * Título dos Gráficos: Segoe UI Light, tamanho 14, #000000 (preto); e
   * Rótulo de dados dos Gráficos: Segoe UI, tamanho 10 em negrito, #FFFFFF (branco).

### Painéis quantitativos:
![image](docs/imagens/dg_de_dados00.PNG)

Neste primeiro painel são apresentados cartões com os totais de: 
* Servidores (em quantidade);
* Base de Dados (em quantidade);
* Volume de dados (em Tb).

Nos gráficos são apresentadas as seguintes informações: 
* Versões dos Servidores de banco utilizando gráfico de barras empilhadas - barChart (em quantidade);
* Gráfico a ser criado;
* Base de Dados utilizando gráfico de Pizza - pieChart (em porcentagem);
* Volume de Dados utilizando gráfico de barras empilhadas - barChart (em quantidade - exibido em milhões); e
* Servidores por Localidade utilizando Matriz - pivotTable (em quantidade).

### Painéis qualitativos:
* [nova imagem]()
* Gráficos a serem criados após análise das demais informações.

### Relatórios:
* [nova imagem]()
* Relatórios a serem criados após análise das demais informações.

