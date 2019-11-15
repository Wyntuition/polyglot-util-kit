
-- SQL STATEMENTS RUNNING

--SELECT pid, age(clock_timestamp(), query_start), usename, query
SELECT * 
FROM pg_stat_activity 
WHERE 1=1
--and query != '<IDLE>' 
and state != 'idle'
AND query NOT ILIKE '%pg_stat_activity%' 
ORDER BY query_start desc;

-- QUERY LOCKS

SELECT
  *,
  COALESCE(blockingl.relation::regclass::text, blockingl.locktype) as locked_item,
  now() - blockeda.query_start AS waiting_duration,
  blockeda.pid AS blocked_pid,
  --blockeda.query as blocked_query,
  blockedl.mode as blocked_mode,
  blockinga.pid AS blocking_pid,
  blockinga.query as blocking_query,
  blockingl.mode as blocking_mode
FROM pg_catalog.pg_locks blockedl
JOIN pg_stat_activity blockeda ON blockedl.pid = blockeda.pid
JOIN pg_catalog.pg_locks blockingl ON(
  ( (blockingl.transactionid=blockedl.transactionid) OR
  (blockingl.relation=blockedl.relation AND blockingl.locktype=blockedl.locktype)
  ) AND blockedl.pid != blockingl.pid)
JOIN pg_stat_activity blockinga ON blockingl.pid = blockinga.pid
  AND blockinga.datid = blockeda.datid
WHERE NOT blockedl.granted
AND blockinga.datname = current_database()



select pg_describe_object(classid, objid, objsubid)
from pg_depend 
where refobjid = 'initial.initial_request'::regclass and deptype = 'n';

with recursive chain as (
    select classid, objid, objsubid, conrelid
    from pg_depend d
    join pg_constraint c on c.oid = objid
    where refobjid = 'initial.initial_request'::regclass and deptype = 'n'
union all
    select d.classid, d.objid, d.objsubid, c.conrelid
    from pg_depend d
    join pg_constraint c on c.oid = objid
    join chain on d.refobjid = chain.conrelid and d.deptype = 'n'
    )
select pg_describe_object(classid, objid, objsubid), pg_get_constraintdef(objid)
from chain;


ALTER ROLE wbvandev WITH ENCRYPTED PASSWORD 'HelloWhere101!' VALID UNTIL 'infinity'


-- DATABASE SIZES

select datname, pg_size_pretty(pg_database_size(datname))
from pg_database
order by pg_database_size(datname) desc;

-- Biggest TABLE
SELECT nspname || '.' || relname AS "relation",
    pg_size_pretty(pg_total_relation_size(C.oid)) AS "total_size"
  FROM pg_class C
  LEFT JOIN pg_namespace N ON (N.oid = C.relnamespace)
  WHERE nspname NOT IN ('pg_catalog', 'information_schema')
    AND C.relkind <> 'i'
    AND nspname !~ '^pg_toast'
  ORDER BY pg_total_relation_size(C.oid) DESC
  LIMIT 20;