FROM centos:centos7

ENV PGHOME /var/lib/pgsql
ENV POSTGRESQL_VERSION 9.4
ENV POSTGRESQL_VERSION2 94
ENV RPM pgpool-II-pg94-3.4.7-1pgdg.rhel7.x86_64.rpm
ENV DEV_RPM pgpool-II-pg94-devel-3.4.7-1pgdg.rhel7.x86_64.rpm
ENV EXTENSION_RPM pgpool-II-pg94-extensions-3.4.7-1pgdg.rhel7.x86_64.rpm

RUN yum update -y

# Install PostgreSQL packages
RUN yum install -y wget
RUN wget http://yum.postgresql.org/9.4/redhat/rhel-7-x86_64/pgdg-centos94-9.4-1.noarch.rpm
RUN rpm -ivh pgdg-centos94-9.4-1.noarch.rpm
RUN yum install -y postgresql${POSTGRESQL_VERSION2}-devel postgresql${POSTGRESQL_VERSION2} postgresql${POSTGRESQL_VERSION2}-server postgresql${POSTGRESQL_VERSION2}-contrib

# Install pgpool-II packages
RUN yum install -y libmemcached systemd-sysv
RUN wget http://www.pgpool.net/yum/rpms/3.4/redhat/rhel-7-x86_64/${RPM} -O /tmp/${RPM}
RUN rpm -ivh /tmp/${RPM}
RUN wget http://www.pgpool.net/yum/rpms/3.4/redhat/rhel-7-x86_64/${DEV_RPM} -O /tmp/${DEV_RPM}
RUN rpm -ivh /tmp/${DEV_RPM}
RUN wget http://www.pgpool.net/yum/rpms/3.4/redhat/rhel-7-x86_64/${EXTENSION_RPM} -O /tmp/${EXTENSION_RPM}
RUN rpm -ivh /tmp/${EXTENSION_RPM}

# Install necessary packages for pgpool_setup
RUN yum install -y ed vi which openssh-server openssh-clients tar memcached-devel
RUN yum install -y rsync

# # Setup postgres account
# ENV BASHPROFILE .bash_profile
# RUN echo "PATH=/usr/pgsql-${POSTGRESQL_VERSION}/bin:$PATH" >> $PGHOME/$BASHPROFILE
# RUN echo "PATH=$PATH:/usr/pgsql-${POSTGRESQL_VERSION}/bin" >> /root/$BASHPROFILE
# RUN echo "export PGBIN=/usr/${POSTGRESQL_VERSION}/bin" >> $PGHOME/$BASHPROFILE
RUN mkdir -p /etc/pgpool-II && \
  mkdir -p /var/run/pgpool && \
  mkdir -p /var/log/pgpool

RUN chown -R postgres:postgres /etc/pgpool-II && \
  chown -R postgres:postgres /var/log/pgpool && \
  chown -R postgres:postgres /var/run/pgpool

# TODO: mount files as volumes
ADD pgpool/pool_passwd /etc/pgpool-II/
ADD pgpool/pcp.conf /etc/pgpool-II/
ADD pgpool/pgpool.conf /etc/pgpool-II/
ADD pgpool/pool_hba.conf /etc/pgpool-II/

RUN chmod 600 /etc/pgpool-II/pool_passwd && chown postgres:postgres /etc/pgpool-II/pool_passwd

CMD ["pgpool", "-dnf", "/etc/pgpool-II/pgpool.conf"]
