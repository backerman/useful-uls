#!/usr/bin/env bash
#
# Sanitize the ULS database dumps and generate a SQL command file
# to import the data.

BASEDIR=$(dirname $0)
SANITIZER=${BASEDIR}/sanitize-uls.pl
POSTPROCESSOR=${BASEDIR}/postprocess.awk

if [ -z "$1" -o -z "$2" ]
then
    echo "Usage: $0 [source-directory] [sql-file]" >&2
      exit 1
fi

SRCDIR=$1
OUTPUT=$2

# Clean up
rm -f ${OUTPUT}
find $SRCDIR -name \*clean\*.dat -exec rm {} +

FILES=$(find ${SRCDIR} -name *.dat)

${SANITIZER} $FILES

for file in $FILES
do
  TABLE=`basename $file .dat | tr '[a-z]' '[A-Z]'`
  rm $file
  NEWFN="`dirname $file`/${TABLE}-clean.dat"
  if [[ ${TABLE} == "EM" || ${TABLE} == "F2" || ${TABLE} == "L2" ||
        ${TABLE} == "PA" || ${TABLE} == "BF" ]]; then
    NEWFN2="`dirname $file`/${TABLE}-cleaner.dat"
    echo "Postprocessing ${TABLE} records"
    ${POSTPROCESSOR} < ${NEWFN} > ${NEWFN2}
    mv ${NEWFN2} ${NEWFN}
  fi
  echo "\\echo Now loading from '$NEWFN' into pubacc_${TABLE}" >> ${OUTPUT}
  echo "\\copy pubacc_${TABLE} from '$NEWFN' with delimiter '|' null ''" \
    >> ${OUTPUT}
done

echo "\\echo Analyzing to make the query planner happy." >> ${OUTPUT}
echo "VACUUM ANALYZE;" >> ${OUTPUT}
