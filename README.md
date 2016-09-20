## Start instances in order.

# Master Database

```
$ docker-compose down && docker-compose build database_master && docker-compose up database_master
```

#Slave Database

```
$ docker-compose rm -f database_slave  && docker-compose build database_slave && docker-compose up database_slave
```

- Simulate a simple error with standby instance.
```
Comment all lines on /usr/lib/postgresql/data/pg_hba.conf
su postgres -c "/usr/lib/postgresql/9.4/bin/pg_ctl reload"
```

# Load Balancer
```
$ docker-compose rm -f loadbalancer  && docker-compose build loadbalancer  && docker-compose up loadbalancer
```
