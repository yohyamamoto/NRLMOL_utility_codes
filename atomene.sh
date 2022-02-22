
#assign directory name here
datoms="atoms"

#atom energy
e1=$( awk '{print $2}' ./$datoms/1/fande.out | tail -1 )
e2=$( awk '{print $2}' ./$datoms/2/fande.out | tail -1 )
e3=$( awk '{print $2}' ./$datoms/3/fande.out | tail -1 )
e4=$( awk '{print $2}' ./$datoms/4/fande.out | tail -1 )
e5=$( awk '{print $2}' ./$datoms/5/fande.out | tail -1 )
e6=$( awk '{print $2}' ./$datoms/6/fande.out | tail -1 )
e7=$( awk '{print $2}' ./$datoms/7/fande.out | tail -1 )
e8=$( awk '{print $2}' ./$datoms/8/fande.out | tail -1 )
e9=$( awk '{print $2}' ./$datoms/9/fande.out | tail -1 )
e10=$( awk '{print $2}' ./$datoms/10/fande.out | tail -1 )
e11=$( awk '{print $2}' ./$datoms/11/fande.out | tail -1 )
e12=$( awk '{print $2}' ./$datoms/12/fande.out | tail -1 )
e13=$( awk '{print $2}' ./$datoms/13/fande.out | tail -1 )
e14=$( awk '{print $2}' ./$datoms/14/fande.out | tail -1 )
e15=$( awk '{print $2}' ./$datoms/15/fande.out | tail -1 )
e16=$( awk '{print $2}' ./$datoms/16/fande.out | tail -1 )
e17=$( awk '{print $2}' ./$datoms/17/fande.out | tail -1 )
e18=$( awk '{print $2}' ./$datoms/18/fande.out | tail -1 )

#echo "energy of atoms:"
#echo $e1 $e6 $e8 $e14 $e16

#reference energies
ref1=(-0.5)
ref2=(-2.903724)
ref3=(-7.47806)
ref4=(-14.66736)
ref5=(-24.65391)
ref6=(-37.845)
ref7=(-54.5892)
ref8=(-75.0673)
ref9=(-99.7339)
ref10=(-128.9376)
ref11=(-162.2546)
ref12=(-200.053)
ref13=(-242.346)
ref14=(-289.359)
ref15=(-341.259)
ref16=(-398.11)
ref17=(-460.148)
ref18=(-527.54)

unitconversion=(627.509608)


err1=$( echo "($e1)-($ref1)" | bc -l)
err2=$( echo "($e2)-($ref2)" | bc -l)
err3=$( echo "($e3)-($ref3)" | bc -l)
err4=$( echo "($e4)-($ref4)" | bc -l)
err5=$( echo "($e5)-($ref5)" | bc -l)
err6=$( echo "($e6)-($ref6)" | bc -l)
err7=$( echo "($e7)-($ref7)" | bc -l)
err8=$( echo "($e8)-($ref8)" | bc -l)
err9=$( echo "($e9)-($ref9)" | bc -l)
err10=$( echo "($e10)-($ref10)" | bc -l)
err11=$( echo "($e11)-($ref11)" | bc -l)
err12=$( echo "($e12)-($ref12)" | bc -l)
err13=$( echo "($e13)-($ref13)" | bc -l)
err14=$( echo "($e14)-($ref14)" | bc -l)
err15=$( echo "($e15)-($ref15)" | bc -l)
err16=$( echo "($e16)-($ref16)" | bc -l)
err17=$( echo "($e17)-($ref17)" | bc -l)
err18=$( echo "($e18)-($ref18)" | bc -l)


#test absolute value by dropping minus sign in their strings
MAE=$( echo "(${err1#-}+${err2#-}+${err3#-}+${err4#-}+${err5#-}+${err6#-}+${err7#-}+${err8#-}+${err9#-}+${err10#-}+${err11#-}+${err12#-}+${err13#-}+${err14#-}+${err15#-}+${err16#-}+${err17#-}+${err18#-})/18.0" | bc -l )
MSE=$( echo "(($err1)+($err2)+($err3)+($err4)+($err5)+($err6)+($err7)+($err8)+($err9)+($err10)+($err11)+($err12)+($err13)+($err14)+($err15)+($err16)+($err17)+($err18))/18.0" | bc -l )

echo "MAE" $MAE  
echo "MSE" $MSE 


