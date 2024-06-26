
Practical PostgreSQL Logical Replication: Setting Up an Experimentation Environment Using Docker
https://dev.to/ietxaniz/practical-postgresql-logical-replication-setting-up-an-experimentation-environment-using-docker-4h50

services:
  master:
    image: postgres:16.1-alpine3.19
    container_name: logrepl_pg_master
    volumes:
      - logrepl_pg_master-data:/var/lib/postgresql/data
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres
      POSTGRES_DB: postgres
    restart: unless-stopped
  replica1:
    image: postgres:15.5-alpine3.19
    container_name: logrepl_pg_replica1
    volumes:
      - logrepl_pg_replica1-data:/var/lib/postgresql/data
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres
      POSTGRES_DB: postgres
    restart: unless-stopped
  replica2:
    image: postgres:14.10-alpine3.19
    container_name: logrepl_pg_replica2
    volumes:
      - logrepl_pg_replica2-data:/var/lib/postgresql/data
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres
      POSTGRES_DB: postgres
    restart: unless-stopped
volumes:
  logrepl_pg_master-data:
    name: logrepl_pg_master-data
  logrepl_pg_replica1-data:
    name: logrepl_pg_replica1-data
  logrepl_pg_replica2-data:
    name: logrepl_pg_replica2-data

docker compose up    