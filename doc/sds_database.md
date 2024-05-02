# Modulo: Sentinel Database:

**Prefácio Resumido:**

Neste prefácio, o Administrador de Banco de Dados (DBA) enfrenta desafios ao criar e manter a documentação de servidores de bancos de dados. A desconfiança do cliente surge quando informações não estão disponíveis ou estão desatualizadas. Diante da falta de ferramentas adequadas, nasce este projeto, inicialmente composto por scripts locais. Evoluindo além da mera documentação, o projeto visa lidar com dados como um ativo crucial, abrindo portas para iniciativas mais amplas, como Governança de Dados e Análise de Dados, em um cenário onde os dados corporativos são considerados o ativo mais valioso.

**Introdução Aprimorada:**

No cenário corporativo, o conhecimento profundo de ativos e dados é o ponto de partida essencial para uma gestão eficaz. O mapeamento abrangente de ativos não apenas lança as bases para estratégias de defesa, monitoramento, segurança, auditoria e resposta a incidentes, mas também facilita a manutenção, rastreamento e recuperação ágil de ativos e seus dados.

O mapeamento de ativos, focalizado neste projeto nos servidores de banco de dados, instâncias e bancos de dados, abrange uma lista detalhada de configurações, softwares instalados, permissões de acesso e níveis de usuário. Este projeto visa implementar rotinas automatizadas para coleta, atualização e rastreamento contínuo de metadados, respondendo eficientemente a novas informações ou alterações no ambiente. Os dados coletados serão enriquecidos através de cruzamento com outras fontes, resultando em uma documentação precisa e próxima da realidade, minimizando qualquer defasagem. Este processo integrado proporcionará uma visão abrangente e em tempo real do ambiente de servidores de banco de dados.

Metricas: 

__Dados comum a todos os SGBD valores quantitativos__
+ quantidade de servidores por sgbd
+ quantidade de servidores por versões do sgbd
+ mapa demostrando a quantidade de instância por regiao e localidade
+ volume total de dados
+ volume de dados por servidor
+ total de bases
+ bases por servidor
+ taxa de utilização servidores
+ top 10 de servidores mais acessados
+ top 10 de bases mais acessadas

__Qualitativo:__
+ Lista de servidore de banco de dados.
+ Lista das base de dados.
+ Lista de tabelas.
+ Lista de colunas.
+ Lista dos index.
+ Lista de usuários.
+ Lista de usuários com o seu acesso
    + servidor.
    + Instancia.
    + Base de dados.


__Filtros:__
	busca por servidor
	base de dados
	tabela e coluna
	por usuário com acesso ao:
		servidor
		instância
		base de dados
		tabela e coluna
		
__Relatório de auditoria:__
+ Relação de usuários com acesso administrativo ao sgbd.
+ Base de dados com acesso publico.
+ Base de dados sem acesso a mais de 90 dias.


__Alertas:__
+ configuraçoes fora dos padroes especificados.
+ uso de memoria.
+ uso do bufe. 		
+ uso de cpu.
+ taixa de crescimento alta 
+ acesso fora do comum:
	+ alta leitura de dados feita por usuários que não costuma executar esta tarefa.
	+ consultas foram do normal.
	+ acesso ao servidore de locais normamente não são acessados.
	
	