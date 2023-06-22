#!/bin/bash
# This script generate "OCCU" entry in the EVALUES file accordingly to SYMBOL.
# May be useful in DFA calculations.

eup=$(grep ELECTRON SYMBOL | awk '{print int($3)}')
edn=$(grep ELECTRON SYMBOL | awk '{print int($4)}')
##echo OCCU > EVALUES
echo "OCCU"
echo $eup  
##for i in {1..'"$eup"'}; do echo "1 " ;done
for ((i=1;i<=eup;i++)); do
  echo -n "1 "
done
echo ""
if [ $edn -lt 0 ]
then
  edn=${edn#-}
fi
echo $edn
#for i in {1..'"$edn"'}; do echo "1 " ;done
for ((i=1;i<=edn;i++)); do
  echo -n "1 "
done
echo ""
