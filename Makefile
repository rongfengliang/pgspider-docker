# contrib/pgspider_fdw/Makefile

MODULE_big = pgspider_core_fdw
OBJS = pgspider_core_fdw.o pgspider_core_option.o  $(WIN32RES)
PGFILEDESC = "pgspider_core_fdw - foreign data wrapper for PostgreSQL"

PG_CPPFLAGS = -I$(libpq_srcdir) -I../  -lpostgres_fdw -lpthread -lpq -lm -lpgspider_keepalive -z defs
SHLIB_LINK = $(libpq)

#LIBS = -lpostgres_fdw

EXTENSION = pgspider_core_fdw
DATA = pgspider_core_fdw--1.0.sql

REGRESS = pgspider_core_fdw

EXTRA_INSTALL = contrib/pgspider_keepalive

ifdef USE_PGXS
PG_CONFIG = pg_config
PGXS := $(shell $(PG_CONFIG) --pgxs)
include $(PGXS)
else
SHLIB_PREREQS = submake-libpq
subdir = contrib/pgspider_core_fdw/
top_builddir = ../..
include $(top_builddir)/src/Makefile.global
include $(top_srcdir)/contrib/contrib-global.mk
endif
VPATH = fdws
FILES = file_fdw.so
DSTDIR=outdir

OUTFILES=$(FILES:%=$(DSTDIR)/%)

check: temp-install

temp-install: EXTRA_INSTALL+=contrib/postgres_fdw contrib/pgspider_core_fdw contrib/file_fdw contrib/tinybrace_fdw contrib/sqlite_fdw contrib/mysql_fdw contrib/pgspider_keepalive contrib/pgspider_fdw
checkprep: EXTRA_INSTALL+=contrib/postgres_fdw contrib/pgspider_core_fdw contrib/file_fdw contrib/tinybrace_fdw contrib/sqlite_fdw contrib/mysql_fdw contrib/pgspider_keepalive contrib/pgspider_fdw

#check: copyfdw
copyfdw:
	$(OUTFILES):: $(FILES)
	cp $? $(DSTDIR)/
