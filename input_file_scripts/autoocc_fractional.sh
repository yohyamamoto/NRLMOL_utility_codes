#!/bin/bash
# This script generate "OCCU" entry in the EVALUES file accordingly to SYMBOL.
# May be useful in DFA calculations.
#
# This particular script support whole integer occupations + one fractional occupation

eup=$(grep ELECTRON SYMBOL | awk '{print $3}')
edn=$(grep ELECTRON SYMBOL | awk '{print $4}')
weup=$(grep ELECTRON SYMBOL | awk '{print int($3)}')
wedn=$(grep ELECTRON SYMBOL | awk '{print int($4)}')


if [ $wedn -lt 0 ]
then
   edn=${edn#-}
  wedn=${wedn#-}
fi

rup=$(echo "$eup-$weup" | bc)
rdn=$(echo "$edn-$wedn" | bc)


##echo OCCU > EVALUES
echo "OCCU"

echo $((weup+1))  
##for i in {1..'"$eup"'}; do echo "1 " ;done
for ((i=1;i<=weup;i++)); do
  echo -n "1 "
done
echo -n "$rup "
echo ""

echo $((wedn+1))
#for i in {1..'"$edn"'}; do echo "1 " ;done
for ((i=1;i<=wedn;i++)); do
  echo -n "1 "
done
echo -n "$rdn "
echo ""
