#! /bin/bash

service cron start &
postgres -D /var/lib/postgresql/data --config-file=/etc/postgresql/postgresql.conf