#!/bin/bash
##
##This script will generate OCCEXC files needed for excited calulation
##

makeoccexc () {
#opt="3"

#energy=$(cat GEOCNVRG | grep ENERGY | awk '{print $2}')
energy=$(tail -n 1 SUMMARY | awk '{print $3}')
up_e=$(cat SYMBOL | grep ELECTRONS | awk '{print $3}')
dn_e=$(cat SYMBOL | grep ELECTRONS | awk '{print $4}')

up_e=${up_e%.*}
dn_e=${dn_e%.*}
if [ "$dn_e" -lt 0 ]; then
  dn_e=${dn_e/#-/}
fi

echo "up electrons" $up_e
echo "down electrons" $dn_e

up_e_bf=$up_e
dn_e_bf=$dn_e

############
# up -> dn #
############
if [ "$opt" -eq "0" ]; then
  up_e_af=$up_e_bf
  dn_e_af=$(( dn_e_bf+1 ))
  spnhole=1
  spnpart=2
  holestate=$up_e_bf
############
# dn -> up #
############
elif [ "$opt" -eq "1" ]; then
  up_e_af=$(( up_e_bf+1 ))
  dn_e_af=$dn_e_bf
  spnhole=2
  spnpart=1
  holestate=$up_e_bf
############
# up -> up #
############
elif [ "$opt" -eq "2" ]; then
  up_e_af=$(( up_e_bf+1 ))
  dn_e_af=$dn_e_bf
  spnhole=1
  spnpart=1
  holestate=$up_e_bf
############
# up -> up #
############
elif [ "$opt" -eq "3" ]; then
  up_e_af=$up_e_bf
  dn_e_af=$(( dn_e_bf+1 ))
  spnhole=2
  spnpart=2
  holestate=$dn_e_bf
fi

#First line
printf "1\n"
#Energy
echo "$energy"

#Hole spin hole state
printf "$spnhole $up_e_af\n"
#Particle spin particle state
printf "$spnpart $dn_e_af\n"

##print out up electrons
printf "$up_e_bf\n"
i=1
while [ "$i" -le "$up_e_bf" ]
do
  printf "1 "
  if [ "$((i%20))" -eq "0" ] || [ "$i" -eq "$up_e_bf" ]; then
    printf "\n"
  fi
  (( i++ ))
done

##print out down electrons
printf "$dn_e_bf\n"
i=1
while [ "$i" -le "$dn_e_bf" ]
do
  printf "1 "
  if [ "$((i%20))" -eq "0" ] || [ "$i" -eq "$dn_e_bf" ]; then
    printf "\n"
  fi
  (( i++ ))
done

##print out up electrons
printf "$up_e_af\n"
i=1
while [ "$i" -le "$up_e_af" ]
do
  if [ "$spnhole" -eq "1" ] && [ "$i" -eq "$holestate" ]; then
    printf "0 "
  else
    printf "1 "
  fi
  if [ "$((i%20))" -eq "0" ] || [ "$i" -eq "$up_e_af" ]; then
    printf "\n"
  fi
  (( i++ ))
done

##print out down electrons
printf "$dn_e_af\n"
i=1
while [ "$i" -le "$dn_e_af" ]
do
  if [ "$spnhole" -eq "2" ] && [ "$i" -eq "$holestate" ]; then
    printf "0 "
  else
    printf "1 "
  fi
  if [ "$((i%20))" -eq "0" ] || [ "$i" -eq "$dn_e_af" ]; then
    printf "\n"
  fi
  (( i++ ))
done
}

opt=0
makeoccexc
opt=1  
makeoccexc
opt=2 
makeoccexc
opt=3 
makeoccexc
