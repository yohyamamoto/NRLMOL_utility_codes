#!/bin/bash

#Cluster or nrlmol_exe
if [ -e nrlmol_exe.0 ]; then
  #Here nrlmol_exe.0 is your reference executable i.e. orginal code.
  exe0=${exe0=nrlmol_exe.0}
  exe1=${exe1=nrlmol_exe}
elif [ -e cluster.0 ]; then
  exe0=${exe=cluster.0}
  exe1=${exe=cluster}
else
   if [ -e nrlmol_exe ]; then
     exe0=${exe0=nrlmol_exe}
     exe1=${exe1=nrlmol_exe}
   elif [ -e cluster ]; then
     exe0=${exe=cluster}
     exe1=${exe=cluster}
   else
     echo "Excutable not found. Aborting."
     exit 1
   fi
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
if [ ! "$exe0" == "$exe1" ]; then
  compareto=-1
fi

tempfile=`tempfile 2>/dev/null` || tempfile=/tmp/test$$
tempfile1=/tmp/dialog_1_$$
tempfile2=/tmp/dialog_2_$$
tempfile3=/tmp/dialog_3_$$
tempfile4=/tmp/dialog_4_$$
tempfile5=/tmp/dialog_5_$$
tempfile6=/tmp/dialog_6_$$
trap "rm -f $tempfile $tempfile1 $tempfile2 $tempfile3 $tempfile4 $tempfile5 $tempfile6" 0 1 2 5 15

currentdir=$(pwd)
if [ ! -d testing ]; then
  mkdir testing
  (( previousrun=0 ))
else
  (( previousrun=1 ))
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
    255)
      echo "ESC pressed.";;
    esac
}

ChooseMode () {
  $DIALOG --title "Mode" --nocancel \
          --menu "Choose a mode" 10 60 3 \
          "1" "Run and compare" \
          "2" "Run only" \
          "3" "Compare only" 2> $tempfile6
  retval=$?
  runmode=`cat $tempfile6`
}

WhatToCompare () {
  if ! [ $compareto -eq -1 ]; then
    $DIALOG --title "What to compare" --nocancel \
            --menu "For a starter, you should choose what to compare." 10 60 3 \
            "1"   "Potential mixing vs. Hamiltonian mixing" \
            "2"   "Libxc on vs. off" \
            "3"   "Libxc on vs. off while using Hamitonian mixing"  2> $tempfile4

    retval=$?
    compareto=`cat $tempfile4`
  else
    dialog --msgbox "Two executables found. This program will compare nrlmol_exe.0 and nrlmol_exe" 8 50
  fi
  if [ $previousrun -eq 1 ]; then
    $DIALOG --yesno "testing directory found. Would you like to use previous results for nrlmol_exe.0?" 10 50
    case $? in
      0)
        ;;
      1)
        previousrun=0;;
      255)
        echo "ESC pressed.";;
    esac
  fi
}

ChooseFunctionals () {
  $DIALOG --title "EXCHANGE-CORRELATION" \
          --default-item "GGA-PBE" --nocancel\
          --menu "Hi, this is a menu box to choose exchange-correlation functionals. \
          First, choose your exchange functional:" 24 51 10 \
          "GGA-NONE"    "None" \
          "LDA-PERZUN"  "PERDEW-ZUNGER 81"   \
          "LDA-RPA"     "Random Phase Approximation" \
          "LDA-WIGNER"  "WIGNER"\
          "LDA-GUNLUN"  "GUNNARSSON-LUNDQVIST" \
          "GGA-PW91"    "PERDEW-WANG 91" \
          "GGA-PBE"     "PERDEW-BURKE-ERNZERHOF 96" \
          "GGA-REVPBE"  "REV PBE" \
          "GGA-RPBE"    "R PBE" \
          "GGA-B88"     "BECKE 88"  2> $tempfile1

  retval=$?
  choice1=`cat $tempfile1`

  $DIALOG --title "EXCHANGE-CORRELATION" \
          --default-item "GGA-PBE" \
          --menu "Next, choose your correlation functional:\n " 24 51 10 \
          "GGA-NONE"    "None" \
          "LDA-PERZUN"  "PERDEW-ZUNGER 81"   \
          "LDA-RPA"     "Random Phase Approximation" \
          "LDA-WIGNER"  "WIGNER"\
          "LDA-GUNLUN"  "GUNNARSSON-LUNDQVIST" \
          "GGA-PW91"    "PERDEW-WANG 91" \
          "GGA-PBE"     "PERDEW-BURKE-ERNZERHOF 96" \
          "GGA-REVPBE"  "REV PBE" \
          "GGA-RPBE"    "R PBE" \
          "GGA-B88"     "BECKE 88"  2> $tempfile2

  retval=$?
  choice2=`cat $tempfile2`

  case $retval in
    0)
      echo "'$choice1' and '$choice2' chosen."
      $DIALOG --msgbox "Functional set to $choice1*$choice2" 10 40
      functionalchosen=$choice1*$choice2;;
      ##echo "'$choice1'*'$choice2'" > $currentdir/testing CLUSTER
    1)
      echo "Cancel pressed."
      exit 1;;
    255)
      echo "ESC pressed."
      $DIALOG --msgbox 'Exiting this program' 10 30
      exit 1;;
  esac
}

ChooseTestSet () {
  $DIALOG --title "Testing set" \
          --default-item "dX40" \
          --menu "Next, choose your correlation functional:\n " 24 51 7 \
          "SINGLE"  "Mn atom" \
          "MAIN5"   "Run CH4, CO2, H2AFM, H2O, and Mn"   \
          "dX40"     "Run a dX40 molecule 1-20"  2> $tempfile5

  retval=$?
  choice5=`cat $tempfile5`
  case $retval in
    0)
      if  [ "$choice5" == "SINGLE" ]; then
        istart=0
        imax=1
        PrepCluster_Mn
      elif [ "$choice5" == "MAIN5" ]; then
        istart=0
        imax=5
        PrepCluster
      elif [ "$choice5" == "dX40" ]; then
        istart=0
        imax=40
        #imax=478
        PrepCluster_dx40
      else
        $DIALOG --msgbox "Oops" 10 20
      fi;;
    1)
      echo "Cancel pressed."
      exit 1;;
    255)
      echo "ESC pressed."
      exit 1;;
  esac
}

#SelectMolecule () {
  ##Select molecules and/atoms
  #whiptail --title "Choose your molecules" --nocancel --checklist \
  #"Choose molecules for testing" 20 30 10 \
  #"1" "CH4      " ON \
  #"2" "CO2      " ON \
  #"3" "H2AFM    " ON \
  #"4" "H2O      " ON \
  #"5" "Mn       "  ON \
  #"6" "?????    "  OFF \
  #"7" "?????    "  OFF \
  #"8" "?????    "  OFF \
  #"9" "?????    "  OFF \
  #"10"  "?????    "  OFF 2>$tempfile5

  #listmol=`cat $tempfile5`
  #imax=`cat $tempfile5 | wc -w`

  #chmol=`cat $tempfile5 | cut -d " " -f1`
  #increment atom number 1 to 10 then use `echo $listmol | grep "\"1\"" -c`
  #to decide if a user chose the given molecule or not i.e. 0 skip and 1 do somthing

  #doit=`echo $listmol  | grep "\"$i\"" -c`
  #$DIALOG --msgbox "$listmol" 10 30
#}

PrepCluster_Mn () {
  $DIALOG --title "CLUSTER file" \
          --msgbox "Preparing Mn CLUSTER file" 10 40
  atom1="Mn"
  if [ ! -d $atom1 ]; then
    mkdir $atom1
  fi
  cp ../$exe0 ./$atom1/
  if [ ! "$exe0" == "$exe1" ]; then
    cp ../$exe1 ./$atom1/
  fi
  echo "$choice1*$choice2" >	./$atom1/CLUSTER
  echo "GRP" >> ./$atom1/CLUSTER
  echo "1 Number of inequivalent atoms" >> ./$atom1/CLUSTER
  echo " 0.0000     0.0000     0.0000   25 ALL SUP" >> ./$atom1/CLUSTER
  echo " 0.0000     5.0000 Net Charge and Moment" >> ./$atom1/CLUSTER

  echo " 1 Number of group elements" >	./$atom1/GRPMAT
  echo "     1.0000        0.00000         0.00000" >> ./$atom1/GRPMAT
  echo "     0.0000        1.00000         0.00000" >> ./$atom1/GRPMAT
  echo "     0.0000        0.00000         1.00000" >> ./$atom1/GRPMAT
}


PrepCluster () {
  $DIALOG --title "CLUSTER file" \
          --msgbox "Preparing CLUSTER files for Main 5" 10 40

  #$DIALOG --msgbox "I will generate five molecules for this test." 10 40

  #CH4
  atom1="CH4"
  if [ ! -d $atom1 ]; then
    mkdir $atom1
  fi
    cp ../$exe0 ./$atom1/
  if [ ! "$exe0" == "$exe1" ]; then
    cp ../$exe1 ./$atom1/
  fi
  echo "$choice1*$choice2" > ./$atom1/CLUSTER
  echo "TD" >> ./$atom1/CLUSTER
  echo "2" >> ./$atom1/CLUSTER
  echo "0.00  0.00  0.00  6  ALL" >> ./$atom1/CLUSTER
  echo "1.20  1.20  1.20  1  ALL" >> ./$atom1/CLUSTER
  echo "0.0 0.0" >> ./$atom1/CLUSTER

  #CO2
  atom2="CO2"
  if [ ! -d $atom2 ]; then
    mkdir $atom2
  fi
  cp ../$exe0 ./$atom2/
  if [ ! "$exe0" == "$exe1" ]; then
    cp ../$exe1 ./$atom2/
  fi
  echo "$choice1*$choice2" > ./$atom2/CLUSTER
  echo "GRP" >> ./$atom2/CLUSTER
  echo "2 Number of inequivalent atoms" >> ./$atom2/CLUSTER
  echo " 0.00  0.00  0.00  6  ALL UPO" >> ./$atom2/CLUSTER
  echo "-1.50  0.00  0.00  8  ALL UPO" >> ./$atom2/CLUSTER
  echo " 0.00   0.00 Net Charge and Moment" >> ./$atom2/CLUSTER

  echo " 2 Number of group elements" > ./$atom2/GRPMAT
  echo "     1.0000        0.00000         0.00000" >> ./$atom2/GRPMAT
  echo "     0.0000        1.00000         0.00000" >> ./$atom2/GRPMAT
  echo "     0.0000        0.00000         1.00000" >> ./$atom2/GRPMAT
  echo "" >> ./$atom2/GRPMAT
  echo "    -1.0000        0.00000         0.00000" >> ./$atom2/GRPMAT
  echo "     0.0000        1.00000         0.00000" >> ./$atom2/GRPMAT
  echo "     0.0000        0.00000         1.00000" >> ./$atom2/GRPMAT

  #H2AFM
  atom3="H2AFM"
  if [ ! -d $atom3 ]; then
    mkdir $atom3
  fi
  cp ../$exe0 ./$atom3/
  if [ ! "$exe0" == "$exe1" ]; then
    cp ../$exe1 ./$atom3/
  fi
  echo "$choice1*$choice2" >	./$atom3/CLUSTER
  echo "GRP" >> ./$atom3/CLUSTER
  echo "2 Number of inequivalent atoms" >> ./$atom3/CLUSTER
  echo "-0.708846     0.0000     0.0000   1 ALL SUP" >> ./$atom3/CLUSTER
  echo " 0.708846     0.0000     0.0000   1 ALL SDN" >> ./$atom3/CLUSTER
  echo " 0.00   0.00 Net Charge and Moment" >> ./$atom3/CLUSTER

  echo " 1 Number of group elements" >	./$atom3/GRPMAT
  echo "     1.0000        0.00000         0.00000" >> ./$atom3/GRPMAT
  echo "     0.0000        1.00000         0.00000" >> ./$atom3/GRPMAT
  echo "     0.0000        0.00000         1.00000" >> ./$atom3/GRPMAT

  atom4="H2O"
  if [ ! -d $atom4 ]; then
    mkdir $atom4
  fi
  cp ../$exe0 ./$atom4/
  if [ ! "$exe0" == "$exe1" ]; then
    cp ../$exe1 ./$atom4/
  fi
  echo "$choice1*$choice2" >	./$atom4/CLUSTER
  echo "GRP" >> ./$atom4/CLUSTER
  echo "2 Number of inequivalent atoms" >> ./$atom4/CLUSTER
  echo " 0.0000     0.0000     0.0000   8 ALL UPO" >> ./$atom4/CLUSTER
  echo "-1.4943     1.1568     0.0000   1 ALL UPO" >> ./$atom4/CLUSTER
  echo " 0.00   0.00 Net Charge and Moment" >> ./$atom4/CLUSTER

  echo " 2 Number of group elements" >	./$atom4/GRPMAT
  echo "     1.0000        0.00000         0.00000" >> ./$atom4/GRPMAT
  echo "     0.0000        1.00000         0.00000" >> ./$atom4/GRPMAT
  echo "     0.0000        0.00000         1.00000" >> ./$atom4/GRPMAT
  echo "" >> ./$atom4/GRPMAT
  echo "    -1.0000        0.00000         0.00000" >> ./$atom4/GRPMAT
  echo "     0.0000        1.00000         0.00000" >> ./$atom4/GRPMAT
  echo "     0.0000        0.00000         1.00000" >> ./$atom4/GRPMAT

  atom5="Mn"
  if [ ! -d $atom5 ]; then
    mkdir $atom5
  fi
  cp ../$exe0 ./$atom5/
  if [ ! "$exe0" == "$exe1" ]; then
    cp ../$exe1 ./$atom5/
  fi
  echo "$choice1*$choice2" >	./$atom5/CLUSTER
  echo "GRP" >> ./$atom5/CLUSTER
  echo "1 Number of inequivalent atoms" >> ./$atom5/CLUSTER
  echo " 0.0000     0.0000     0.0000   25 ALL SUP" >> ./$atom5/CLUSTER
  echo " 0.0000     5.0000 Net Charge and Moment" >> ./$atom5/CLUSTER

  echo " 1 Number of group elements" >	./$atom5/GRPMAT
  echo "     1.0000        0.00000         0.00000" >> ./$atom5/GRPMAT
  echo "     0.0000        1.00000         0.00000" >> ./$atom5/GRPMAT
  echo "     0.0000        0.00000         1.00000" >> ./$atom5/GRPMAT
}

#read and copy CLUSTER from dX40 directory
PrepCluster_dx40 () {
  $DIALOG --msgbox "Preparing dX40 CLUSTERS" 10 20
  dx40dir=$currentdir/dX40
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
      cd $testdir/$clustername/

      #mkdir test0
      #mkdir test$compareto

      #use sed to replace the first line in the cluster
      cat $dx40dir/$clustername.CLUSTER | sed -e "s/GGA-PBE\*GGA-PBE/$choice1\*$choice2/g" > ./CLUSTER
      cp $currentdir/$exe0 ./
      cp $currentdir/$exe1 ./

      (( i++ ))
      (( c= i*100/imax ))
      echo $c
      echo "###"
      echo "$c %"
      echo "###"
    done
  ) |
  $DIALOG --title "Preparing CLUSTER files" \
          --gauge "Plese wait..." 10 60 0
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
          --inputbox "How many processors do you want to use? Enter a number below:" 12 40 4 2> $tempfile

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
    255)
       echo "ESC pressed."
       $DIALOG --msgbox 'Exiting this program' 5 30
       exit 1;;
  esac
#fi
}

RunNRLMOL () {
  echo "Running NRLMOL"
  (
  #imax=5  #Max entries of atoms/molecules <- moved up to the CLUSTER selection part
  (( iincre=100/($imax*2) )) #increments
  c=0 #progress bar
  i=$istart #i is for concatinating directory variables
#  while [ $c -ne 100 ] #old way
  while [ $i -lt $imax ]  #revised way
    do
      (( i++ ))
      var="atom$i"
      cd $testdir/${!var}
      if [ "$choice5" == "dX40" ]; then
        var=`ls $dx40dir | sed -n $i,${i}p | cut -d "." -f1`
        #$DIALOG --msgbox "$var" 10 20
        echo "$var"
        cd $testdir/$var
      fi

      echo $c
      echo "###"
      echo "$c %"
      echo "###"
      (( c+=$iincre ))

      #Run NRLMOL with builtin functional
      #Skip the reference run if you choose to do so
      if [ $previousrun == 0 ]; then
        if [ -e GEOCNVRG ]; then
          rm GEOCNVRG
        fi
        if [ -e RUNS ]; then
          rm RUNS
        fi
        if [ -e RUNNING ]; then
          rm RUNNING
        fi
        if [ -e NRLMOL_INPUT.DAT ]; then
          rm NRLMOL_INPUT.DAT
        fi
        if [ -e HAMXC.dat ]; then
          rm HAMXC.dat
        fi
        if [ -e HAMMIXOLD ]; then
          rm HAMMIXOLD
        fi
        #Create default NRLMOL_INPUT.DAT
        makeDefaultNRLMOL_INPUT

        #if [ $compareto -eq 3 ];then
        #  echo "&input_data" >> NRLMOL_INPUT.DAT
          #echo "MAXSCFV       = 1" >> NRLMOL_INPUT.DAT
        #  echo "MIXPOTV       = 'N'" >> NRLMOL_INPUT.DAT
        #  echo "LIBXCV        = 'N'" >> NRLMOL_INPUT.DAT
        #  echo "&end" >> NRLMOL_INPUT.DAT
        #fi

        if [ -e ERROR_NRLMOL ]; then
          rm ERROR_NRLMOL
        fi
        #./$exe > ./print.out.0
        mpirun -np $npchoice ./$exe0 >& print.out
        #echo "running $i" >& print.out
        if [ ! -d test0 ]; then
          mkdir test0
        fi
        mv SUMMARY test0/
        mv print.out test0/
        mv EVAL* test0/
        mv FRCOUT test0/
        cp NRLMOL_INPUT.DAT test0/
        if [ -e HAMXC.dat ]; then
          mv HAMXC*dat test0/
        fi
      else
        #You need to append something to NRLMOL_INPUT.DAT
        if ! [ -e NRLMOL_INPUT.DAT ]; then
          echo "&input_data" >> NRLMOL_INPUT.DAT
          echo "&end" >> NRLMOL_INPUT.DAT
        fi
      fi

      echo $c
      echo "###"
      echo "$c %"
      echo "###"
      (( c+=$iincre ))

      #Run NRLMOL with hammixing
      if [ $compareto -eq 1 ];then
        echo "Running NRLMOL with hammixing"
        sed -i '/MIXPOTV/d' NRLMOL_INPUT.DAT
        sed -i '/&end/d' NRLMOL_INPUT.DAT
        echo "MIXPOTV       = 'N'" >> NRLMOL_INPUT.DAT
        echo "&end" >> NRLMOL_INPUT.DAT

        #Run NRLMOL with libxc functional
      elif [ $compareto -eq 2 ]; then
        echo "Running NRLMOL with libxc functional"
        sed -i '/LIBXCV/d' NRLMOL_INPUT.DAT
        sed -i '/&end/d' NRLMOL_INPUT.DAT
        echo "LIBXCV        = 'Y'" >> NRLMOL_INPUT.DAT
        echo "&end" >> NRLMOL_INPUT.DAT

      elif [ $compareto -eq 3 ]; then
        sed -i '/MIXPOTV/d' NRLMOL_INPUT.DAT
        sed -i '/LIBXCV/d' NRLMOL_INPUT.DAT
        sed -i '/&end/d' NRLMOL_INPUT.DAT
        echo "MIXPOTV       = 'N'" >> NRLMOL_INPUT.DAT
        echo "LIBXCV        = 'Y'" >> NRLMOL_INPUT.DAT
        echo "&end" >> NRLMOL_INPUT.DAT
      else
        echo "Running NRLMOL with no change in NRLMOL_INPUT.DAT"
      fi


      if [ -e GEOCNVRG ]; then
        rm GEOCNVRG
      fi
      if [ -e RUNS ]; then
        rm RUNS
      fi
      if [ -e RUNNING ]; then
        rm RUNNING
      fi
      if [ -e ERROR_NRLMOL ]; then
        rm ERROR_NRLMOL
      fi
      if [ -e HAMXC.dat ]; then
        rm HAMXC.dat
      fi
      if [ -e HAMMIXOLD ]; then
        rm HAMMIXOLD
      fi

      #./$exe > print.out.1
      mpirun -np $npchoice ./$exe1 >& print.out
      #echo "Running $i second" >& print.out
      if [ ! -d test$compareto ]; then
        mkdir test$compareto
      fi
      mv SUMMARY test$compareto/
      mv print.out test$compareto/
      mv EVAL* test$compareto/
      mv FRCOUT test$compareto/
      cp NRLMOL_INPUT.DAT test$compareto/

      if [ -e HAMXC.dat ]; then
        mv HAMXC*dat test$compareto/
      fi
      if [ ! -d benchmark ]; then
        mkdir benchmark
      fi
    done
  echo $c
  echo "###"
  echo "$c %"
  echo "###"
  cd $testdir
  ) |
  $DIALOG --title "Running NRLMOL" --gauge "Plese wait..." 10 60 0
  $DIALOG --msgbox "Finished. Let's see the result. NRLMOL run with a builtin functional will be shown on the left and libxc to the right" 10 60
}


#Check and see the differences between builtin functional and libxc functional
compareResults () {
  $DIALOG --title "Results" \
          --msgbox "This will show SUMMARY, EVALUES, and print.out side by side." 15 50

  for (( i=istart+1; i<=imax; i++ ))
    do
      var="atom$i"
      vardir=${!var}
      if [ "$choice5" == "dX40" ]; then
        var=`ls $dx40dir | sed -n $i,${i}p | cut -d "." -f1`
        vardir=$var
      fi
      #touch $testdir/$vardir/meowC
      echo "$vardir"

      #var=`ls $dx40dir | sed -n $i,${i}p | cut -d "." -f1`
      $DIALOG --title "Results" --msgbox "$vardir" 10 40

      diff -y $vardir/test?/SUMMARY > $vardir/benchmark/summary.dat
      cat $vardir/benchmark/summary.dat | expand -t 8 > $vardir/benchmark/tmp.dat
      $DIALOG --title "$vardir SUMMARY nrlmol_exe.0 vs. nrlmol_exe" \
              --scrolltext --clear \
              --textbox $vardir/benchmark/tmp.dat 40 140

      #Using cat before diff to avoid an iteration mismatch #this doesn't quite work
      cat $vardir/test0/print.out | grep -E "ITERATION|TOTAL ENERGY|REPULSION:|POTENTIAL:|MEAN-FIELD COULOMB:|EXCHANGE|CORRELATION|ENERGY|KINETIC:|FIELD:|SUMMARY" > $vardir/benchmark/print.dat.0
      cat $vardir/test$compareto/print.out | grep -E "ITERATION|TOTAL ENERGY|REPULSION:|POTENTIAL:|MEAN-FIELD COULOMB:|EXCHANGE|CORRELATION|ENERGY|KINETIC:|FIELD:|SUMMARY" > $vardir/benchmark/print.dat.1
      diff -y $vardir/benchmark/print.dat.? > $vardir/benchmark/print.dat

      #vim -R ${!var}/benchmark/print.dat
      #vimdiff -R ${!var}/test?/print.out

      cat $vardir/benchmark/print.dat | expand -t 8 > $vardir/benchmark/tmp.dat
      $DIALOG --title "$vardir print.out nrlmol_exe.0 vs. nrlmol_exe" \
              --scrolltext --clear\
              --textbox $vardir/benchmark/tmp.dat 40 130

      #diff -y ${!var}/test?/EVAL001 > ${!var}/benchmark/EVAL001.dat
      #$DIALOG --title "${!var} EVAL001" \
      #        --scrolltext \
      #        --textbox ${!var}/benchmark/EVAL001.dat 40 140

      #Make a menu and let user choose the energy then display it
      #e.g. cat ${!var}/benchmark/print.dat | grep TOTAL\ ENERGY: | tr -d 'TOTAL ENERGY:' | cat -n > ${!var}/benchmark/Etot.dat


      #Making output files
      echo "LOCAL POTENTIAL" > $vardir/benchmark/Elp.dat
      cat $vardir/benchmark/print.dat | grep "LOCAL POTENTIAL:" | grep -v "NONLOCAL" | tr -s " " | sed -e "s/LOCAL POTENTIAL: /\t\t\t\t\t/g" | sed -e 's/\t\t\t\t\t//g' | cat -n >> $vardir/benchmark/Elp.dat
      echo "TOTAL ENERGY" > $vardir/benchmark/Etot.dat
      cat $vardir/benchmark/print.dat | grep "TOTAL ENERGY:" | tr -s " " | sed -e "s/TOTAL ENERGY: /\t\t\t\t\t/g" | sed -e 's/\t\t\t\t\t//g' |  cat -n >> $vardir/benchmark/Etot.dat
      echo "NUCLEAR REPULSION" > $vardir/benchmark/Enr.dat
      cat $vardir/benchmark/print.dat | grep "NUCLEAR REPULSION:" | tr -s " " | sed -e "s/NUCLEAR REPULSION: /\t\t\t\t\t/g" | sed -e 's/\t\t\t\t\t//g' |  cat -n >> $vardir/benchmark/Enr.dat
      echo "MEAN-FIELD COULOMB" > $vardir/benchmark/Emfc.dat
      cat $vardir/benchmark/print.dat | grep "MEAN-FIELD COULOMB:" | tr -s " " | sed -e "s/MEAN-FIELD COULOMB: /\t\t\t\t\t/g" | sed -e 's/\t\t\t\t\t//g' |  cat -n >> $vardir/benchmark/Emfc.dat
      echo "KINETIC+NONLOCAL POTENTIAL" > $vardir/benchmark/Eknp.dat
      cat $vardir/benchmark/print.dat | grep "KINETIC+NONLOCAL POTENTIAL:" | tr -s " " | sed -e "s/KINETIC+NONLOCAL POTENTIAL: /\t\t\t\t\t/g" | sed -e 's/\t\t\t\t\t//g' |  cat -n >> $vardir/benchmark/Eknp.dat
      echo "EXCHANGE-CORRELATION" > $vardir/benchmark/Exc.dat
      cat $vardir/benchmark/print.dat | grep "EXCHANGE-CORRELATION:" | tr -s " " | sed -e "s/EXCHANGE-CORRELATION: /\t\t\t\t\t/g" | sed -e 's/\t\t\t\t\t//g' |  cat -n >> $vardir/benchmark/Exc.dat
      echo "EXTERNAL ELECTRIC FIELD" > $vardir/benchmark/Eeef.dat
      cat $vardir/benchmark/print.dat | grep "EXTERNAL ELECTRIC FIELD:" | tr -s " " | sed -e "s/EXTERNAL ELECTRIC FIELD: /\t\t\t\t\t/g" | sed -e 's/\t\t\t\t\t//g' |  cat -n >> $vardir/benchmark/Eeef.dat
      echo "SELF\-INTERACTION ENERGY" > $vardir/benchmark/Esi.dat
      cat $vardir/benchmark/print.dat | grep "SELF\-INTERACTION ENERGY" | tr -s " " | sed -e "s/SELF\-INTERACTION ENERGY /\t\t\t\t\t/g" | sed -e 's/\t\t\t\t\t//g' |  cat -n >> $vardir/benchmark/Esi.dat
      echo "TOTAL ENERGY + SIC ENERGY" > $vardir/benchmark/Etots.dat
      cat $vardir/benchmark/print.dat | grep "TOTAL ENERGY + SIC ENERGY" | tr -s " " | sed -e "s/TOTAL ENERGY + SIC ENERGY /\t\t\t\t\t/g" | sed -e 's/\t\t\t\t\t//g' |  cat -n >> $vardir/benchmark/Etots.dat


      _chooseE () {
      $DIALOG --title "Energy from print.out" \
              --default-item "Skip" --nocancel \
              --menu "Choose energy:" 20 45 10 \
              "Skip"   "Next" \
              "Etot"   "TOTAL ENERGY" \
              "Enr"    "NUCLEAR REPULSION"   \
              "Elp"    "LOCAL POTENTIAL" \
              "Emfc"   "MEAN-FIELD COULOMB"\
              "Eknp"   "KINETIC+NONLOCAL POTENTIAL" \
              "Exc"    "EXCHANGE-CORRELATION" \
              "Eeef"   "EXTERNAL ELECTRIC FIELD" \
              "Esi"    "SELF-INTERACTION ENERGY" \
              "Etots"  "TOTAL ENERGY + SIC ENERGY"  2> $tempfile3

      retval=$?
      Evar=`cat $tempfile3`
      case $Evar in
        "Etot")
          Evars='TOTAL ENERGY:';;
        "Enr")
          Evars='NUCLEAR REPULSION:';;
        "Elp")
          Evars='LOCAL POTENTIAL:';;
        "Emfc")
          Evars='MEAN-FIELD COULOMB:';;
        "Eknp")
          Evars="KINETIC+NONLOCAL POTENTIAL:";;
        "Exc")
          Evars='EXCHANGE-CORRELATION:';;
        "Eeef")
          Evars='EXTERNAL ELECTRIC FIELD:';;
        "Esi")
          Evars="SELF\-INTERACTION ENERGY";;
        "Etots")
          Evars="TOTAL ENERGY + SIC ENERGY";;
      esac
      #echo $Evars
      #echo ${!var}/benchmark/${Evar}.dat

      if [ ! "$Evar" == "Skip" ]; then
        #Evar="Etot"
        #echo 'TOTAL ENERGY' > ${!var}/benchmark/${Evar}.dat

        #echo $Evars > ${!var}/benchmark/${Evar}.dat
        #echo -e '    IT\tBuiltin Func\t\tLibxc Func' >> ${!var}/benchmark/${Evar}.dat

        #Local potential energy requires double grepping.
        #if [ "$Evar" == "Elp" ]; then
          # cat ${!var}/benchmark/print.dat | grep "${Evars}" | grep -v "NONLOCAL" | tr -s " " | sed -e "s/${Evars} /\t\t\t\t\t/g" | sed -e 's/\t\t\t\t\t//g' | cat -n >> ${!var}/benchmark/${Evar}.dat
        #else
          # cat ${!var}/benchmark/print.dat | grep "${Evars}" | tr -s " " | sed -e "s/${Evars} /\t\t\t\t\t/g" | sed -e 's/\t\t\t\t\t//g' |  cat -n >> ${!var}/benchmark/${Evar}.dat
        #fi

        #echo '*The last line is from summary and not from iteration' >> ${!var}/benchmark/${Evar}.dat
        #nano  ${!var}/benchmark/${!Evar}.dat

        #whiptail conversion
        cat $vardir/benchmark/${Evar}.dat | expand -t 8 > $vardir/benchmark/tmp.dat
        $DIALOG --textbox $vardir/benchmark/tmp.dat 40 50
        #$DIALOG --textbox $vardir/benchmark/${Evar}.dat 40 100

        _chooseE #Go back and select energy
      fi
      }
      _chooseE  #Closing
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
      var="atom$i"
      cd $testdir/${!var}
      if [ "$choice5" == "dX40" ]; then
        var=`ls $dx40dir | sed -n $i,${i}p | cut -d "." -f1`
        #$DIALOG --msgbox "$var" 10 20
        echo "$var"
        cd $testdir/$var
      fi

      echo "#!/bin/bash" > bjob.sh
      echo "#BSUB -J $var" >> bjob.sh
      echo "#BSUB -n $npchoice" >> bjob.sh
      echo "#BSUB -W 24:00" >> bjob.sh
      echo "#BSUB -q medium_priority" >> bjob.sh
      echo "#BSUB -e error.%J.dat" >> bjob.sh
      echo "#BSUB -o output.%J.dat" >> bjob.sh

      echo "mkdir test0" >> bjob.sh
      echo "mkdir test$compareto" >> bjob.sh
      makeDefaultNRLMOL_INPUT
      #Skip if you choose so
      if [ $previousrun == 0 ]; then
        echo "rm RUNS RUNNING GEOCNVRG HAMMIXOLD" >> bjob.sh

        echo "/shared/mpi/bin/mpirun -np $npchoice ./$exe0 > print.out" >> bjob.sh
        #move data and change NRLMOL_INPUT.DAT
        echo "mv SUMMARY test0/" >> bjob.sh
        echo "mv print.out test0/" >> bjob.sh
        echo "mv EVAL* test0/" >> bjob.sh
        echo "cp NRLMOL_INPUT.DAT test0/" >> bjob.sh
        echo "mv FRCOUT test0/" >> bjob.sh
        echo "mv HAMXC*dat test0/" >> bjob.sh
      fi
      echo "rm RUNS RUNNING GEOCNVRG HAMMIXOLD" >> bjob.sh

      if [ $compareto -eq 1 ];then
        echo "sed -i '/MIXPOTV/d' NRLMOL_INPUT.DAT" >> bjob.sh
        echo "sed -i '/&end/d' NRLMOL_INPUT.DAT" >> bjob.sh
        echo "echo \"MIXPOTV       = 'N'\" >> NRLMOL_INPUT.DAT" >> bjob.sh
        echo "echo \"&end\" >> NRLMOL_INPUT.DAT" >> bjob.sh

        #Run NRLMOL with libxc functional
      elif [ $compareto -eq 2 ]; then
        echo "sed -i '/LIBXCV/d' NRLMOL_INPUT.DAT" >> bjob.sh
        echo "sed -i '/&end/d' NRLMOL_INPUT.DAT" >> bjob.sh
        echo "echo \"LIBXCV        = 'Y'\" >> NRLMOL_INPUT.DAT" >> bjob.sh
        echo "echo \"&end\" >> NRLMOL_INPUT.DAT" >> bjob.sh

      #Run NRLMOL with libxc and Hamiltonian mixing
      elif [ $compareto -eq 3 ];then
        echo "sed -i '/MIXPOTV/d' NRLMOL_INPUT.DAT" >> bjob.sh
        echo "sed -i '/LIBXCV/d' NRLMOL_INPUT.DAT" >> bjob.sh
        echo "sed -i '/&end/d' NRLMOL_INPUT.DAT" >> bjob.sh
        echo "echo \"MIXPOTV       = 'N'\" >> NRLMOL_INPUT.DAT" >> bjob.sh
        echo "echo \"LIBXCV        = 'Y'\" >> NRLMOL_INPUT.DAT" >> bjob.sh
        echo "echo \"&end\" >> NRLMOL_INPUT.DAT" >> bjob.sh
      fi

      echo "/shared/mpi/bin/mpirun -np $npchoice ./$exe1 > print.out" >> bjob.sh
      #move data

      echo "mv SUMMARY test$compareto/" >> bjob.sh
      echo "mv print.out test$compareto/" >> bjob.sh
      echo "mv EVAL* test$compareto/" >> bjob.sh
      echo "cp NRLMOL_INPUT.DAT test$compareto/" >> bjob.sh
      echo "mv FRCOUT test$compareto/" >> bjob.sh
      echo "mv HAMXC*dat test$compareto/" >> bjob.sh
      echo "if [ ! -d benchmark ]; then" >> bjob.sh
      echo "  mkdir benchmark" >> bjob.sh
      echo "fi" >> bjob.sh

      bsub < bjob.sh
      echo "Queued with bsub"

    done
  )
  echo "bjob done"
  cd $testdir

  $DIALOG --msgbox "bsub queue finished." 10 40
}


makeDefaultNRLMOL_INPUT () {
#This function creats default NRLMOL_INPUT.DAT file in your current directory
  echo "# Put Y,N or number next to the equal sign to determine execution" > NRLMOL_INPUT.DAT
  echo "# Don't forget the quotation marks for the letters" >> NRLMOL_INPUT.DAT
  echo "# All variables in this list end with v" >> NRLMOL_INPUT.DAT
  echo "" >> NRLMOL_INPUT.DAT
  echo "&input_data" >> NRLMOL_INPUT.DAT
  echo "ATOMSPHV      = 'N'" >> NRLMOL_INPUT.DAT
  echo "BASISV        = 'DEFAULT' ! Specify basis for calculation(basis.txt)" >> NRLMOL_INPUT.DAT
  echo "CALCTYPEV     = 'LBFGS'" >> NRLMOL_INPUT.DAT
  echo "DFTD3V        = 'N' ! Set to Y to do include Grimmes DFT-D3 dispersion" >> NRLMOL_INPUT.DAT
  echo "DIAG1V        = 0   ! diagonalization to use on regular arrays (diagge.f90)" >> NRLMOL_INPUT.DAT
  echo "DIAG2V        = 0   ! diagonalization to use on packed arrays (diag_dspgv.f90)" >> NRLMOL_INPUT.DAT
  echo "DOSOCCUV      = 'N' ! Controls wether to calculate density of states" >> NRLMOL_INPUT.DAT
  echo "EXCITEDV      = 'N' ! Determines if this is an excited state calculation" >> NRLMOL_INPUT.DAT
  echo "FORMFAKV      = 'N' ! this controls if FORMFAK is executed" >> NRLMOL_INPUT.DAT
  echo "FRAGMENTV     = 'N' ! Process CLUSTER in fragments" >> NRLMOL_INPUT.DAT
  echo "JNTDOSV       = 'N' ! This calculates jonit density of states" >> NRLMOL_INPUT.DAT
  echo "MATDIPOLEV    = 'N'" >> NRLMOL_INPUT.DAT
  echo "MAXSCFV       = 100 ! Maximum SCF iterations" >> NRLMOL_INPUT.DAT
  echo "MIXPOTV       = 'Y' ! (Y) Potential Mixing (N) Hamiltonian mixing" >> NRLMOL_INPUT.DAT
  echo "MOLDENV       = 'N' ! Use molden driver" >> NRLMOL_INPUT.DAT
  echo "NBOV          = 'N' ! Use NBO driver" >> NRLMOL_INPUT.DAT
  echo "NONSCFV       = 'N' ! Set to Y to do a non SCF calculation" >> NRLMOL_INPUT.DAT
  echo "NONSCFFORCESV = 'N' ! Set to Y to calculate forces in a non SCF calculation" >> NRLMOL_INPUT.DAT
  echo "RHOGRIDV      = 'N' ! Set to Y to execute RHOGRID" >> NRLMOL_INPUT.DAT
  echo "SCFTOLV       = 1.0D-6 ! SCF tolerance" >> NRLMOL_INPUT.DAT
  echo "SOLVENTV      = 'N' ! Set to Y to include solvent effect (SOLVENTS)" >> NRLMOL_INPUT.DAT
  echo "SYMMETRYV     = 'N' ! Set to Y to detect symmetry" >> NRLMOL_INPUT.DAT
  echo "WFGRIDV       = 'N' ! set to Y to calculate wave functions" >> NRLMOL_INPUT.DAT
  echo "LIBXCV        = 'N' ! set to Y to use libxc functionals" >> NRLMOL_INPUT.DAT
  echo "&end" >> NRLMOL_INPUT.DAT
}


## Idea for queuing
#_schedulerpicker () {
#    dialog --msgbox "Checking your job scheduler."
#    if type bsub >/dev/null 2>&1; then
      #Generate BSUB job script and use BSUB
      #Add job file
#        echo "Using bsub"
#        bsub < job
#    elif type psub >/dev/null 2&1; then
#        echo "Using PBS"
        #generate a job script
#        psub job.sh
#    else
#        echo "Job scheduler not found. Running the code here."
#        ./$exe
#    fi
#}
#_schedulerpicker




########################
#This is the Main code #
########################
#Calling Greeting function
Greeting
#Choose mode: 1 Run and compare, 2 Run only, 3 Compare only
ChooseMode
if [ ! $runmode -eq 3 ]; then
  #Calling WhatToCompare
  WhatToCompare
  #Calling ChooseFunctionals function
  ChooseFunctionals
  #Calling ChooseTestSet function
fi
ChooseTestSet #and generate CLUSTER files  ##Compare only
#Checking mpi is available or not (not completed)
if [ ! $runmode -eq 3 ]; then
  mpiCheck
  #Run executable(s)
  #Check if there's a job scheduler or not
  if type bsub >/dev/null 2>&1; then
    RunBsub
    $DIALOG --msgbox "Jobs quesed with bsub." 10 40
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
