ALTER SYSTEM SET wal_level = logical;
ALTER TABLE table1 REPLICA IDENTITY FULL;