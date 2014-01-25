#!/bin/sh
#
# Download the current schema version from ULS and convert it to
# PostgreSQL.
#
# Requires SQL::Translator and curl to be installed.

MYDIR=$(dirname $0)
SCHEMAOUT="$MYDIR/schema-base.sql"

FCCURL="http://wireless.fcc.gov/uls/index.htm?job=transaction&page=weekly"

SCHEMAURL=$(nokogiri --type html -e \
  'p @doc.xpath("//a[contains(text(),\"SQL for table definitions\")]")[0]["href"]' \
  $FCCURL | tr -d \")

echo "Retrieving $SCHEMAURL" >&2
TMPFILE=$(mktemp /tmp/$(basename $0)$$.XXXXXX )
# SQL::Translator doesn't handle T-SQL-style comments correctly.
curl -s $SCHEMAURL | sed 's/\/\*.*\*\///' > $TMPFILE

# There has to be a better way to do this.
PERLPROG=$(cat <<"EOM"
use warnings;
use SQL::Translator;

my $tr = SQL::Translator->new(
  quote_table_names => 0,
  quote_field_names => 0
);

my $output = $tr->translate(
  from => 'Sybase',
  to   => 'PostgreSQL',
  filename => "xxxFILENAMExxx"
) or die $tr->error;

print $output;

EOM)
echo "$PERLPROG" | sed "s|xxxFILENAMExxx|${TMPFILE}|" | perl > $SCHEMAOUT
rm $TMPFILE
