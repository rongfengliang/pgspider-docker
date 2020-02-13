#!/bin/sh


# build

docker build -t dalongrong/pgspider:sqlite-plv8 -f Dockerfile-sqlite-plv8 .
docker build -t dalongrong/pgspider:redis-plv8 -f Dockerfile-redis-plv8 .
docker build -t dalongrong/pgspider:mysql-plv8 -f Dockerfile-mysql-plv8 .
docker build -t dalongrong/pgspider:tds-plv8 -f Dockerfile-tds_fdw-plv8 .
docker build -t dalongrong/pgspider:mongo-plv8 -f Dockerfile-mongo-plv8 .
docker build -t dalongrong/pgspider:oracle-plv8 -f Dockerfile-oracle-plv8 .
docker build -t dalongrong/pgspider:mysql-sqlite-plv8 -f Dockerfile-mysql-sqlite-plv8 .
docker build -t dalongrong/pgspider:griddb-4.2-plv8 -f Dockerfile-griddb4.2-plv8 .
docker build -t dalongrong/pgspider:influxdb-plv8 -f Dockerfile-influxdb-plv8 .
docker build -t dalongrong/pgspider:all-in-one-oracle-plv8 -f Dockerfile-all-in-one-oracle-plv8 .
docker build -t dalongrong/pgspider:all-in-one-plv8 -f Dockerfile-all-in-one-plv8 .
docker build -t dalongrong/pgspider:zombodb -f Dockerfile-zombodb .
docker build -t dalongrong/pgspider:zombodb-plv8 -f Dockerfile-zombodb-plv8 .
docker build -t dalongrong/pgspider:all-in-one -f Dockerfile-all-in-one .
docker build -t dalongrong/pgspider:all-in-one-oracle -f Dockerfile-all-in-one-oracle .


## push

docker push dalongrong/pgspider:sqlite-plv8
docker push dalongrong/pgspider:redis-plv8
docker push dalongrong/pgspider:mysql-plv8
docker push dalongrong/pgspider:tds-plv8
docker push dalongrong/pgspider:mongo-plv8
docker push dalongrong/pgspider:oracle-plv8
docker push dalongrong/pgspider:mysql-sqlite-plv8
docker push dalongrong/pgspider:griddb-4.2-plv8
docker push dalongrong/pgspider:influxdb-plv8
docker push dalongrong/pgspider:all-in-one-oracle-plv8 
docker push dalongrong/pgspider:all-in-one-plv8
docker push dalongrong/pgspider:all-in-one
docker push dalongrong/pgspider:zombodb
docker push dalongrong/pgspider:zombodb-plv8