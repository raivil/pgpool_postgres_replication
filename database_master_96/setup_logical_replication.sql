\c example_db


CREATE EXTENSION pglogical;
SELECT pglogical.create_node(
    node_name := 'subscriber1',
    dsn := 'host=database_master_96 port=5432 dbname=example_db user=postgres password=mysecretpassword'
);

SELECT pglogical.create_subscription(
    subscription_name := 'subscription1',
    provider_dsn := 'host=database_master port=5432 dbname=example_db user=postgres password=mysecretpassword',
    synchronize_structure := true,
    synchronize_data := true
);

select count(1) from t_random;
