Example configurations for Postgresql running on Docker containers with streaming and logical replication

Containers running:
 - Postgresq 9.4 Master Instance
 - Postgresq 9.6 With Logical Replication from Master 9.4
 - [TODO] Postgresq 10 With Logical Replication from Master 9.6
 - [TODO] Postgresq 11 With Logical Replication from Master 9.6


## Start instances.

## Master Databases
```
$ docker-compose down
$ docker-compose build database_master_94 database_master_96 database_master_11
$ docker-compose up database_master_94 database_master_96 database_master_11
```

## Set up logical replication:

On master (9.4)

```
$  docker-compose -f docker-compose.yml exec database_master_94 bash
root@770bfb0bca84:/# su -l postgres
No directory, logging in with HOME=/
postgres=# \i /tmp/postgresql/setup_logical_replication.sql
You are now connected to database "example_db" as user "postgres".
SELECT 50000
ALTER TABLE
INSERT 0 50000
CREATE EXTENSION
CREATE EXTENSION
 create_node
-------------
  1825523624
(1 row)

 replication_set_add_all_tables
--------------------------------
 t
(1 row)

 replication_set_add_all_sequences
-----------------------------------
 t
(1 row)

example_db=# insert into t_random select s, md5(random()::text) from generate_Series(1,123) s;
INSERT 0 123
example_db=# select count(1) from t_random;
 count
--------
 100123
(1 row)

```


On master 9.6

```
$ docker-compose -f docker-compose.yml exec database_master_96 bash
root@ec623283174f:/# su -l postgres
No directory, logging in with HOME=/
$ psql
psql (9.6.1)
Type "help" for help.

postgres=# \i /tmp/postgresql/setup_logical_replication.sql
You are now connected to database "example_db" as user "postgres".
CREATE EXTENSION
 create_node
-------------
   330520249
(1 row)

 create_subscription
---------------------
          1763399739
(1 row)

example_db=# select count(1) from t_random;
 count
--------
 100000
(1 row)

example_db=# select count(1) from t_random;
 count
--------
 100123
(1 row)

```
