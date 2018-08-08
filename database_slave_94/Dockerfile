FROM postgres:9.4

RUN apt-get update -qq && apt-get install -y wget sudo
RUN /bin/sh -c 'echo "deb [arch=amd64] http://packages.2ndquadrant.com/pglogical/apt/ jessie-2ndquadrant main" > /etc/apt/sources.list.d/2ndquadrant.list'
RUN wget --quiet -O - http://packages.2ndquadrant.com/pglogical/apt/AA7A6805.asc | sudo apt-key add -
RUN apt-get update -qq && apt-get install -y build-essential postgresql-client-9.4 postgresql-9.4-pgpool2 postgresql-9.4-pglogical vim
