#!/bin/bash

#Cluster or nrlmol_exe
if [ -e nrlmol_exe ]; then
  #Here nrlmol_exe.0 is your reference executable i.e. orginal code.
  exe=${exe=nrlmol_exe}
elif [ -e cluster ]; then
  exe=${exe=cluster}
else
  echo "Excutable not found. Aborting."
  exit 1
fi
#Debugging
#whiptail --msgbox "$exe0 $exe1" 10 40

#Run xdialog if X window is present. Otherwise, run dialog in a terminal.
#Check available command(s) and adjust the DIALOG variable
if type whiptail >/dev/null 2>&1; then
  DIALOG=${DIALOG=whiptail}
elif type dialog >/dev/null 2>&1; then
  DIALOG=${DIALOG=dialog}
else
  echo "TUI environment not found. Aborting."
  exit 1
fi

#Some GUI options in place of TUI
#DIALOG=${DIALOG=Xdialog}
#DIALOG=${DIALOG=zenity}
#DIALOG=${DIALOG=kdialog}

#What to compare.
#1. Hammixing off and on
#2. Libxc off and on
compareto=0

tempfile=`tempfile 2>/dev/null` || tempfile=/tmp/test$$
tempfile0=/tmp/dialog_0_$$
tempfile1=/tmp/dialog_1_$$
tempfile2=/tmp/dialog_2_$$
tempfile3=/tmp/dialog_3_$$
tempfile4=/tmp/dialog_4_$$
tempfile5=/tmp/dialog_5_$$
tempfile6=/tmp/dialog_6_$$
trap "rm -f $tempfile $tempfile0 $tempfile1 $tempfile2 $tempfile3 $tempfile4 $tempfile5 $tempfile6" 0 1 2 5 15

currentdir=$(pwd)
if [ ! -d testing ]; then
  mkdir testing
fi
testdir=$currentdir/testing
cd $testdir

############
#Functions #
############

#Greeting message
Greeting () {
  $DIALOG --title "NRLMOL testing program" \
          --yesno "Press Yes to proceed. No to abort." 10 40
  case $? in
    0)
      ;;
    1)
      exit 1;;
    esac
}

ChooseMode () {
#  $DIALOG --title "Mode" --nocancel \
#          --menu "Choose a mode" 10 60 3 \
#          "1" "Run and compare" \
#          "2" "Run only" \
#          "3" "Compare only" 2> $tempfile6
#  retval=$?
#  runmode=`cat $tempfile6`
  runmode=2
}

WhatToCompare () {

    $DIALOG --title "What to compare" --nocancel \
            --menu "For a starter, you should choose what to compare." 10 60 3 \
            "1"   "Potential mixing vs. Hamiltonian mixing" \
            "2"   "Libxc on vs. off" \
            "3"   "Libxc on vs. off while using Hamitonian mixing"  2> $tempfile4

    retval=$?
    compareto=`cat $tempfile4`

  if [ $previousrun -eq 1 ]; then
    $DIALOG --yesno "testing directory found. Would you like to use previous results for nrlmol_exe.0?" 10 50
    case $? in
      0)
        ;;
      1)
        previousrun=0;;
    esac
  fi
}

ChooseFunctionals () {
  $DIALOG --title "EXCHANGE-CORRELATION" \
          --default-item "GGA-PBE" --nocancel\
          --menu "Hi, this is a menu box to choose exchange-correlation functionals. \
          First, choose your exchange functional:" 24 51 12 \
          "GGA-NONE"    "None" \
          "LDA-PERZUN"  "PERDEW-ZUNGER 81"   \
          "LDA-CEPERL"  "CEPERLEY" \
          "LDA-RPA"     "Random Phase Approximation" \
          "LDA-WIGNER"  "WIGNER"\
          "LDA-GUNLUN"  "GUNNARSSON-LUNDQVIST" \
          "GGA-PW91"    "PERDEW-WANG 91" \
          "GGA-PBE"     "PERDEW-BURKE-ERNZERHOF 96" \
          "GGA-REVPBE"  "REV PBE" \
          "GGA-RPBE"    "R PBE" \
          "GGA-B88"     "BECKE 88" \
          "MGGA-SCAN"   "SCAN meta-GGA"  2> $tempfile1

  retval=$?
  choice1=`cat $tempfile1`

  $DIALOG --title "EXCHANGE-CORRELATION" \
          --default-item "GGA-PBE" \
          --menu "Next, choose your correlation functional:\n " 24 51 12 \
          "GGA-NONE"    "None" \
          "LDA-PERZUN"  "PERDEW-ZUNGER 81"   \
          "LDA-CEPERL"  "CEPERLEY" \
          "LDA-RPA"     "Random Phase Approximation" \
          "LDA-WIGNER"  "WIGNER"\
          "LDA-GUNLUN"  "GUNNARSSON-LUNDQVIST" \
          "GGA-PW91"    "PERDEW-WANG 91" \
          "GGA-PBE"     "PERDEW-BURKE-ERNZERHOF 96" \
          "GGA-REVPBE"  "REV PBE" \
          "GGA-RPBE"    "R PBE" \
          "GGA-B88"     "BECKE 88" \
          "MGGA-SCAN"   "SCAN meta-GGA"  2> $tempfile2

  retval=$?
  choice2=`cat $tempfile2`

  case $retval in
    0)
      echo "'$choice1' and '$choice2' chosen."
      $DIALOG --msgbox "Functional set to $choice1*$choice2" 10 40
      functionalchosen=$choice1*$choice2;;
    1)
      echo "Cancel pressed."
      exit 1;;
  esac
}

ChooseTestSet () {
  $DIALOG --title "Testing set" \
          --default-item "dX40" \
          --menu "Next, choose your correlation functional:\n " 24 51 5 \
          "MAIN5"    "Run CH4, CO2, H2AFM, H2O, and Mn"   \
          "dX40"     "Run a dX40 molecule 1-20" \
	  "21Atoms"  "Run H to Sc atoms" \
          "MGAE109"  "Main Group Atomization Energies" \
          "BYOS"     "Bring Your Own Set of CLUSTER files" 2> $tempfile5

  retval=$?
  choice5=`cat $tempfile5`
  case $retval in
    0)
      if [ "$choice5" == "MAIN5" ]; then
        istart=0
        imax=5
        PrepCluster
      elif [ "$choice5" == "dX40" ]; then
        istart=0
        imax=478
        dx40dir=$currentdir/dX40
        #imax=$(ls $dx40dir/*.CLUSTER | wc -l )
        PrepCluster_dx40
      elif [ "$choice5" == "21Atoms" ]; then
        istart=0
        imax=21
        dx40dir=$currentdir/21Atoms
        #imax=$(ls $dx40dir/*.CLUSTER | wc -l )
        PrepCluster_dx40
      elif [ "$choice5" == "MGAE109" ]; then
        istart=0
        #imax=120
        dx40dir=$currentdir/MGAE109
        imax=$(ls $dx40dir/*.CLUSTER | wc -l )
        PrepCluster_dx40
      elif [ "$choice5" == "BYOS" ]; then
        istart=0
        dx40dir=$currentdir/BYOS
        imax=$(ls $dx40dir/*.CLUSTER | wc -l )
        PrepCluster_dx40 
      else
        $DIALOG --msgbox "Oops" 10 20
      fi;;
    1)
      echo "Cancel pressed."
      exit 1;;
  esac
}


PrepCluster () {
  $DIALOG --title "CLUSTER file" \
          --msgbox "Preparing CLUSTER files" 10 40
  #CH4
  atom1="CH4"
  if [ ! -d $atom1 ]; then
    mkdir $atom1
  fi
  if [ ! -d $atom1/$nrlmolmode ]; then
    mkdir $atom1/$nrlmolmode
  fi
  if [ ! -d $atom1/$nrlmolmode/$bopt ]; then
    mkdir $atom1/$nrlmolmode/$bopt
  fi
  if [ ! -d $atom1/$subdirname/$choice1*$choice2 ]; then
    mkdir $atom1/$subdirname/$choice1*$choice2
  fi
  cp ../$exe ./$atom1/$subdirname/$choice1*$choice2/

  echo "$choice1*$choice2" > ./$atom1/$subdirname/$choice1*$choice2/CLUSTER
  echo "TD" >> ./$atom1/$subdirname/$choice1*$choice2/CLUSTER
  echo "2" >> ./$atom1/$subdirname/$choice1*$choice2/CLUSTER
  echo "0.00  0.00  0.00  6  ALL" >> ./$atom1/$subdirname/$choice1*$choice2/CLUSTER
  echo "1.20  1.20  1.20  1  ALL" >> ./$atom1/$subdirname/$choice1*$choice2/CLUSTER
  echo "0.0 0.0" >> ./$atom1/$subdirname/$choice1*$choice2/CLUSTER

  #CO2
  atom2="CO2"
  if [ ! -d $atom2 ]; then
    mkdir $atom2
  fi
  if [ ! -d $atom2/$nrlmolmode ]; then
    mkdir $atom2/$nrlmolmode
  fi
  if [ ! -d $atom2/$nrlmolmode/$bopt ]; then
    mkdir $atom2/$nrlmolmode/$bopt
  fi
  if [ ! -d $atom2/$subdirname/$choice1*$choice2 ]; then
    mkdir $atom2/$subdirname/$choice1*$choice2
  fi
  cp ../$exe ./$atom2/$subdirname/$choice1*$choice2/

  echo "$choice1*$choice2" > ./$atom2/$subdirname/$choice1*$choice2/CLUSTER
  echo "GRP" >> ./$atom2/$subdirname/$choice1*$choice2/CLUSTER
  echo "2 Number of inequivalent atoms" >> ./$atom2/$subdirname/$choice1*$choice2/CLUSTER
  echo " 0.00  0.00  0.00  6  ALL UPO" >> ./$atom2/$subdirname/$choice1*$choice2/CLUSTER
  echo "-1.50  0.00  0.00  8  ALL UPO" >> ./$atom2/$subdirname/$choice1*$choice2/CLUSTER
  echo " 0.00   0.00 Net Charge and Moment" >> ./$atom2/$subdirname/$choice1*$choice2/CLUSTER

  echo " 2 Number of group elements" > ./$atom2/$subdirname/$choice1*$choice2/GRPMAT
  echo "     1.0000        0.00000         0.00000" >> ./$atom2/$subdirname/$choice1*$choice2/GRPMAT
  echo "     0.0000        1.00000         0.00000" >> ./$atom2/$subdirname/$choice1*$choice2/GRPMAT
  echo "     0.0000        0.00000         1.00000" >> ./$atom2/$subdirname/$choice1*$choice2/GRPMAT
  echo "" >> ./$atom2/$subdirname/$choice1*$choice2/GRPMAT
  echo "    -1.0000        0.00000         0.00000" >> ./$atom2/$subdirname/$choice1*$choice2/GRPMAT
  echo "     0.0000        1.00000         0.00000" >> ./$atom2/$subdirname/$choice1*$choice2/GRPMAT
  echo "     0.0000        0.00000         1.00000" >> ./$atom2/$subdirname/$choice1*$choice2/GRPMAT

  #H2AFM
  atom3="H2AFM"
  if [ ! -d $atom3 ]; then
    mkdir $atom3
  fi
  if [ ! -d $atom3/$nrlmolmode ]; then
    mkdir $atom3/$nrlmolmode
  fi
  if [ ! -d $atom3/$nrlmolmode/$bopt ]; then
    mkdir $atom3/$nrlmolmode/$bopt
  fi
  if [ ! -d $atom3/$subdirname/$choice1*$choice2 ]; then
    mkdir $atom3/$subdirname/$choice1*$choice2
  fi
  cp ../$exe ./$atom3/$subdirname/$choice1*$choice2/

  echo "$choice1*$choice2" >	./$atom3/$subdirname/$choice1*$choice2/CLUSTER
  echo "GRP" >> ./$atom3/$subdirname/$choice1*$choice2/CLUSTER
  echo "2 Number of inequivalent atoms" >> ./$atom3/$subdirname/$choice1*$choice2/CLUSTER
  echo "-0.708846     0.0000     0.0000   1 ALL SUP" >> ./$atom3/$subdirname/$choice1*$choice2/CLUSTER
  echo " 0.708846     0.0000     0.0000   1 ALL SDN" >> ./$atom3/$subdirname/$choice1*$choice2/CLUSTER
  echo " 0.00   0.00 Net Charge and Moment" >> ./$atom3/$subdirname/$choice1*$choice2/CLUSTER

  echo " 1 Number of group elements" >	./$atom3/$subdirname/$choice1*$choice2/GRPMAT
  echo "     1.0000        0.00000         0.00000" >> ./$atom3/$subdirname/$choice1*$choice2/GRPMAT
  echo "     0.0000        1.00000         0.00000" >> ./$atom3/$subdirname/$choice1*$choice2/GRPMAT
  echo "     0.0000        0.00000         1.00000" >> ./$atom3/$subdirname/$choice1*$choice2/GRPMAT

  atom4="H2O"
  if [ ! -d $atom4 ]; then
    mkdir $atom4
  fi
  if [ ! -d $atom4/$nrlmolmode ]; then
    mkdir $atom4/$nrlmolmode
  fi
  if [ ! -d $atom4/$nrlmolmode/$bopt ]; then
    mkdir $atom4/$nrlmolmode/$bopt
  fi
  if [ ! -d $atom4/$subdirname/$choice1*$choice2 ]; then
    mkdir $atom4/$subdirname/$choice1*$choice2
  fi
  cp ../$exe ./$atom4/$subdirname/$choice1*$choice2/

  echo "$choice1*$choice2" >	./$atom4/$subdirname/$choice1*$choice2/CLUSTER
  echo "GRP" >> ./$atom4/$subdirname/$choice1*$choice2/CLUSTER
  echo "2 Number of inequivalent atoms" >> ./$atom4/$subdirname/$choice1*$choice2/CLUSTER
  echo " 0.0000     0.0000     0.0000   8 ALL UPO" >> ./$atom4/$subdirname/$choice1*$choice2/CLUSTER
  echo "-1.4943     1.1568     0.0000   1 ALL UPO" >> ./$atom4/$subdirname/$choice1*$choice2/CLUSTER
  echo " 0.00   0.00 Net Charge and Moment" >> ./$atom4/$subdirname/$choice1*$choice2/CLUSTER

  echo " 2 Number of group elements" >	./$atom4/$subdirname/$choice1*$choice2/GRPMAT
  echo "     1.0000        0.00000         0.00000" >> ./$atom4/$subdirname/$choice1*$choice2/GRPMAT
  echo "     0.0000        1.00000         0.00000" >> ./$atom4/$subdirname/$choice1*$choice2/GRPMAT
  echo "     0.0000        0.00000         1.00000" >> ./$atom4/$subdirname/$choice1*$choice2/GRPMAT
  echo "" >> ./$atom4/$subdirname/$choice1*$choice2/GRPMAT
  echo "    -1.0000        0.00000         0.00000" >> ./$atom4/$subdirname/$choice1*$choice2/GRPMAT
  echo "     0.0000        1.00000         0.00000" >> ./$atom4/$subdirname/$choice1*$choice2/GRPMAT
  echo "     0.0000        0.00000         1.00000" >> ./$atom4/$subdirname/$choice1*$choice2/GRPMAT

  atom5="Mn"
  if [ ! -d $atom5 ]; then
    mkdir $atom5
  fi
  if [ ! -d $atom5/$nrlmolmode ]; then
    mkdir $atom5/$nrlmolmode
  fi
  if [ ! -d $atom5/$nrlmolmode/$bopt ]; then
    mkdir $atom5/$nrlmolmode/$bopt
  fi
  if [ ! -d $atom5/$subdirname/$choice1*$choice2 ]; then
    mkdir $atom5/$subdirname/$choice1*$choice2
  fi
  cp ../$exe ./$atom5/$subdirname/$choice1*$choice2/

  echo "$choice1*$choice2" >	./$atom5/$subdirname/$choice1*$choice2/CLUSTER
  echo "GRP" >> ./$atom5/$subdirname/$choice1*$choice2/CLUSTER
  echo "1 Number of inequivalent atoms" >> ./$atom5/$subdirname/$choice1*$choice2/CLUSTER
  echo " 0.0000     0.0000     0.0000   25 ALL SUP" >> ./$atom5/$subdirname/$choice1*$choice2/CLUSTER
  echo " 0.0000     5.0000 Net Charge and Moment" >> ./$atom5/$subdirname/$choice1*$choice2/CLUSTER

  echo " 1 Number of group elements" >	./$atom5/$subdirname/$choice1*$choice2/GRPMAT
  echo "     1.0000        0.00000         0.00000" >> ./$atom5/$subdirname/$choice1*$choice2/GRPMAT
  echo "     0.0000        1.00000         0.00000" >> ./$atom5/$subdirname/$choice1*$choice2/GRPMAT
  echo "     0.0000        0.00000         1.00000" >> ./$atom5/$subdirname/$choice1*$choice2/GRPMAT
}

#read and copy CLUSTER from dX40 directory
PrepCluster_dx40 () {
  $DIALOG --msgbox "Preparing CLUSTER files" 10 20
  #dx40dir=$currentdir/dX40
  echo $dx40dir
  (( i=istart+1 ))
  (
  while [ $i -le $imax ]
    do
      clustername=`ls $dx40dir | sed -n $i,${i}p | cut -d "." -f1`
      #echo $clustername
      if [ ! -d $testdir/$clustername ]; then
        mkdir $testdir/$clustername
      fi
      if [ ! -d $testdir/$clustername/$nrlmolmode ]; then
        mkdir $testdir/$clustername/$nrlmolmode
      fi
      if [ ! -d $testdir/$clustername/$nrlmolmode/$bopt ]; then
        mkdir $testdir/$clustername/$nrlmolmode/$bopt
      fi
      if [ ! -d $testdir/$clustername/$subdirname/$choice1*$choice2 ]; then
        mkdir $testdir/$clustername/$subdirname/$choice1*$choice2
      fi
      cd $testdir/$clustername/$subdirname/$choice1*$choice2/

      #use sed to replace the first line in the cluster
      cat $dx40dir/$clustername.CLUSTER | sed -e "s/GGA-PBE\*GGA-PBE/$choice1\*$choice2/g" > ./CLUSTER
      cp $currentdir/$exe ./
      cp $currentdir/$exe ./

      (( i++ ))
      (( c= i*100/imax ))
      echo $c
      echo "###"
      echo "$c %"
      echo "###"
    done
  ) |
  $DIALOG --title "Preparing CLUSTER files" --gauge "Plese wait..." 10 60 0
}

mpiCheck () {
  #$DIALOG --msgbox "Checking to see whether you can run MPI." 10 20
  if type mpirun >/dev/null 2>&1; then
    $DIALOG --msgbox "MPI found. Using MPI." 10 20
    (( isMPI = 1 ))
    mpiNP   #Choose NP
    return 1
  elif type /shared/mpich3-i/bin/mpirun >/dev/null 2>&1; then #HPC with intel compiler
    $DIALOG --msgbox "MPI found. Using MPI." 10 20
    (( isMPI = 1 ))
    mpiNP   #Choose NP
    return 1
  elif type aprun >/dev/null 2>&1; then
    $DIALOG --msgbox "aprun found." 10 20
    (( isMPI = 1 ))
    mpiNP
    return 1
  elif type srun >/dev/null 2>&1; then
    $DIALOG --msgbox "srun found." 10 20
    (( isMPI = 1 ))
    mpiNP
    return 1
  else
    echo "Running serial version"
    $DIALOG --msgbox "MPI not found. Using serial version." 10 20
    (( isMPI = 0 ))
    npchoice=1
    return 0
  fi
}

mpiNP () {
#if [[ $isMPI == 1 ]]; then
  $DIALOG --title "NUMBER OF PROCESSES" --clear \
          --inputbox "How many processors do you want to use? Enter a number below:\
                      HPC: 12/node Cori: 32/node" 12 40 4 2> $tempfile
  retval=$?
  npchoice=`cat $tempfile`
  case $retval in
    0)
      if ! [[ "$npchoice" =~ ^[0-9]+$ ]]; then
        $DIALOG --msgbox "Invalid entry. Try again." 10 40
        mpiNP
      fi
	    if [[ $npchoice == 0  ]]; then
        $DIALOG --msgbox "Zero does not work. Try again." 10 40
        mpiNP
	    fi;;
    1)
      echo "Cancel pressed."
      exit 1;;
  esac
#fi
}

RunNRLMOL () {
  echo "Running NRLMOL"
  (
  #imax=5  #Max entries of atoms/molecules <- moved up to the CLUSTER selection part
  (( iincre=100/($imax) )) #increments
  c=0 #progress bar
  i=$istart #i is for concatinating directory variables
#  while [ $c -ne 100 ] #old way
  while [ $i -lt $imax ]  #revised way
    do
      (( i++ ))
      if [ "$choice5" == "MAIN5" ]; then
        var="atom$i"
        cd $testdir/${!var}/$subdirname/$choice1*$choice2/
      elif [ "$choice5" == "dX40" ] || [ "$choice5" == "21Atoms" ] || [ "$choice5" == "MGAE109" ] || [ "$choice5" ==  "BYOS" ]; then
        var=`ls $dx40dir | sed -n $i,${i}p | cut -d "." -f1`
        #$DIALOG --msgbox "$var" 10 20
        echo "$var"
        cd $testdir/$var/$subdirname/$choice1*$choice2/
      #elif [ "$choice5" == "21Atoms" ]; then
      #  var=`ls $dx40dir | sed -n $i,${i}p | cut -d "." -f1`
      #  echo "$var"
      #  cd $testdir/$var/$subdirname/$choice1*$choice2/
      else
        echo "Invalid test set"
        exit 1
      fi

      echo $c
      echo "###"
      echo "$c %"
      echo "###"
      (( c+=$iincre ))

      rm GEOCNVRG RUNS RUNNING NRLMOL_INPUT.DAT HAMXC.dat HAMXC000.dat HAMMIXOLD ERROR_NRLMOL 2> /dev/null

      #Create default NRLMOL_INPUT.DAT
      makeDefaultNRLMOL_INPUT
      makeDefaultMESHDAT

      if [[ -z $dopt ]]; then
        if [[ -z $ropt ]]; then
          mpirun -np $npchoice ./$exe >& print.out
        else
          if [ -e ERROR_NRLMOL ]; then
            rm ERROR_NRLMOL
            mpirun -np $npchoice ./$exe >& print.out
          elif [ ! -e EVAL001 ] || [ ! -e SUMMARY ]; then
            mpirun -np $npchoice ./$exe >& print.out
          fi
        fi

      else
        touch print.out
        sleep 0.1
      fi
      CleaningUp
    done
  echo $c
  echo "###"
  echo "$c %"
  echo "###"
  cd $testdir
  ) |
  $DIALOG --title "Running NRLMOL" --gauge "Plese wait..." 10 60 0
  $DIALOG --msgbox "Finished running." 10 40
}


#Check and see the differences between builtin functional and libxc functional
compareResults () {
  $DIALOG --title "Results" --msgbox "This will show SUMMARY, EVALUES, and print.out." 15 50
  for (( i=istart+1; i<=imax; i++ ))
    do
      if [ "$choice5" == "MAIN5" ]; then
        var="atom$i"
        vardir=${!var}/$subdirname/$choice1*$choice2
      elif [ "$choice5" == "dX40" ] || [ "$choice5" == "21Atoms" ] || [ "$choice5" == "MGAE109" ] || [ "$choice5" == "BYOS" ]; then
        var=`ls $dx40dir | sed -n $i,${i}p | cut -d "." -f1`
        vardir=$var/$subdirname/$choice1*$choice2
      #elif [ "$choice5" == "21Atoms" ]; then
      #  var=`ls $dx40dir | sed -n $i,${i}p | cut -d "." -f1`
      #  vardir=$var/$subdirname/$choice1*$choice2
      fi
      #touch $testdir/$vardir/meowC
      echo "$vardir"

      #var=`ls $dx40dir | sed -n $i,${i}p | cut -d "." -f1`
      $DIALOG --title "Results" --msgbox "$vardir" 10 40
      $DIALOG --title "$vardir SUMMARY" --scrolltext --clear --textbox $vardir/SUMMARY 40 140
      cat $vardir/print.out | grep -E "ITERATION|TOTAL ENERGY|REPULSION:|POTENTIAL:|MEAN-FIELD COULOMB:|EXCHANGE|CORRELATION|ENERGY|KINETIC:|FIELD:|SUMMARY" > $vardir/print.dat.1
      $DIALOG --title "$vardir print.out" --scrolltext --clear --textbox $vardir/print.dat.1 40 130
    done
}


farewell () {
  echo "Thank you for using this testing tool"
  $DIALOG --msgbox "Thank you for using this testing tool. Results are stored in $testdir folder." 10 60
  exit 1
}

#If bsub exists, generate a job script and queue it
RunBsub () {
  #if type bsub >/dev/null 2>&1; then
  $DIALOG --msgbox "bsub found." 10 40
  (
  i=$istart #i is for concatinating directory variables
  while [ $i -lt $imax ]
    do
      (( i++ ))
      if [ "$choice5" == "MAIN5" ]; then
        var="atom$i"
        cd $testdir/${!var}/$subdirname/$choice1*$choice2/
      elif [ "$choice5" == "dX40" ] || [ "$choice5" == "21Atoms" ] || [ "$choice5" == "MGAE109" ] || [ "$choice5" == "BYOS" ]; then
        var=`ls $dx40dir | sed -n $i,${i}p | cut -d "." -f1`
        #$DIALOG --msgbox "$var" 10 20
        echo "$var"
        cd $testdir/$var/$subdirname/$choice1*$choice2/
      #elif [ "$choice5" == "21Atoms" ]; then
      #  var=`ls $dx40dir | sed -n $i,${i}p | cut -d "." -f1`
      #  cd $testdir/$var/$subdirname/$choice1*$choice2/
      fi

      echo "#!/bin/bash" > bjob.sh
      echo "#BSUB -J $var" >> bjob.sh
      echo "#BSUB -n $npchoice" >> bjob.sh
      echo "#BSUB -W 24:00" >> bjob.sh
      echo "#BSUB -q medium_priority" >> bjob.sh
      echo "#BSUB -e error.%J.dat" >> bjob.sh
      echo "#BSUB -o output.%J.dat" >> bjob.sh

      makeDefaultNRLMOL_INPUT
      makeDefaultMESHDAT

      echo "rm RUNS RUNNING GEOCNVRG HAMMIXOLD HAMXC.dat" >> bjob.sh
      echo "/shared/mpi/bin/mpirun -np $npchoice ./$exe > print.out" >> bjob.sh
      #move data and change NRLMOL_INPUT.DAT

      #bsub < bjob.sh
      #echo "Queued with bsub"

#Daisy chain queues
      if [[ -z $ropt ]]; then
        if [ $i -eq $((istart+1)) ]; then
	  bsub < bjob.sh
          jobone=$var
        else
          bsub -w "done($jobone)" < bjob.sh
          jobone=$var
        fi
      else
        if [ -e ERROR_NRLMOL ]; then
          rm ERROR_NRLMOL
          bsub < bjob.sh
        elif [ ! -e EVAL001 ] || [ ! -e SUMMARY ]; then
          bsub < bjob.sh
        fi
      fi
    done
  )
  echo "bjob done"
  cd $testdir

  $DIALOG --msgbox "bsub queue finished." 10 40
}

RunQsub () {
  $DIALOG --msgbox "qsub found." 10 40
  (
  i=$istart #i is for concatinating directory variables
  while [ $i -lt $imax ]
    do
      (( i++ ))
      if [ "$choice5" == "MAIN5" ]; then
        var="atom$i"
        cd $testdir/${!var}/$subdirname/$choice1*$choice2/
      elif [ "$choice5" == "dX40" ] || [ "$choice5" == "21Atoms" ] || [ "$choice5" == "MGAE109" ] || [ "$choice5" == "BYOS" ]; then
        var=`ls $dx40dir | sed -n $i,${i}p | cut -d "." -f1`
        #$DIALOG --msgbox "$var" 10 20
        echo "$var"
        cd $testdir/$var/$subdirname/$choice1*$choice2/
      #elif [ "$choice5" == "21Atoms" ]; then
      #  var=`ls $dx40dir | sed -n $i,${i}p | cut -d "." -f1`
      #  cd $testdir/$var/$subdirname/$choice1*$choice2/
      fi
 
      echo "#!/bin/bash -l" > job.pbs
      echo "#PBS -N $var" >>  job.pbs
      echo "#PBS -l mppwidth=$npchoice,walltime=24:00:00" >> job.pbs
      echo "#PBS -q regular" >> job.pbs
      echo "#PBS -e $var.$PBS_JOBID.err" >> job.pbs
      echo "#PBS -o $var.$PBS_JOBID.out" >> job.pbs
 
      makeDefaultNRLMOL_INPUT
      makeDefaultMESHDAT

      echo "cd \$PBS_O_WORKDIR" >> job.pbs
      echo "rm RUNS RUNNING GEOCNVRG HAMMIXOLD HAMXC.dat" >> job.pbs
      echo "aprun -n $npchoice ./$exe > print.out" >> job.pbs
      #move data and change NRLMOL_INPUT.DAT

      if [[ -z $ropt ]]; then
        if [ $i -eq $((istart+1)) ]; then 
          jobone=$(qsub job.pbs)
        else
          jobtwo=$(qsub -W depend=afterany:$jobone job.pbs)
          jobone=$jobtwo
        fi
        echo $jobone
      else
        if [ -e ERROR_NRLMOL ]; then
          rm ERROR_NRLMOL
          qsub job.pbs
        elif [ ! -e EVAL001 ] || [ ! -e SUMMARY ]; then
          qsub job.pbs
        fi
      fi
    done
 )
 echo "qjob done"
 cd $testdir
 
 $DIALOG --msgbox "qsub queue finished." 10 40

}

RunSbatch () {
$DIALOG --msgbox "sbatch found." 10 40
(
i=$istart #i is for concatinating directory variables
while [ $i -lt $imax ]
  do
    (( i++ ))
    if [ "$choice5" == "MAIN5" ]; then
      var="atom$i"
      cd $testdir/${!var}/$subdirname/$choice1*$choice2/
    elif [ "$choice5" == "dX40" ] || [ "$choice5" == "21Atoms" ] || [ "$choice5" == "MGAE109" ] || [ "$choice5" == "BYOS" ]; then
      var=`ls $dx40dir | sed -n $i,${i}p | cut -d "." -f1`
      #$DIALOG --msgbox "$var" 10 20
      echo "$var"
      cd $testdir/$var/$subdirname/$choice1*$choice2/
    #elif [ "$choice5" == "21Atoms" ]; then
    #  var=`ls $dx40dir | sed -n $i,${i}p | cut -d "." -f1`
    #  cd $testdir/$var/$subdirname/$choice1*$choice2/
    fi
 
    echo "#!/bin/bash -l" > job.sl
    echo "#SBATCH -J $var" >>  job.sl
    echo "#SBATCH --time=24:00:00" >> job.sl
    if [ $(($npchoice%32)) -eq 0 ]; then
     echo "#SBATCH -N $(($npchoice/32))" >> job.sl
    else
     echo "#SBATCH -N $(($npchoice/32+1))" >> job.sl
    fi
    echo "#SBATCH -p regular" >> job.sl

    makeDefaultNRLMOL_INPUT
    makeDefaultMESHDAT

    echo "cd \$SLURM_SUBMIT_DIR" >> job.sl
    echo "rm RUNS RUNNING GEOCNVRG HAMMIXOLD HAMXC.dat" >> job.sl
    echo "srun -n $npchoice ./$exe > print.out" >> job.sl
    #move data and change NRLMOL_INPUT.DAT
 
    if [[ -z $ropt ]]; then
      if [ $i -eq $((istart+1)) ]; then
        jobone=$(sbatch job.sl)
      else
        jobtwo=$(sbatch --dependency=afterany:${jobone##* } job.sl)
        jobone=$jobtwo
      fi
      echo $jobone
    else
      if [ -e ERROR_NRLMOL ]; then
        rm ERROR_NRLMOL
        sbatch job.sl
      elif [ ! -e EVAL001 ] || [ ! -e SUMMARY ]; then
        sbatch job.sl
      fi
    fi
  done
 )
echo "sbatch done"
cd $testdir

$DIALOG --msgbox "sbatch queue finished." 10 40

}


makeDefaultNRLMOL_INPUT () {
#This function creates default NRLMOL_INPUT.DAT file in your current directory
  echo "# Put Y,N or number next to the equal sign to determine execution" > NRLMOL_INPUT.DAT
  echo "# Don't forget the quotation marks for the letters" >> NRLMOL_INPUT.DAT
  echo "# All variables in this list end with v" >> NRLMOL_INPUT.DAT
  echo "" >> NRLMOL_INPUT.DAT
  echo "&input_data" >> NRLMOL_INPUT.DAT
  echo "ATOMSPHV      = 'N'" >> NRLMOL_INPUT.DAT
  if [[ ! -z $bopt ]]; then
    echo "BASISV        = '$bopt' !Specify basis for calculation(basis.txt)" >> NRLMOL_INPUT.DAT
  else
    echo "BASISV        = 'DEFAULT' ! Specify basis for calculation(basis.txt)" >> NRLMOL_INPUT.DAT
  fi  

  echo "CALCTYPEV     = 'LBFGS'" >> NRLMOL_INPUT.DAT
  echo "DFTD3V        = 'N' ! Set to Y to do include Grimmes DFT-D3 dispersion" >> NRLMOL_INPUT.DAT
  echo "DIAG1V        = 1   ! diagonalization to use on regular arrays (diagge.f90)" >> NRLMOL_INPUT.DAT
  echo "DIAG2V        = 1   ! diagonalization to use on packed arrays (diag_dspgv.f90)" >> NRLMOL_INPUT.DAT
  echo "DOSOCCUV      = 'N' ! Controls wether to calculate density of states" >> NRLMOL_INPUT.DAT
  echo "EXCITEDV      = 'N' ! Determines if this is an excited state calculation" >> NRLMOL_INPUT.DAT
  echo "FORMFAKV      = 'N' ! this controls if FORMFAK is executed" >> NRLMOL_INPUT.DAT
  echo "FRAGMENTV     = 'N' ! Process CLUSTER in fragments" >> NRLMOL_INPUT.DAT
  echo "JNTDOSV       = 'N' ! This calculates jonit density of states" >> NRLMOL_INPUT.DAT
  echo "MATDIPOLEV    = 'N'" >> NRLMOL_INPUT.DAT
  echo "MAXSCFV       = 100 ! Maximum SCF iterations" >> NRLMOL_INPUT.DAT
  if [[ ! -z $mopt ]]; then
    echo "MIXPOTV       = 'N' ! (Y) Potential Mixing (N) Hamiltonian mixing" >> NRLMOL_INPUT.DAT
  else
    echo "MIXPOTV       = 'Y' ! (Y) Potential Mixing (N) Hamiltonian mixing" >> NRLMOL_INPUT.DAT
  fi
  echo "MOLDENV       = 'N' ! Use molden driver" >> NRLMOL_INPUT.DAT
  echo "NBOV          = 'N' ! Use NBO driver" >> NRLMOL_INPUT.DAT
  echo "NONSCFV       = 'N' ! Set to Y to do a non SCF calculation" >> NRLMOL_INPUT.DAT
  echo "NONSCFFORCESV = 'N' ! Set to Y to calculate forces in a non SCF calculation" >> NRLMOL_INPUT.DAT
  echo "RHOGRIDV      = 'N' ! Set to Y to execute RHOGRID" >> NRLMOL_INPUT.DAT
  echo "SCFTOLV       = 1.0D-9 ! SCF tolerance" >> NRLMOL_INPUT.DAT
  echo "SOLVENTV      = 'N' ! Set to Y to include solvent effect (SOLVENTS)" >> NRLMOL_INPUT.DAT
  echo "SYMMETRYV     = 'N' ! Set to Y to detect symmetry" >> NRLMOL_INPUT.DAT
  echo "WFGRIDV       = 'N' ! set to Y to calculate wave functions" >> NRLMOL_INPUT.DAT
  if [[ ! -z $xopt ]]; then 
    echo "LIBXCV        = 'Y' ! set to Y to use libxc functionals" >> NRLMOL_INPUT.DAT
  else
    echo "LIBXCV        = 'N' ! set to Y to use libxc functionals" >> NRLMOL_INPUT.DAT
  fi
  echo "&end" >> NRLMOL_INPUT.DAT
}

makeDefaultMESHDAT () {
#This function creates default MESHDAT file prior to a calculation
  echo "     F" > MESHDAT
  echo "  0.10000E-07   1.2000" >> MESHDAT
  echo "   6" >> MESHDAT
  echo "  0.20000      0.40000      0.60000       1.0000       1.6000" >> MESHDAT
  echo "   4" >> MESHDAT
  echo "   2.1000       10.100       18.100" >> MESHDAT
  echo "   2   1   3   5   5   7   9  11  21  21" >> MESHDAT
  echo "   4   1   3   5   5   7   9  11  21  21" >> MESHDAT
  echo "   4   1   3   6   5   7   9  11  21  21" >> MESHDAT
  echo "   6   1   3   6   7   7   9  11  21  21" >> MESHDAT
  echo "  0.10000E-08   1.2000" >> MESHDAT
  echo "   2.0000       8" >> MESHDAT
  echo "   2.0000" >> MESHDAT
  echo " ------------------------------------------------" >> MESHDAT
  echo " * LSYWT" >> MESHDAT
  echo " * ERRMAX, ALFUDGE FOR ATOMIC CUBES" >> MESHDAT
  echo " * NUMBER OF RADIAL ZONES INSIDE ATOM SPHERES" >> MESHDAT
  echo " * OUTER RADII OF SPHERE ZONES" >> MESHDAT
  echo " * NUMBER OF ATOM TYPES (NTYP)" >> MESHDAT
  echo " * UPPER NUCLEAR CHARGE LIMIT FOR EACH ATOM TYPE" >> MESHDAT
  echo " * NPATS, NPIST, NTHET, NPHI, LMAX FOR" >> MESHDAT
  echo "   EACH RADIAL ZONE (NTYP LINES)" >> MESHDAT
  echo " * INTERSTITIALS: ERRMAX, ALFUDGE" >> MESHDAT
  echo " * CUTFAC: IF A BOX TRANSFORMS INTO ITSELF DUE TO" >> MESHDAT
  echo "   SYMMETRY, IT WILL BE SPLIT IF IT IS LARGER THAN" >> MESHDAT
  echo "   CUTFAC TIMES THE DISTANCE TO THE CLOSEST ATOM" >> MESHDAT
  echo "   MX1D: MAX. NUMBER OF POINTS IN A" >> MESHDAT
  echo "   ONE-DIMENSIONAL INTERSTITIAL PARTITION" >> MESHDAT
  echo " * SPLRAT: LARGEST ALLOWED RATIO FOR: THE SIZE OF" >> MESHDAT
  echo "   AN ATOMIC BOX DEVIDED BY THE DISTANCE OF ANOTHER" >> MESHDAT
  echo "   ATOM TO THE BOX BOUNDARY" >> MESHDAT
}


FunctionalFamily () {
#whiptail --title "EXCHANGE-CORRELATION" \ #--default-item "GGA_X_PBE" \
whiptail --title "CHOOSE YOUR FUNCTIONAL FAMILY" --menu "" 10 60 3 \
        "LDA" "Local Density Approximation" \
        "GGA" "Generalized Gradient Approximation" \
        "MGGA"  "Meta-GGA" 2> $tempfile0

retval=$?
choice0=`cat $tempfile0`

case $retval in
  0)
    if  [ "$choice0" == "MGGA" ]; then
      metaGGAFunctional
    elif [ "$choice0" == "GGA" ]; then
      GGA_X_Page1
      GGA_C_Page
    elif [ "$choice0" == "LDA" ]; then
      LDAFunctional
    else
      echo "error"
    fi;;
  1)
    echo "Cancel pressed."
    exit 1;;
esac
}

LDAFunctional () {
whiptail --title "CHOOSE YOUR EXCHANGE FUNCTIONAL" --menu "" 10 60 4 \
  "LDA_X"	"Slater exchange"	\
  "LDA_X_1D"	"Exchange in 1D"	\
  "LDA_X_2D"	"Slater exchange"	\
  "NONE" ""        2> $tempfile1
#  "LDA_XC_TETER93"	"Teter 93"	\
#  "LDA_XC_ZLP"	"Zhao, Levy & Parr, Eq. (20)" 2> $tempfile1

retval=$?
choice1=`cat $tempfile1`

case $retval in
  0)
    echo "$choice1";;
  1)
    echo "Cancel pressed."
    exit 1;;
esac

whiptail --title "CHOOSE YOUR EXCHANGE FUNCTIONAL" --menu "" 35 100 28 \
  "LDA_C_1D_CSC"	"Casula, Sorella & Senatore"	\
  "LDA_C_1D_LOOS"	"P-F Loos correlation LDA"	\
  "LDA_C_2D_AMGB"	"AMGB (for 2D systems)"	\
  "LDA_C_2D_PRM"	"PRM (for 2D systems)"	\
  "LDA_C_GL"	"Gunnarson & Lundqvist"	\
  "LDA_C_GOMBAS"	"Gombas"	\
  "LDA_C_HL"	"Hedin & Lundqvist"	\
  "LDA_C_ML1"	"Modified LSD (version 1) of Proynov and Salahub"	\
  "LDA_C_ML2"	"Modified LSD (version 2) of Proynov and Salahub"	\
  "LDA_C_OB_PW"	"Ortiz & Ballone (PW parametrization)"	\
  "LDA_C_OB_PZ"	"Ortiz & Ballone (PZ parametrization)"	\
  "LDA_C_PW"	"Perdew & Wang"	\
  "LDA_C_PW_MOD"	"Perdew & Wang (modified)"	\
  "LDA_C_PW_RPA"	"Perdew & Wang (fit to the RPA energy)"	\
  "LDA_C_PZ"	"Perdew & Zunger"	\
  "LDA_C_PZ_MOD"	"Perdew & Zunger (Modified)"	\
  "LDA_C_RC04"	"Ragot-Cortona"	\
  "LDA_C_RPA"	"Random Phase Approximation (RPA)"	\
  "LDA_C_VBH"	"von Barth & Hedin"	\
  "LDA_C_VWN"	"Vosko, Wilk & Nusair (VWN5)"	\
  "LDA_C_VWN_1"	"Vosko, Wilk & Nusair (VWN1)"	\
  "LDA_C_VWN_2"	"Vosko, Wilk & Nusair (VWN2)"	\
  "LDA_C_VWN_3"	"Vosko, Wilk & Nusair (VWN3)"	\
  "LDA_C_VWN_4"	"Vosko, Wilk & Nusair (VWN4)"	\
  "LDA_C_VWN_RPA"	"Vosko, Wilk & Nusair (VWN5_RPA)"	\
  "LDA_C_WIGNER"	"Wigner"	\
  "LDA_C_XALPHA"	"Slater's Xalpha" \
  "NONE" ""	 2> $tempfile2
  #"LDA_XC_TETER93"	"Teter 93"	\
  #"LDA_XC_ZLP"	"Zhao, Levy & Parr, Eq. (20)" 2> $tempfile2

retval=$?
choice2=`cat $tempfile2`

case $retval in
  0)
    echo "$choice2";;
  1)
    echo "Cancel pressed."
    exit 1;;
esac
}



GGA_X_Page1 () {
whiptail --title "CHOOSE YOUR EXCHANGE FUNCTIONAL" --menu "" 40 100 30 \
        "GGA_X_2D_B86"	"Becke 86 in 2D" \
        "GGA_X_2D_B86_MGC"	"Becke 86 with modified gradient correction for 2D" \
        "GGA_X_2D_B88"	"Becke 88" \
        "GGA_X_2D_PBE"	"Perdew, Burke & Ernzerhof in 2D" \
        "GGA_X_AIRY"	"Constantin et al based on the Airy gas" \
        "GGA_X_AK13"	"Armiento & Kuemmel 2013" \
        "GGA_X_AM05"	"Armiento & Mattsson 05" \
        "GGA_X_APBE"	"mu fixed from the semiclassical neutral atom" \
        "GGA_X_B86"	"Becke 86" \
        "GGA_X_B86_MGC"	"Becke 86 with modified gradient correction" \
        "GGA_X_B86_R"	"Revised Becke 86 with modified gradient correction" \
        "GGA_X_B88"	"Becke 88" \
        "GGA_X_BAYESIAN"	"Bayesian best fit for the enhancement factor" \
        "GGA_X_BGCP"	"Burke, Cancio, Gould, and Pittalis" \
        "GGA_X_BPCCAC"	"BPCCAC (GRAC for the energy)" \
        "GGA_X_C09X"	"C09x to be used with the VdW of Rutgers-Chalmers" \
        "GGA_X_DK87_R1"	"dePristo & Kress 87 version R1" \
        "GGA_X_DK87_R2"	"dePristo & Kress 87 version R2" \
        "GGA_X_EV93"	"Engel and Vosko" \
        "GGA_X_FT97_A"	"Filatov & Thiel 97 (version A)" \
        "GGA_X_FT97_B"	"Filatov & Thiel 97 (version B)" \
        "GGA_X_G96"	"Gill 96" \
        "GGA_X_GAM"	"GAM functional from Minnesota" \
        "GGA_X_HERMAN"	"Herman Xalphabeta GGA" \
        "GGA_X_HJS_B88"	"HJS screened exchange B88 version" \
        "GGA_X_HJS_B88_V2"	"HJS screened exchange B88 corrected version" \
        "GGA_X_HJS_B97X"	"HJS screened exchange B97x version" \
        "GGA_X_HJS_PBE"	"HJS screened exchange PBE version" \
        "GGA_X_HJS_PBE_SOL"	"HJS screened exchange PBE_SOL version" \
        "Next Page" ""   2> $tempfile1

retval=$?
choice1=`cat $tempfile1`

case $retval in
  0)
    if  [ "$choice1" == "Next Page" ]; then
      GGA_X_Page2
    else
      echo "$choice1"
    fi;;
  1)
    echo "Cancel pressed."
    exit 1;;
esac
}

GGA_X_Page2 () {
whiptail --title "CHOOSE YOUR EXCHANGE FUNCTIONAL" --menu "" 40 100 30 \
        "GGA_X_HTBS"	"Haas, Tran, Blaha, and Schwarz" \
        "GGA_X_ITYH"	"Short-range recipe for exchange GGA functionals" \
        "GGA_X_KT1"	"Keal and Tozer, version 1" \
        "GGA_X_LAG"	"Local Airy Gas" \
        "GGA_X_LAMBDA_CH_N"	"lambda_CH(N) version of PBE" \
        "GGA_X_LAMBDA_LO_N"	"lambda_LO(N) version of PBE" \
        "GGA_X_LAMBDA_OC2_N"	"lambda_OC2(N) version of PBE" \
        "GGA_X_LB"	"van Leeuwen & Baerends" \
        "GGA_X_LBM"	"van Leeuwen & Baerends modified" \
        "GGA_X_LG93"	"Lacks & Gordon 93" \
        "GGA_X_LV_RPW86"        "Berland and Hyldgaard" \
        "GGA_X_MB88"    "Modified Becke 88 for proton transfer" \
        "GGA_X_MPBE"    "Adamo & Barone modification to PBE" \
        "GGA_X_MPW91"   "mPW91 of Adamo & Barone" \
        "GGA_X_N12"     "Minnesota N12 exchange functional to be used with gga_c_n12" \
        "GGA_X_OL2"	"Exchange form based on Ou-Yang and Levy v.2" \
        "GGA_X_OPTB88_VDW"	"opt-Becke 88 for vdW" \
        "GGA_X_OPTPBE_VDW"	"Reparametrized PBE for vdW" \
        "GGA_X_OPTX"	"Handy & Cohen OPTX 01" \
        "GGA_X_PBE"	"Perdew, Burke & Ernzerhof" \
        "GGA_X_PBE_JSJR"	"Reparametrized PBE by Pedroza, Silva & Capelle" \
        "GGA_X_PBE_MOL"	"Reparametrized PBE by del Campo, Gazquez, Trickey & Vela" \
        "GGA_X_PBE_R"	"Revised PBE from Zhang & Yang" \
        "GGA_X_PBE_SOL"	"Perdew, Burke & Ernzerhof SOL" \
        "GGA_X_PBE_TCA"	"PBE revised by Tognetti et al" \
        "GGA_X_PBEA"	"Madsen 07" \
        "GGA_X_PBEINT"	"PBE for hybrid interfaces" \
        "GGA_X_PBEK1_VDW"	"Reparametrized PBE for vdW" \
        "GGA_X_PW86"	"Perdew & Wang 86" \
        "Next Page" ""   2> $tempfile1
        #"More"  "Use functional from GGA_XC"   2> $tempfile1
retval=$?
choice1=`cat $tempfile1`
case $retval in
  0)
    if [ "$choice1" == "Next Page" ]; then
      GGA_X_Page3
    else
      echo "$choice1"
    fi
    return 0;;
  1)
    echo "Cancel pressed."
    exit 1;;
esac
}

GGA_X_Page3 () {
whiptail --title "CHOOSE YOUR EXCHANGE FUNCTIONAL" --menu "" 40 100 30 \
        "GGA_X_PW91"	"Perdew & Wang 91" \
        "GGA_X_Q2D"	"Chiodo et al" \
        "GGA_X_RGE2"	"Regularized PBE" \
        "GGA_X_RPBE"	"Hammer, Hansen, and Norskov" \
        "GGA_X_RPW86"	"Refitted Perdew & Wang 86" \
        "GGA_X_SFAT"	"Short-range recipe for exchange GGA functionals - Yukawa" \
        "GGA_X_SOGGA"	"Second-order generalized gradient approximation" \
        "GGA_X_SOGGA11"	"Second-order generalized gradient approximation 2011" \
        "GGA_X_SSB"	"Swarta, Sola and Bickelhaupt" \
        "GGA_X_SSB_D"	"Swarta, Sola and Bickelhaupt dispersion" \
        "GGA_X_SSB_SW"	"Swarta, Sola and Bickelhaupt correction to PBE" \
        "GGA_X_VMT84_GE"	"VMT{8,4} with constraint satisfaction with mu = mu_GE" \
        "GGA_X_VMT84_PBE"	"VMT{8,4} with constraint satisfaction with mu = mu_PBE" \
        "GGA_X_VMT_GE"	"Vela, Medel, and Trickey with mu = mu_GE" \
        "GGA_X_VMT_PBE"	"Vela, Medel, and Trickey with mu = mu_PBE" \
        "GGA_X_WC"	"Wu & Cohen" \
        "GGA_X_WPBEH"	"short-range part of the PBE (default w=0 gives PBEh)" \
        "GGA_X_XPBE"	"Extended PBE by Xu & Goddard III" \
        "NONE" ""    \
        "Next Page" ""   2> $tempfile1
        #"More"  "Use functional from GGA_XC"   2> $tempfile1
retval=$?
choice1=`cat $tempfile1`
case $retval in
  0)
    if [ "$choice1" == "Next Page" ]; then
      GGA_X_Page1
    else
      echo "$choice1"
    fi
    return 0;;
  1)
    echo "Cancel pressed."
    exit 1;;
esac
}

GGA_C_Page () {
whiptail --title "CHOOSE YOUR CORRELATION FUNCTIONAL" \
--default-item "GGA_C_PBE" --menu "   " 43 100 36 \
    "GGA_C_AM05"	"Armiento & Mattsson 05"	\
    "GGA_C_APBE"	"mu fixed from the semiclassical neutral atom"	\
    "GGA_C_BGCP"	"Burke, Cancio, Gould, and Pittalis"	\
    "GGA_C_FT97"	"Filatov & Thiel correlation"	\
    "GGA_C_LM"	"Langreth & Mehl"	\
    "GGA_C_LYP"	"Lee, Yang & Parr"	\
    "GGA_C_N12"	"Minnesota N12 functional"	\
    "GGA_C_N12_SX"	"Minnesota N12-SX functional"	\
    "GGA_C_OP_B88"	"one-parameter progressive functional (B88 version)"	\
    "GGA_C_OP_G96"	"one-parameter progressive functional (G96 version)"	\
    "GGA_C_OP_PBE"	"one-parameter progressive functional (PBE version)"	\
    "GGA_C_OP_XALPHA"	"one-parameter progressive functional (Xalpha version)"	\
    "GGA_C_OPTC"	"Optimized correlation functional of Cohen and Handy"	\
    "GGA_C_P86"	"Perdew 86"	\
    "GGA_C_PBE"	"Perdew, Burke & Ernzerhof"	\
    "GGA_C_PBE_JRGX"	"Reparametrized PBE by Pedroza, Silva & Capelle"	\
    "GGA_C_PBE_SOL"	"Perdew, Burke & Ernzerhof SOL"	\
    "GGA_C_PBEINT"	"PBE for hybrid interfaces"	\
    "GGA_C_PBELOC"	"Semilocal dynamical correlation"	\
    "GGA_C_PW91"	"Perdew & Wang 91"	\
    "GGA_C_Q2D"	"Chiodo et al"	\
    "GGA_C_REVTCA"	"Tognetti, Cortona, Adamo (revised)"	\
    "GGA_C_RGE2"	"Regularized PBE"	\
    "GGA_C_SOGGA11"	"Second-order generalized gradient approximation 2011"	\
    "GGA_C_SOGGA11_X"	"To be used with HYB_GGA_X_SOGGA11_X"	\
    "GGA_C_SPBE"	"PBE correlation to be used with the SSB exchange"	\
    "GGA_C_TCA"	"Tognetti, Cortona, Adamo"	\
    "GGA_C_VPBE"	"variant PBE"	\
    "GGA_C_WI"	"Wilson & Ivanov"	\
    "GGA_C_WI0"	"Wilson & Ivanov initial version"	\
    "GGA_C_WL"	"Wilson & Levy"	\
    "GGA_C_XPBE"	"Extended PBE by Xu & Goddard III"	\
    "GGA_C_ZPBEINT"	"spin-dependent gradient correction to PBEint"	\
    "GGA_C_ZPBESOL"	"spin-dependent gradient correction to PBEsol"	\
    "GGA_C_GAM"	"GAM functional from Minnesota"	\
    "NONE"  ""  2> $tempfile2
retval=$?
choice2=`cat $tempfile2`
case $retval in
  0)
    echo "$choice2";;
  1)
    echo "Cancel pressed."
    exit 1;;
esac
}


metaGGAFunctional () {

whiptail --title "CHOOSE YOUR EXCHANGE FUNCTIONAL" --menu "   " 40 100 36 \
  "MGGA_X_SCAN"	  "SCAN"   \
  "MGGA_X_2D_PRHG07"	"Pittalis-Rasanen-Helbig-Gross 2007"	\
  "MGGA_X_2D_PRHG07_PRP10"	"PRHG07 with Pittalis-Rasanen-Proetto 2010 correction"	\
  "MGGA_X_BJ06"	"Becke & Johnson 06"	\
  "MGGA_X_BLOC"	"functional with balanced localization"	\
  "MGGA_X_BR89"	"Becke-Roussel 89"	\
  "MGGA_X_GVT4"	"GVT4 (X part of VSXC)"	\
  "MGGA_X_LTA"	"Local tau approximation"	\
  "MGGA_X_M05"	"Worker for hyb_mgga_xc_m05"	\
  "MGGA_X_M05_2X"	"Worker for hyb_mgga_xc_m05_2x"	\
  "MGGA_X_M06"	"Worker for hyb_mgga_xc_m06"	\
  "MGGA_X_M06_2X"	"Worker for hyb_mgga_m06_2x"	\
  "MGGA_X_M06_HF"	"Worker for hyb_mgga_xc_m06_hf"	\
  "MGGA_X_M06_L"	"Minnesota M06-L functional"	\
  "MGGA_X_M08_HX"	"Worker for hyb_mgga_x_m08_hx"	\
  "MGGA_X_M08_SO"	"Worker for hyb_mgga_x_m08_so"	\
  "MGGA_X_M11"	"Worker for hyb_mgga_xc_m11"	\
  "MGGA_X_M11_L"	"Minnesota M11-L exchange functional"	\
  "MGGA_X_MBEEF"	"mBEEF exchange"	\
  "MGGA_X_MBEEFVDW"	"mBEEF-vdW exchange"	\
  "MGGA_X_MK00"	"Exchange for accurate virtual orbital energies"	\
  "MGGA_X_MK00B"	"Exchange for accurate virtual orbital energies (v. B)"	\
  "MGGA_X_MN12_L"	"Minnesota MN12-L functional"	\
  "MGGA_X_MN12_SX"	"Worker for hyb_mgga_x_mn12_sx"	\
  "MGGA_X_MODTPSS"	"Modified Tao, Perdew, Staroverov & Scuseria"	\
  "MGGA_X_MS0"	"MS exchange of Sun, Xiao, and Ruzsinszky"	\
  "MGGA_X_MS1"	"MS1 exchange of Sun, et al"	\
  "MGGA_X_MS2"	"MS2 exchange of Sun, et al"	\
  "MGGA_X_MVS"	"MVS exchange of Sun, Perdew, and Ruzsinszky"	\
  "MGGA_X_PKZB"	"Perdew, Kurth, Zupan, and Blaha"	\
  "MGGA_X_REVTPSS"	"revised Tao, Perdew, Staroverov & Scuseria"	\
  "MGGA_X_RPP09"	"Rasanen, Pittalis & Proetto 09"	\
  "MGGA_X_TAU_HCTH"	"tau-HCTH"	\
  "MGGA_X_TB09"	"Tran & Blaha 09"	\
  "MGGA_X_TPSS"	"Tao, Perdew, Staroverov & Scuseria"	\
  "NONE" ""   2> $tempfile1
  retval=$?
  choice1=`cat $tempfile1`
  case $retval in
    0)
      echo "$choice1";;
    1)
      echo "Cancel pressed."
      exit 1;;
  esac


whiptail --title "CHOOSE YOUR CORRELATION FUNCTIONAL" --menu "   " 30 100 22 \
  "MGGA_C_BC95"	"Becke correlation 95"	\
  "MGGA_C_CC06"	"Cancio and Chou 2006"	\
  "MGGA_C_CS"	"Colle and Salvetti"	\
  "MGGA_C_DLDF"	"Dispersionless Density Functional"	\
  "MGGA_C_M05"	"Worker for hyb_mgga_xc_m05"	\
  "MGGA_C_M05_2X"	"Worker for hyb_mgga_xc_m05_2x"	\
  "MGGA_C_M06"	"Worker for hyb_mgga_xc_m06"	\
  "MGGA_C_M06_2X"	"Worker for hyb_mgga_xc_m06_2x"	\
  "MGGA_C_M06_HF"	"Worker for hyb_mgga_xc_m06_hf"	\
  "MGGA_C_M06_L"	"Minnesota M06-L functional"	\
  "MGGA_C_M08_HX"	"Worker for hyb_mgga_xc_m08_hx"	\
  "MGGA_C_M08_SO"	"Worker for hyb_mgga_xc_m08_so"	\
  "MGGA_C_M11"	"Worker for hyb_mgga_xc_m11"	\
  "MGGA_C_M11_L"	"Minnesota M11-L correlation functional"	\
  "MGGA_C_MN12_L"	"Minnesota MN12-L correlation functional"	\
  "MGGA_C_MN12_SX"	"Worker for hyb_mgga_xc_mn12_sx"	\
  "MGGA_C_PKZB"	"Perdew, Kurth, Zupan, and Blaha"	\
  "MGGA_C_REVTPSS"	"revised TPSS correlation"	\
  "MGGA_C_TPSS"	"Tao, Perdew, Staroverov & Scuseria"	\
  "MGGA_C_TPSSLOC"	"Semilocal dynamical correlation"	\
  "MGGA_C_VSXC"	"VSXC (correlation part)"	\
  "NONE" ""    2> $tempfile2

#  "MGGA_XC_B97M_V"	"B97M-V exchange-correlation functional"	\
#  "MGGA_XC_OTPSS_D"	"oTPSS-D functional of Goerigk and Grimme"	\
#  "MGGA_XC_TPSSLYP1W"	"TPSSLYP1W"	\
#  "MGGA_XC_ZLP"	"Zhao, Levy & Parr, Eq. (21)"

retval=$?
choice2=`cat $tempfile2`
case $retval in
  0)
    echo "$choice2";;
  1)
    echo "Cancel pressed."
    exit 1;;
esac
}

PrintFunctional () {
  whiptail --msgbox "Functional set to: $choice1*$choice2 Basis set is: $bopt" 10 50
  echo $choice1*$choice2
}

CleaningUp () {
  rm ATOMMAP COULOMB HAMBABY HAMBST HAMOLD nrlmol_exe OVLBABY POTOLD REPMAT VMOLD WFOUT 2> /dev/null
}

showHelp () {
   echo "Usage test1 [OPTION]..."
   echo "Run NRLMOL testing suites."
   echo ""
   echo "  -x  use libxc for calculations (this option will turn on Ham mixing automatically)"
   echo "  -m  use Hamiltonian mixing"
   echo "  -h  display this help and exit"
   echo "  -v  dispaly version information and exit"
   echo "  -d  debug run"
   echo "  -b [basis name]  specify a basis set to use"
   echo "  -r  rerun the calculations for failed atoms/molecules"
   echo ""
   echo "Note: You must run this program in a same directory as a NRLMOL binary."
   exit
}

showVersionInfo () {
   echo "NRLMOL testing suites 12/7/2015"
   echo "Copyright (C) 2015 Electronic Structure Lab."
   echo "This is free software: you are free to change and redistribute it."
   echo "There is NO WARRANTY, to the extent permitted by law."
   echo ""
   echo "Written by Yoh Yamamoto."
   exit
}

########################
#This is the Main code #
########################
while getopts xmhvdrb: name
do
   case $name in
      x)xopt=1;;
      m)mopt=1;;
      h)hopt=1;;
      v)vopt=1;;
      d)dopt=1;;
      b)bopt=$OPTARG;;
      r)ropt=1;;
      *)echo "Invalid arg" && showHelp;;
   esac
done

if [[ ! -z $hopt ]]; then 
   showHelp
fi
if [[ ! -z $vopt ]]; then
   showVersionInfo
fi

#Calling Greeting function
Greeting
nrlmolmode="default"
if [[ ! -z $mopt ]]; then
  nrlmolmode="hammix"
fi
if [[ -z $bopt ]];then
  #echo "basis set is: $bopt"
  bopt="default"
fi


#Choose mode: 1 Run and compare, 2 Run only, 3 Compare only
ChooseMode
if [ ! $runmode -eq 3 ]; then
  #Calling WhatToCompare
  #WhatToCompare

  #Calling ChooseFunctionals function
  if [[ ! -z $xopt ]]; then
    mopt=1
    nrlmolmode="libxc"
    #Libxc
    FunctionalFamily
    PrintFunctional
  else
    #Builtin functional options
    ChooseFunctionals
  fi
  subdirname="$nrlmolmode/$bopt"
fi
$DIALOG --msgbox "$nrlmolmode/$bopt/$choice1*$choice2" 10 40

#dump the command line args
shift $(($OPTIND -1))

#Calling ChooseTestSet function
ChooseTestSet #and generate CLUSTER files  ##Compare only

#Checking mpi is available or not (not completed)
if [ ! $runmode -eq 3 ]; then
  mpiCheck
  #Run executable(s)
  #Check if there's a job scheduler or not
  if type bsub >/dev/null 2>&1; then
    RunBsub
    $DIALOG --msgbox "Jobs queued with bsub." 10 40
    farewell
  elif type qsub >/dev/null 2>&1; then
    RunQsub
    $DIALOG --msgbox "Jobs queued with qsub." 10 40
    farewell
  elif type sbatch >/dev/null 2>&1; then
    RunSbatch
    $DIALOG --msgbox "Jobs queued with sbatch." 10 40
    farewell
  else
    RunNRLMOL
  fi
fi
if [ ! $runmode -eq 2 ]; then
  #Calling compareResults function
  compareResults  ##Compare only
fi
#Calling farewell function
farewell
