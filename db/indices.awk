#!/usr/bin/awk -f
#
# Generate index creation commands.

/create table/ {
  match($0, /create table /);
  tablename=tolower(substr($0, RSTART + RLENGTH));
  match(tablename, /[a-z0-9_]+/);
  tablename=substr(tablename, 0, RLENGTH);
  match(tablename, /[a-z0-9]+$/);
  tablename_short=substr(tablename, RSTART);

  print "CREATE INDEX idx_" tablename_short "_usi ON " tablename " (unique_system_identifier);";
}

/[^_[:alnum:]]callsign[^_[:alnum:]]/ {
  print "CREATE INDEX idx_" tablename_short "_cs ON " tablename " (callsign);";
}
