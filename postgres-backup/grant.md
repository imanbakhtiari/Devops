```
ALTER ROLE username SUPERUSER;
```

```
DO
$$
DECLARE
    db RECORD;
BEGIN
    FOR db IN SELECT datname FROM pg_database WHERE datistemplate = false LOOP
        EXECUTE format('GRANT ALL PRIVILEGES ON DATABASE %I TO username;', db.datname);
        EXECUTE format('GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO username;');
        EXECUTE format('GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO username;');
        EXECUTE format('GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA public TO username;');
    END LOOP;
END
$$;
```
