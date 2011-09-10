#!/bin/bash

BASEDIR=$(dirname $0)
SANITIZER=${BASEDIR}/sanitize-uls.pl
POSTPROCESSOR=${BASEDIR}/postprocess.awk
OUTPUT=${BASEDIR}/import.sql

# Clean up
rm -f ${OUTPUT}
find ${BASEDIR} -name \*clean\*.dat -exec rm {} +

for file in `find ${BASEDIR} -name *.dat`
do
  TABLE=`basename $file .dat | tr '[a-z]' '[A-Z]'`
  ${SANITIZER} $file
  NEWFN="`dirname $file`/${TABLE}-clean.dat"
  if [[ ${TABLE} == "EM" || ${TABLE} == "F2" || ${TABLE} == "L2" || 
        ${TABLE} == "PA" ]]; then
    NEWFN2="`dirname $file`/${TABLE}-cleaner.dat"
    echo "Postprocessing ${TABLE} records"
    ${POSTPROCESSOR} < ${NEWFN} > ${NEWFN2}
    mv ${NEWFN2} ${NEWFN}
  fi
  echo "\\copy pubacc_${TABLE} from '$NEWFN' with delimiter '|' null ''" >> ${OUTPUT}
done
