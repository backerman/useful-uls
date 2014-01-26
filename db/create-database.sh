#!/bin/sh
#
# Create the database and role user, then load the schema.
DIRNAME=$(dirname $0)
SCHEMA="${DIRNAME}/schema-base.sql"
VIEWS="${DIRNAME}/views.sql"
INDEXPRG="${DIRNAME}/indices.awk"
createuser -e uls
createdb -e -O uls uls

psql uls uls < $SCHEMA
psql uls uls < $VIEWS
${INDEXPRG} < $SCHEMA | psql uls uls
