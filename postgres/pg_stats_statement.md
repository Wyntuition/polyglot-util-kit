1) see re: increasing shmmax http://stackoverflow.com/a/10629164/1283020

2) add to postgresql.conf:
shared_preload_libraries = 'pg_stat_statements'   # (change requires restart)
136 pg_stat_statements.max = 1000
137 pg_stat_statements.track = all

3) restart postgres

4) check it out in psql
psql: CREATE EXTENSION pg_stat_statements;
psql: \x
psql: SELECT query, calls, total_time, rows, 100.0 * shared_blks_hit /



## Enabling it in a conatiner with docker-compose

etl-db:
    container_name: db
    image: postgres:9.6
    networks:
      - my-network
    ports:
      - "5432:5432"
    volumes:
      - pgdata:/var/lib/postgresql/data
      - ./postgresql-dev.conf:/etc/postgresql.conf
    command: postgres -c config_file=/etc/postgresql.conf
    environment:
      POSTGRES_USER: ${PG_USERNAME}
      POSTGRES_PASSWORD: ${PG_PASSWORD}
      POSTGRES_DB: db
