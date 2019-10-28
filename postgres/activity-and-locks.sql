
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