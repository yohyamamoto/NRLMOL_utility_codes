#!/bin/bash
##
##This script will generate OCCEXC files needed for excited state calulation
##Combinations of HOMO, HOMO-1, HOMO-2 and LUMO, LUMO+1, LUMO+2 will be generated.
## 

makeoccexc () {
#opt="3"

#energy=$(cat GEOCNVRG | grep ENERGY | awk '{print $2}')
energy=$(tail -n 1 SUMMARY | awk '{print $3}')
up_e=$(tail SYMBOL | grep ELECTRONS | awk '{print $3}')
dn_e=$(tail SYMBOL | grep ELECTRONS | awk '{print $4}')

up_e=${up_e%.*}
dn_e=${dn_e%.*}
if [ "$dn_e" -lt 0 ]; then
  dn_e=${dn_e/#-/}
fi

#echo "up electrons" $up_e
#echo "down electrons" $dn_e

up_e_bf=$up_e
dn_e_bf=$dn_e

############
# up -> dn #
############
if [ "$opt" -eq "111" ]; then
  up_e_af=$up_e_bf
  dn_e_af=$(( dn_e_bf+1 ))
  spnhole=1
  spnpart=2
  holestate=$up_e_bf
############
# dn -> up #
############
elif [ "$opt" -eq "112" ]; then
  up_e_af=$(( up_e_bf+1 ))
  dn_e_af=$dn_e_bf
  spnhole=2
  spnpart=1
  holestate=$up_e_bf
############
# up -> up #
############
elif [ "$opt" -eq "113" ]; then
  up_e_af=$(( up_e_bf+1 ))
  dn_e_af=$dn_e_bf
  spnhole=1
  spnpart=1
  holestate=$up_e_bf
############
# dn -> dn #
############
elif [ "$opt" -eq "114" ]; then
  up_e_af=$up_e_bf
  dn_e_af=$(( dn_e_bf+1 ))
  spnhole=2
  spnpart=2
  holestate=$dn_e_bf
##########
# HOMO   #
##########
#HOMO up -> LUMO+1 down
elif [ "$opt" -eq "121" ]; then
  up_e_af=$up_e_bf
  dn_e_af=$(( dn_e_bf+2 ))
  spnhole=1
  spnpart=2
  holestate=$(( up_e_bf ))
#HOMO up -> LUMO+1 up
elif [ "$opt" -eq "122" ]; then
  up_e_af=$(( up_e_bf+2 ))
  dn_e_af=$dn_e_bf
  spnhole=1
  spnpart=1
  holestate=$(( up_e_bf ))
#HOMO up > LUMO+2 down
elif [ "$opt" -eq "131" ]; then
  up_e_af=$up_e_bf
  dn_e_af=$(( dn_e_bf+3 ))
  spnhole=1
  spnpart=2
  holestate=$(( up_e_bf ))
#HOMO up -> LUMO+2 up
elif [ "$opt" -eq "132" ]; then
  up_e_af=$(( up_e_bf+3 ))
  dn_e_af=$dn_e_bf
  spnhole=1
  spnpart=1
  holestate=$(( up_e_bf ))
###########
# HOMO-1  #
###########
#HOMO-1 up -> LUMO down
elif [ "$opt" -eq "211" ]; then
  up_e_af=$up_e_bf
  dn_e_af=$(( dn_e_bf+1 ))
  spnhole=1
  spnpart=2
  holestate=$(( up_e_bf-1 ))
#HOMO-1 up -> LUMO up
elif [ "$opt" -eq "212" ]; then
  up_e_af=$(( up_e_bf+1 ))
  dn_e_af=$dn_e_bf
  spnhole=1
  spnpart=1
  holestate=$(( up_e_bf-1 ))
#HOMO-1 up -> LUMO+1 down
elif [ "$opt" -eq "221" ]; then
  up_e_af=$up_e_bf
  dn_e_af=$(( dn_e_bf+2 ))
  spnhole=1
  spnpart=2
  holestate=$(( up_e_bf-1 ))
#HOMO-1 up -> LUMO+1 up
elif [ "$opt" -eq "222" ]; then
  up_e_af=$(( up_e_bf+2 ))
  dn_e_af=$dn_e_bf
  spnhole=1
  spnpart=1
  holestate=$(( up_e_bf-1 ))
#HOMO-1 up > LUMO+2 down
elif [ "$opt" -eq "231" ]; then
  up_e_af=$up_e_bf
  dn_e_af=$(( dn_e_bf+3 ))
  spnhole=1
  spnpart=2
  holestate=$(( up_e_bf-1 ))
#HOMO-1 up -> LUMO+2 up
elif [ "$opt" -eq "232" ]; then
  up_e_af=$(( up_e_bf+3 ))
  dn_e_af=$dn_e_bf
  spnhole=1
  spnpart=1
  holestate=$(( up_e_bf-1 ))
###########
# HOMO-2  #
###########
#HOMO-2 up -> LUMO down
elif [ "$opt" -eq "311" ]; then
  up_e_af=$up_e_bf
  dn_e_af=$(( dn_e_bf+1 ))
  spnhole=1
  spnpart=2
  holestate=$(( up_e_bf-2 ))
#HOMO-2 up -> LUMO up
elif [ "$opt" -eq "312" ]; then
  up_e_af=$(( up_e_bf+1 ))
  dn_e_af=$dn_e_bf
  spnhole=1
  spnpart=1
  holestate=$(( up_e_bf-2 ))
#HOMO-2 up -> LUMO+1 down
elif [ "$opt" -eq "321" ]; then
  up_e_af=$up_e_bf
  dn_e_af=$(( dn_e_bf+2 ))
  spnhole=1
  spnpart=2
  holestate=$(( up_e_bf-2 ))
#HOMO-2 up -> LUMO+1 up
elif [ "$opt" -eq "322" ]; then
  up_e_af=$(( up_e_bf+2 ))
  dn_e_af=$dn_e_bf
  spnhole=1
  spnpart=1
  holestate=$(( up_e_bf-2 ))
#HOMO-2 up > LUMO+2 down
elif [ "$opt" -eq "331" ]; then
  up_e_af=$up_e_bf
  dn_e_af=$(( dn_e_bf+3 ))
  spnhole=1
  spnpart=2
  holestate=$(( up_e_bf-2 ))
#HOMO-2 up -> LUMO+2 up
elif [ "$opt" -eq "332" ]; then
  up_e_af=$(( up_e_bf+3 ))
  dn_e_af=$dn_e_bf
  spnhole=1
  spnpart=1
  holestate=$(( up_e_bf-2 ))
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
  elif [ "$i" -gt "$up_e_bf" ] && [ "$i" -ne "$up_e_af" ]; then
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
  elif [ "$i" -gt "$dn_e_bf" ] && [ "$i" -ne "$dn_e_af" ]; then
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

opt=111
makeoccexc > OCCEXC.T
#opt=112  
#makeoccexc
opt=113 
makeoccexc > OCCEXC.M
#opt=114 
#makeoccexc 
##########
opt=121
makeoccexc > OCCEXC.T.HOMOLUMO1
opt=122
makeoccexc > OCCEXC.M.HOMOLUMO1
opt=131
makeoccexc > OCCEXC.T.HOMOLUMO2
opt=132
makeoccexc > OCCEXC.M.HOMOLUMO2
############
opt=211
makeoccexc > OCCEXC.T.HOMO-1LUMO
opt=212
makeoccexc > OCCEXC.M.HOMO-1LUMO
opt=221
makeoccexc > OCCEXC.T.HOMO-1LUMO1
opt=222
makeoccexc > OCCEXC.M.HOMO-1LUMO1
opt=231
makeoccexc > OCCEXC.T.HOMO-1LUMO2
opt=232
makeoccexc > OCCEXC.M.HOMO-1LUMO2
#########
opt=311
makeoccexc > OCCEXC.T.HOMO-2LUMO
opt=312
makeoccexc > OCCEXC.M.HOMO-2LUMO
opt=321
makeoccexc > OCCEXC.T.HOMO-2LUMO1
opt=322
makeoccexc > OCCEXC.M.HOMO-2LUMO1
opt=331
makeoccexc > OCCEXC.T.HOMO-2LUMO2
opt=332
makeoccexc > OCCEXC.M.HOMO-2LUMO2
