#!/bin/bash -ve
echo "Stop postgres and clean up old cluster directory"
gosu postgres pg_ctl -D "$PGDATA" -m fast -w stop

rm -rf ${PGDATA}/*

echo "Starting base backup as replicator and creating recovery.conf file"
gosu postgres pg_basebackup \
      --write-recovery-conf \
      --pgdata="$PGDATA" \
      --xlog-method=fetch \
      --username=$REP_USER \
      --host=database_master \
      --progress \
      --verbose

echo "Creating pg_hba.conf..."
sed -e "s/\${REP_USER}/$REP_USER/" \
    -e "s/\${DB_NAME}/$DB_NAME/" \
    -e "s/\${DB_USER}/$DB_USER/" \
    /tmp/postgresql/pg_hba.conf \
    > $PGDATA/pg_hba.conf
echo "Creating pg_hba.conf complete."

echo "Updating postgresql.conf..."
cp /tmp/postgresql/postgresql.conf $PGDATA/postgresql.conf
cat >> $PGDATA/postgresql.conf <<EOS
hot_standby = on
hot_standby_feedback = on
wal_receiver_status_interval = 1
EOS

mkdir /var/lib/postgresql/archive
chown postgres:postgres /var/lib/postgresql/archive
chown -R postgres:postgres ${PGDATA}

echo "Starting postgres"
#exec restart so the defautl script will stop this and continue.
gosu postgres pg_ctl -D "$PGDATA" \
         -o "-c listen_addresses=''" \
         -w start
