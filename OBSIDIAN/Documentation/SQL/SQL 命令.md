#sql 
update
```sql
UPDATE public.data_connection

SET connection_string = replace(connection_string, 'proxyurl=https://sypqliksense06.lenovo.com/codata/','proxyurl=https://app18.qliksense.lenovo.com/codata/') 

WHERE connection_string like '%proxyurl=https://sypqliksense06.lenovo.com/codata/%';
```

select
```sql
SELECT name, connection_string
FROM public.data_connection
    WHERE name like '%NA %';
```

showtables
```sql
select tablename from pg_tables where schemaname='public'
```
