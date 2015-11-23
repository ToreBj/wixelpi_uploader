#!/bin/bash
# medtronic record uploader
# ns-upload2.sh

HISTORY=${1-pumphistory.json}
OUTPUT=${2-pumphistory.ns.json}
#TZ=${3-$(date +%z)}

source mongo.cfg

#cat enactedtemp.json |
cat pumphistory.json | 
#cat foo.json |
json -e "this.created_at = this.timestamp + '$(date +%z)'" | 
json -e "this.dateString = this.timestamp + '$(date +%z)'" | 
#json -e "this.date ='$(date +%s)000'" | 
grep -v _body | 
grep -v _head | 
grep -v _date | 
grep -v _description | 
sed s'/duration (min)/duration/' | 
sed 's/rate/absolute/' | 
sed 's/_type/eventType/' | 
sed 's/TempBasal/Temp Basal/' | 
sed 's/Temp BasalDuration/Temp Basal/' | 
sed 's/\"Bolus\"/"Correction Bolus"/' | 
sed 's/\"amount\"/"insulin"/' |
json -o jsony-0 | sed 's/\[//g' | 
sed 's/\]//g' | sed 's/},/}\n/g' |
sed 's/\"absolute\"\:0,/"absolute":0.05,/' > uploadpumphistory.json

while read line; do
 echo $line
#done < uploadpumphistory.json

echo `echo $line | json -a dateString`
DATESTRING=`echo $line | json -a dateString`

ISO=$(date -Iseconds --date="$DATESTRING")
UNIX=$(date +%s --date="$DATESTRING")000

QUERY="%7B\"date\"%3A$UNIX%7D"
echo $QUERY

#
set=\$set

DATA=`(
cat <<EOF
{ "$set" :  $line
}
EOF
) | awk 1 ORS=' '`
echo $DATA
echo

curl -s -k -m 30 -H "Accept: application/json" -H "Content-type: application/json" -X PUT -d "$DATA" "https://api.mongolab.com/api/1/databases/ochenmiller/collections/treatments?apiKey=$APIKEY&q=$QUERY&u=true"
echo
done < uploadpumphistory.json

