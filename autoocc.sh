#!/bin/bash
# This script generate "OCCU" entry in the EVALUES file accordingly to FRMIDT.
# May be useful in FLOSIC calculations.

eup=$(head -n 1 FRMIDT | awk '{print $1;}' )
edn=$(head -n 1 FRMIDT | awk '{print $2;}' )
##echo OCCU > EVALUES
echo "OCCU"
echo $eup  
##for i in {1..'"$eup"'}; do echo "1 " ;done
for ((i=1;i<=eup;i++)); do
  echo -n "1 "
done
echo ""
echo $edn
#for i in {1..'"$edn"'}; do echo "1 " ;done
for ((i=1;i<=edn;i++)); do
  echo -n "1 "
done
echo ""
