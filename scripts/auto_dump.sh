#! /bin/bash

DEST="/postgres_backup/$(date +%F_%R)"
pg_dumpall > $DEST/all_databases.sql

# Delete backups created 14 or more days ago
find /postgres_backup -mindepth 1 -ctime +14 -delete