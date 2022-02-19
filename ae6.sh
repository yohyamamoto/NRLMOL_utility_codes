
#assign directory name here
datoms="atoms"
dmols="AE6"

#molecule energy
e128=$( awk '{print $2}' ./$dmols/128/fande.out )
e129=$( awk '{print $2}' ./$dmols/129/fande.out )
e130=$( awk '{print $2}' ./$dmols/130/fande.out )
e131=$( awk '{print $2}' ./$dmols/131/fande.out )
e132=$( awk '{print $2}' ./$dmols/132/fande.out )
e133=$( awk '{print $2}' ./$dmols/133/fande.out )

#echo "energy of molecules:"
#echo $e128 $e129 $e130 $e131 $e132 $e133

#atom energy
e1=$(  awk '{print $2}' ./$datoms/1/fande.out )
e6=$(  awk '{print $2}' ./$datoms/6/fande.out )
e8=$(  awk '{print $2}' ./$datoms/8/fande.out )
e14=$( awk '{print $2}' ./$datoms/14/fande.out )
e16=$( awk '{print $2}' ./$datoms/16/fande.out )

#echo "energy of atoms:"
#echo $e1 $e6 $e8 $e14 $e16

#reference energies
ref1=(633.99)
ref2=(705.06)
ref3=(1149.37)
ref4=(104.25)
ref5=(324.95)
ref6=(193.06)

unitconversion=(627.509608)


err1=$( echo "(2.0*($e6)+2.0*($e8)+2.0*($e1)-($e128))*($unitconversion)-($ref1)" | bc -l)
err2=$( echo "(3.0*($e6)+4.0*($e1)-($e129))*($unitconversion)-($ref2)" | bc -l)
err3=$( echo "(4.0*($e6)+8.0*($e1)-($e130))*($unitconversion)-($ref3)" | bc -l)
err4=$( echo "(2.0*($e16)-($e131))*($unitconversion)-($ref4)" | bc -l)
err5=$( echo "($e14+4.0*($e1)-($e132))*($unitconversion)-($ref5)" | bc -l)
err6=$( echo "($e14+($e8)-($e133))*($unitconversion)-($ref6)" | bc -l)

#test absolute value by dropping minus sign in their strings
MAE=$( echo "(${err1#-}+${err2#-}+${err3#-}+${err4#-}+${err5#-}+${err6#-})/6.0" | bc -l )
MSE=$( echo "(($err1)+($err2)+($err3)+($err4)+($err5)+($err6))/6.0" | bc -l )

echo "MAE" $MAE  
echo "MSE" $MSE 


