#!/usr/bin/awk -f
#
# Postprocessing jobs
BEGIN {
  FS="|";
  OFS="|";
}

# Emission
/^EM/ {
  print $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14,
        fixtimestamp($15), $16;
}

# Additional frequency information
/^F2/ {
  print $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15,
        fixtimestamp($16), $17, fixtimestamp($18), $19;
}

# Additional location data
/^L2/ {
  print $1, $2, $3, $4, $5, $6, $7, $8, fixtimestamp($9), $10, $11, $12, $13,
        $14, fixtimestamp($15);
}

# Microwave path
/^PA/ {
  print $1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15,
        $16, $17, $18, $19, $20, $21, fixtimestamp($22);
}

function fixtimestamp(ts) {
  # Replace the final colon in an MSSQL-format timestamp with a full-stop.
  #
  # E.g. Aug 16 2007 12:00:00:000AM becomes
  #      Aug 16 2007 12:00:00.000AM.

  subsec_pos = match(ts, /:([^:]+$)/);
  newstr = ts;
  if (subsec_pos) {
    newstr = substr(ts, 1, subsec_pos - 1) "." substr(ts, subsec_pos + 1);
  }
  return newstr;
}
