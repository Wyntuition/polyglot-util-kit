-- PG obj tables
select * from pg_index
select * from pg_indexes where schemaname='local_mod'
select * from pg_class
select * from pg_catalog.pg_namespace
select * from pg_namespace
select * from information_schema.tables

-- Index info
select * from pg_stat_user_indexes

-- Transaction info
SELECT
   (SELECT sum(xact_commit) + sum(xact_rollback) FROM pg_stat_database WHERE datname = (SELECT datname FROM pg_database WHERE oid = 1)) AS "Transactions",
   (SELECT sum(xact_commit) FROM pg_stat_database WHERE datname = (SELECT datname FROM pg_database WHERE oid = 1)) AS "Commits",
   (SELECT sum(xact_rollback) FROM pg_stat_database WHERE datname = (SELECT datname FROM pg_database WHERE oid = 1)) AS "Rollbacks"

