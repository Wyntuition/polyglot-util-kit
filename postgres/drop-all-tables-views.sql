-- Drop views by FILTER (change to .tables for tables)

DO
$func$
DECLARE
    rec record;
    normalized_table varchar(100);
BEGIN
    FOR rec IN 
        (SELECT * FROM information_schema.views
        WHERE table_schema = 'public')
    LOOP
    	EXECUTE format('drop VIEW if exists public.%I', rec.table_name);
    END LOOP;
END;
$func$
LANGUAGE plpgsql;