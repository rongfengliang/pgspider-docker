# pgspider docker file

## Usegae

* mongodb fdw

```code
CREATE EXTENSION mongo_fdw;
CREATE EXTENSION pgspider_core_fdw;
CREATE EXTENSION postgres_fdw;
CREATE EXTENSION pgspider_fdw;

CREATE SERVER parent FOREIGN DATA WRAPPER pgspider_core_fdw OPTIONS (host '127.0.0.1', port '5432');

CREATE SERVER mongo_server FOREIGN DATA WRAPPER mongo_fdw OPTIONS (address 'mongo', port '27017', authentication_database 'admin');

CREATE USER MAPPING FOR postgres SERVER mongo_server OPTIONS(username 'dalong', password 'dalong');

CREATE FOREIGN TABLE userapps(_id NAME,appid int,appname text,__spd_url text) SERVER parent;

CREATE FOREIGN TABLE userapps__mongo_server__0(_id NAME,appid int,appname text) SERVER mongo_server OPTIONS (database 'apps', collection 'userapps');

select * from userapps;

mongodb docs:

{
    "_id" : ObjectId("5e3a782b132f94cefe1d1e60"),
    "appname" : "demoapp",
    "appid" : 1
}
```

## pg fdw

```code
CREATE EXTENSION pgspider_core_fdw;
CREATE EXTENSION postgres_fdw;
CREATE EXTENSION pgspider_fdw;

CREATE SERVER parent FOREIGN DATA WRAPPER pgspider_core_fdw OPTIONS (host '127.0.0.1', port '5432');

CREATE SERVER postgres_svr FOREIGN DATA WRAPPER postgres_fdw OPTIONS(host 'pg', port '5432', dbname 'postgres');

CREATE USER MAPPING FOR CURRENT_USER SERVER parent OPTIONS(user 'postgres', password 'dalong');

CREATE USER MAPPING FOR CURRENT_USER SERVER postgres_svr OPTIONS(user 'postgres', password 'dalong');

CREATE FOREIGN TABLE t1(i int, t text, __spd_url text) SERVER parent;

CREATE FOREIGN TABLE t1__postgres_svr__0(i int, t text) SERVER postgres_svr OPTIONS (table_name 't1');

pg datas:
CREATE TABLE t1 (
    i SERIAL PRIMARY KEY,
    t text
);

INSERT INTO "public"."t1"("i","t")
VALUES
(1,E'demo');
```