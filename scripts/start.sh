#! /bin/bash

# Start cron service
service cron start &

# Create a new user with a password if it doesn't exist
NEW_USER="postgres"
NEW_USER_PASSWORD=$POSTGRES_PASSWORD

if id "$NEW_USER" &>/dev/null; then
    echo "User $NEW_USER already exists."
    echo "$NEW_USER:$NEW_USER_PASSWORD" | chpasswd
    echo "Password updated."
else
    useradd -m $NEW_USER
    echo "$NEW_USER:$NEW_USER_PASSWORD" | chpasswd
    echo "User $NEW_USER created."
fi

# Define the PostgreSQL data directory
DATA_DIR="/var/lib/postgresql/data/pgdata"

# Find the initdb binary
INITDB_BIN=$(which initdb)

# Initialize the PostgreSQL data directory if it is not already initialized
if [ ! -s "$DATA_DIR/PG_VERSION" ]; then
    # Ensure the directory is empty before initializing
    rm -rf "$DATA_DIR/*"
    su - $NEW_USER -c "$INITDB_BIN -D $DATA_DIR"

    # Edit pg_hba.conf to allow connections from the Docker network subnet using scram-sha-256
    echo "host    all             all             172.18.0.0/16            scram-sha-256" >> "$DATA_DIR/pg_hba.conf"

    # Edit postgresql.conf to listen on all addresses
    echo "listen_addresses = '*'" >> "$DATA_DIR/postgresql.conf"
fi

# Change ownership and permissions of PostgreSQL data directory
chown -R $NEW_USER:$NEW_USER $DATA_DIR
chmod 700 $DATA_DIR

# Ensure the PostgreSQL configuration directory is owned by the new user
chown -R $NEW_USER:$NEW_USER /etc/postgresql

# Ensure the PostgreSQL configuration file exists
if [ ! -f "$DATA_DIR/postgresql.conf" ]; then
    cp /usr/share/postgresql/postgresql.conf.sample "$DATA_DIR/postgresql.conf"
    chown $NEW_USER:$NEW_USER "$DATA_DIR/postgresql.conf"
fi

# Run PostgreSQL as the new user using gosu
exec gosu $NEW_USER postgres -D $DATA_DIR