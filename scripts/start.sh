#! /bin/bash

# Start cron service
service cron start &

# Create a new user with a password if it doesn't exist
NEW_USER="postgres_user"
NEW_USER_PASSWORD=$POSTGRES_PASSWORD

if id "$NEW_USER" &>/dev/null; then
    echo "User $NEW_USER already exists."
else
    useradd -m $NEW_USER
    echo "$NEW_USER:$NEW_USER_PASSWORD" | chpasswd
    echo "User $NEW_USER created."
fi

# Change ownership of PostgreSQL data directory
chown -R $NEW_USER:$NEW_USER /var/lib/postgresql/data

# Ensure the PostgreSQL configuration directory is owned by the new user
chown -R $NEW_USER:$NEW_USER /etc/postgresql

# Run PostgreSQL as the new user
exec su - $NEW_USER -c "/usr/lib/postgresql/$(pg_config --version | cut -d ' ' -f 2)/bin/postgres -D /var/lib/postgresql/data --config-file=/etc/postgresql/postgresql.conf"