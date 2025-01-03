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

# Run PostgreSQL as the new user
su - $NEW_USER -c "postgres -D /var/lib/postgresql/data --config-file=/etc/postgresql/postgresql.conf"