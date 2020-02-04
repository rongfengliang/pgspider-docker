FROM debian:stretch-slim
RUN apt-get update && apt-get install -y build-essential wget libreadline-dev  zlib1g-dev
WORKDIR /app
ENV GOSU_VERSION 1.11

# explicitly set user/group IDs
RUN set -eux; \
	groupadd -r postgres --gid=999; \
# https://salsa.debian.org/postgresql/postgresql-common/blob/997d842ee744687d99a2b2d95c1083a2615c79e8/debian/postgresql-common.postinst#L32-35
	useradd -r -g postgres --uid=999 --home-dir=/var/lib/postgresql --shell=/bin/bash postgres; \
# also create the postgres user's home directory with appropriate permissions
# see https://github.com/docker-library/postgres/issues/274
	mkdir -p /var/lib/postgresql; \
	chown -R postgres:postgres /var/lib/postgresql

RUN wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture)" \
   && chmod +x /usr/local/bin/gosu \
   && gosu nobody true
# make the "en_US.UTF-8" locale so postgres will be utf-8 enabled by default
RUN set -eux; \
   if [ -f /etc/dpkg/dpkg.cfg.d/docker ]; then \
   # if this file exists, we're likely in "debian:xxx-slim", and locales are thus being excluded so we need to remove that exclusion (since we need locales)
   grep -q '/usr/share/locale' /etc/dpkg/dpkg.cfg.d/docker; \
   sed -ri '/\/usr\/share\/locale/d' /etc/dpkg/dpkg.cfg.d/docker; \
   ! grep -q '/usr/share/locale' /etc/dpkg/dpkg.cfg.d/docker; \
   fi; \
   apt-get update; apt-get install -y locales; rm -rf /var/lib/apt/lists/*; \
   localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8

# install "nss_wrapper" in case we need to fake "/etc/passwd" and "/etc/group" (especially for OpenShift)
# https://github.com/docker-library/postgres/issues/359
# https://cwrap.org/nss_wrapper.html
RUN set -eux; \
   apt-get update; \
   apt-get install -y --no-install-recommends libnss-wrapper; \
   rm -rf /var/lib/apt/lists/*

RUN mkdir /docker-entrypoint-initdb.d
RUN wget https://ftp.postgresql.org/pub/source/v11.6/postgresql-11.6.tar.gz
RUN tar xvf postgresql-11.6.tar.gz
COPY pgspider/pgspider.patch /app/pgspider.patch
RUN patch -p1 -d postgresql-11.6 < /app/pgspider.patch
COPY Makefile postgresql-11.6/contrib/pgspider_core_fdw/Makefile
RUN cd postgresql-11.6 \
   && ./configure \
   && make && make install \
   && cd /app/postgresql-11.6/contrib/pgspider_core_fdw \
   && make && make install \
   && cd /app/postgresql-11.6/contrib/pgspider_fdw \ 
   && make && make install \
   && cd /app/postgresql-11.6/contrib \ 
   && make && make install \
   && rm -rf /var/lib/apt/lists/* && rm -rf /app/postgresql-11.6.tar.gz /apppostgresql-11.6
RUN sed -ri "s!^#?(listen_addresses)\s*=\s*\S+.*!\1 = '*'!" /usr/local/pgspider/share/postgresql/postgresql.conf.sample; \
   grep -F "listen_addresses = '*'" /usr/local/pgspider/share/postgresql/postgresql.conf.sample
RUN mkdir -p /var/run/postgresql && chown -R postgres:postgres /var/run/postgresql  && chmod 2777 /var/run/postgresql
ENV PATH $PATH:/usr/local/pgspider/bin
ENV PGDATA /var/lib/postgresql/data
RUN mkdir -p "$PGDATA" && chown -R postgres:postgres "$PGDATA" && chmod 777 "$PGDATA"
VOLUME /var/lib/postgresql/data
COPY docker-entrypoint.sh /usr/local/bin/
RUN ln -s usr/local/bin/docker-entrypoint.sh / # backwards compat
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 5432
CMD ["postgres"]




