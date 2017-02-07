\c example_db
create table t_random as select s, md5(random()::text) from generate_Series(1,50000) s;
alter table t_random add column id serial primary key;

insert into t_random select s, md5(random()::text) from generate_Series(1,50000) s;


CREATE EXTENSION pglogical_origin;
CREATE EXTENSION pglogical;
SELECT pglogical.create_node(
    node_name := 'master_provider',
    dsn := 'host=master_database port=5432 dbname=example_db user=postgres password=mysecretpassword'
);


SELECT pglogical.replication_set_add_all_tables('default', schema_names:= ARRAY['public'], synchronize_data := true);
SELECT pglogical.replication_set_add_all_sequences('default', schema_names:= ARRAY['public'], synchronize_data := true);
