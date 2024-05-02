# Apache Airflow



## Instalação do apache Airflow no docker.

[Manual de instalação](https://airflow.apache.org/docs/apache-airflow/stable/howto/docker-compose/index.html#fetching-docker-compose-yaml)

Baixar o arquivo de instalação:
https://airflow.apache.org/docs/apache-airflow/2.8.0/docker-compose.yaml


Crier os diretorio dos volumes:
- ./dags- você pode colocar seus arquivos DAG aqui.

- ./logs- contém logs de execução de tarefas e agendador.

- ./config- você pode adicionar um analisador de log personalizado ou adicionar airflow_local_settings.pypara configurar a política de cluster.

- ./plugins- você pode colocar seus plugins personalizados aqui.

Criar os containes:
```` 
docker compose -f docker-compose.yaml up -d
```` 
ou 
```` 
docker compose up airflow-init
````