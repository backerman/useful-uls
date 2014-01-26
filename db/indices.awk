#!/usr/bin/awk -f
#
# Generate index creation commands.

/[Cc][Rr][Ee][Aa][Tt][Ee] [Tt][Aa][Bb][Ll][Ee]/ {
  match($0, /[Cc][Rr][Ee][Aa][Tt][Ee] [Tt][Aa][Bb][Ll][Ee] /);
  tablename=tolower(substr($0, RSTART + RLENGTH));
  match(tablename, /[a-z0-9_]+/);
  tablename=substr(tablename, 0, RLENGTH);
  match(tablename, /[a-z0-9]+$/);
  tablename_short=substr(tablename, RSTART);

  print "CREATE INDEX idx_" tablename_short "_usi ON " tablename " (unique_system_identifier);";
}

/[^_[:alnum:]][Cc][Aa][Ll][Ll][Ss][Ii][Gg][Nn][^_[:alnum:]]/ {
  print "CREATE INDEX idx_" tablename_short "_cs ON " tablename " (callsign);";
}
