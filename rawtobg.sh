#!/bin/bash
# dexterity record uploader
# takes raw/filtered, direction, transmitter record number (0-63 = 05:20 loop. Handy for determining missed records)
# calibration data is cal.cfg
# history to calculate arrows (wip) is in hist.cfg
# mongo credentials are in mongo.cfg
#
RAW=$1
AT=$2
DIRECTION=$3
TRANSREC=$4
FILTERED=$5
#
source mongo.cfg
source cal.cfg
source hist.cfg
#

# create SGV from raw/filtered and calibration data
# WIP, to say the least. Next change is to attempt to add slope adjust over first two days of new sensor.
SGV=`awk -v r=$RAW -v f=$FILTERED -v s=$SLOPE -v i=$INT -v c=$SCALE 'BEGIN { printf "%2.0f\n", c*(((r+f)/2)-i)/s }'`

# derive DIRECTION from SGV and historical records
# WIP. Next change is to determine if the the most recent records are in fact "recent". 

let DIFF=$SGV-$SGV3
echo DIFFERENCE=$DIFF

if [ $DIFF -lt -45 ]
then
DIRECTION="DoubleDown"
fi

if [ $DIFF -ge -45 ]
then
DIRECTION="SingleDown"
fi

if [ $DIFF -ge -30 ]
then
DIRECTION="FortyFiveDown"
fi

if [ $DIFF -ge -15 ]
then
DIRECTION="Flat"
fi

if [ $DIFF -gt 15 ]
then
DIRECTION="FortyFiveUp"
fi

if [ $DIFF -gt 30 ]
then
DIRECTION="SingleUp"
fi

if [ $DIFF -gt 45 ]
then
DIRECTION="DoubleUp"
fi

#
OPTS=""
if [ -n "$AT" ]; then
  OPTS="--date ${AT}"
fi
#ISO=$(date -Iseconds $OPTS)
#UNIX=$(date +%s $OPTS)000
ISO=$(date -Iseconds --date="$2")
UNIX=$(date +%s --date="$2")000

DATA=`(
cat <<EOF
{ "sgv": "$SGV",
  "raw": "$RAW",
  "filtered": "$FILTERED",
  "device": "dexcom",
  "direction": "$DIRECTION",
  "dateString": "$ISO",
  "date": $UNIX,
  "transrec": $TRANSREC
}
EOF
) | tr -d '\n'`
echo $DATA
echo

echo "SGV1=$SGV"     > hist.cfg
echo "SGV2=$SGV1"   >> hist.cfg
echo "SGV3=$SGV2"   >> hist.cfg
echo "DATE1=$UNIX"  >> hist.cfg
echo "DATE2=$DATE1" >> hist.cfg
echo "DATE3=$DATE2" >> hist.cfg


curl -s -H "Accept: application/json" -H "Content-type: application/json" -X POST -d "$DATA" https://api.mongolab.com/api/1/databases/$DB/collections/$COL?apiKey=$APIKEY&dbname=$DB&colname=$COL&user=$USER&passwd=$PW
echo
