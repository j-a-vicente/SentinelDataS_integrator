

mkdir -R /data/postgres_data

docker pull postgres:15.5

docker volume create --driver local --opt type=none --opt device=/data/postgres_data --opt o=bind postgres_data

docker run --name PostgreSQL -t \
      -e DB_SERVER_HOST="postgres-server" \
      -e POSTGRES_USER="Sentinel" \
      -e POSTGRES_PASSWORD="Sentinel" \
      -e POSTGRES_DB="SentinelDataSuite" \
      --network=airflow_default \
      -p 5432:5432 \
      -v postgres_data:/var/lib/postgresql/data \
	  postgres:15.5