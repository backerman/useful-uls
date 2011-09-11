#!/usr/bin/env bash
#
# Download the current ULS database to the specified output
# directory.

BASEDIR=$(dirname $0)

if [ -z "$1" ]
then
  echo "Usage: $0 [destination-directory]" >&2
  exit 1
fi

if [ -z "`which wget`" -o -z "`which unzip`" ]
then
  echo "Please ensure that wget and unzip are in your \$PATH." >&2
  exit 1
fi

DESTDIR=$1
mkdir -p $DESTDIR
SRC_URLS=$($BASEDIR/get-dataset-urls.rb)

echo $SRC_URLS |\
  (cd $DESTDIR && xargs -P 4 -n 1 wget --quiet)

cd $DESTDIR
for data in *.zip
do
  BN=`basename $data .zip`
  mkdir $BN
  echo "Extracting $data" >&2
  (cd $BN && unzip ../$data)
  rm $data
done
