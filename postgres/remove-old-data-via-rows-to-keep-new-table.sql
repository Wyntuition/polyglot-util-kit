-- The LIKE clause to the CREATE TABLE statement is quite useful since this can automatically include all indexes, constraints, defaults, comments, and storage options. It does NOT include ownership or privileges however, so the one critical step in this piece is definitely #2 above. You can easily see a table’s privileges with the \dp option in psql. Also, explicitly obtaining the exclusive lock on both tables before doing the name switch ensures nothing weird happens during whatever brief moment could exist between the switch.

CREATE TABLE public.notifications_new (LIKE public.notifications INCLUDING ALL);
 
ALTER TABLE public.notifications_new OWNER TO sysadmin;
 
GRANT select ON public.notifications_new TO read_only
GRANT select, insert, update, delete ON public.notifications TO app_user;
GRANT all ON public.notifications TO admin;
 
ALTER TABLE public.notifications INHERIT public.notifications_new;
 
BEGIN;
LOCK TABLE public.notifications IN ACCESS EXCLUSIVE MODE;
LOCK TABLE public.notifications_new IN ACCESS EXCLUSIVE MODE;
ALTER TABLE public.notifications RENAME TO notifications_old;
ALTER TABLE public.notifications_new RENAME TO notifications;
 
COMMIT;  -- (or ROLLBACK; if there's a problem)

-- Once all these steps are done, you can then begin the process of moving your more recent data out of the old table and into the new via whichever method works best for you. One easy method to batch this is a CTE query that does the DELETE/INSERT with a SELECT in a single query to limit the rows moved.

WITH row_batch AS (
    SELECT id FROM public.notifications_old WHERE updated_at >= '2016-10-18 00:00:00'::timestamp LIMIT 20000 ),
delete_rows AS (
    DELETE FROM public.notifications_old o USING row_batch b WHERE b.id = o.id RETURNING o.id, account_id, created_at, updated_at, resource_id, notifier_id, notifier_type)
INSERT INTO public.notifications SELECT * FROM delete_rows;

-- And once that’s done, you can then DROP the old table, instantly recovering all that disk space with minimal WAL traffic and zero bloat aftermath. SOURCE: https://www.keithf4.com/removing-old-data/
