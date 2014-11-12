#!/bin/bash
#Peter Miller 10/2014
# dexterity.sh config file
# calibration data
SLOPE=$1
INT=$2
SCALE=$3
echo "# dexterity.sh config file" > cal.cfg
echo "# calibration data" >> cal.cfg
echo "SLOPE=$1" >> cal.cfg
echo "INT=$2"   >> cal.cfg
echo "SCALE=$3"  >> cal.cfg
