#!/bin/bash -ve
echo "Creating pg_hba.conf... ${REP_USER}"
sed -e "s/\${REP_USER}/$REP_USER/" \
    -e "s/\${DB_NAME}/$DB_NAME/" \
    -e "s/\${DB_USER}/$DB_USER/" \
    /tmp/postgresql/pg_hba.conf \
    > $PGDATA/pg_hba.conf
echo "Creating pg_hba.conf complete."

echo "Creating postgresql.conf..."
cp /tmp/postgresql/postgresql.conf $PGDATA/postgresql.conf

echo "Creating replication user..."
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
    CREATE ROLE ${REP_USER} PASSWORD 'md5${REP_PASS_MD5}' REPLICATION LOGIN;
EOSQL
echo "Creating replication user complete."

echo "Creating example database..."
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
   CREATE DATABASE ${DB_NAME};
   CREATE ROLE ${DB_USER} PASSWORD 'md5${DB_PASS_MD5}' SUPERUSER LOGIN;
   GRANT ALL PRIVILEGES ON DATABASE ${DB_NAME} to ${DB_USER};
EOSQL
echo "Creating example database complete."

echo "Creating pgpool database and extensions..."
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
   CREATE ROLE pgpool PASSWORD 'abc123' SUPERUSER LOGIN;
   CREATE DATABASE pgpool owner pgpool;
   GRANT ALL PRIVILEGES ON DATABASE ${DB_NAME} to pgpool;
   CREATE EXTENSION pgpool_regclass;
   CREATE EXTENSION pgpool_recovery;
   CREATE EXTENSION pgpool_adm;
EOSQL
echo "Creating PGPOOL database/extensions complete."

mkdir /var/lib/postgresql/archive
chown postgres:postgres /var/lib/postgresql/archive
chown -R postgres:postgres ${PGDATA}
