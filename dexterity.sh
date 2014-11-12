dexterity.sh
#!/bin/bash
#Peter Miller 10/2014
#invoke as ./dexterity.sh <TRANSMITTER_5_DIGIT_ID <PORT> >> logfile &

ID=$1
PORT=$2
LOG=$3

while read line; do 
      if [[ $line == *"$ID"* ]]; then
		RAWBG=`echo $line | cut -d " " -f 2 | tr -d '\n'`
                FILTERED=`echo $line | cut -d " " -f 3 | tr -d '\n'`
		DATE=`date`
                TRANSREC=`echo $line | cut -d " " -f 6 | tr -d '\n'`
		echo ./rawtobg.sh "$RAWBG" \""$DATE"\" Flat $TRANSREC $FILTERED
		./rawtobg.sh "$RAWBG" "$DATE" Flat $TRANSREC $FILTERED&
                echo "$line $DATE"
      fi
    done < $PORT
