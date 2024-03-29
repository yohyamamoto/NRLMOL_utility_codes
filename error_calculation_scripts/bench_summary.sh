#!/bin/bash

#assign directory name here
datoms="atoms"
dAE="AE6"
dBH="BH6"

unitconversion=(627.509608)

#atom energy
e1=$( awk '{print $6}' ./$datoms/1/SUMMARY | tail -1 )
e2=$( awk '{print $6}' ./$datoms/2/SUMMARY | tail -1 )
e3=$( awk '{print $6}' ./$datoms/3/SUMMARY | tail -1 )
e4=$( awk '{print $6}' ./$datoms/4/SUMMARY | tail -1 )
e5=$( awk '{print $6}' ./$datoms/5/SUMMARY | tail -1 )
e6=$( awk '{print $6}' ./$datoms/6/SUMMARY | tail -1 )
e7=$( awk '{print $6}' ./$datoms/7/SUMMARY | tail -1 )
e8=$( awk '{print $6}' ./$datoms/8/SUMMARY | tail -1 )
e9=$( awk '{print $6}' ./$datoms/9/SUMMARY | tail -1 )
e10=$( awk '{print $6}' ./$datoms/10/SUMMARY | tail -1 )
e11=$( awk '{print $6}' ./$datoms/11/SUMMARY | tail -1 )
e12=$( awk '{print $6}' ./$datoms/12/SUMMARY | tail -1 )
e13=$( awk '{print $6}' ./$datoms/13/SUMMARY | tail -1 )
e14=$( awk '{print $6}' ./$datoms/14/SUMMARY | tail -1 )
e15=$( awk '{print $6}' ./$datoms/15/SUMMARY | tail -1 )
e16=$( awk '{print $6}' ./$datoms/16/SUMMARY | tail -1 )
e17=$( awk '{print $6}' ./$datoms/17/SUMMARY | tail -1 )
e18=$( awk '{print $6}' ./$datoms/18/SUMMARY | tail -1 )


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

echo "Atom total energies"
echo "MAE" $MAE  
echo "MSE" $MSE 

#############################################


#molecule energy
e128=$( awk '{print $6}' ./$dAE/128/SUMMARY | tail -1 )
e129=$( awk '{print $6}' ./$dAE/129/SUMMARY | tail -1 )
e130=$( awk '{print $6}' ./$dAE/130/SUMMARY | tail -1 )
e131=$( awk '{print $6}' ./$dAE/131/SUMMARY | tail -1 )
e132=$( awk '{print $6}' ./$dAE/132/SUMMARY | tail -1 )
e133=$( awk '{print $6}' ./$dAE/133/SUMMARY | tail -1 )

#echo "energy of molecules:"
#echo $e128 $e129 $e130 $e131 $e132 $e133


#reference energies
ref1=(633.99)
ref2=(705.06)
ref3=(1149.37)
ref4=(104.25)
ref5=(324.95)
ref6=(193.06)


err1=$( echo "(2.0*($e6)+2.0*($e8)+2.0*($e1)-($e128))*($unitconversion)-($ref1)" | bc -l)
err2=$( echo "(3.0*($e6)+4.0*($e1)-($e129))*($unitconversion)-($ref2)" | bc -l)
err3=$( echo "(4.0*($e6)+8.0*($e1)-($e130))*($unitconversion)-($ref3)" | bc -l)
err4=$( echo "(2.0*($e16)-($e131))*($unitconversion)-($ref4)" | bc -l)
err5=$( echo "($e14+4.0*($e1)-($e132))*($unitconversion)-($ref5)" | bc -l)
err6=$( echo "($e14+($e8)-($e133))*($unitconversion)-($ref6)" | bc -l)

#test absolute value by dropping minus sign in their strings
MAE=$( echo "(${err1#-}+${err2#-}+${err3#-}+${err4#-}+${err5#-}+${err6#-})/6.0" | bc -l )
MSE=$( echo "(($err1)+($err2)+($err3)+($err4)+($err5)+($err6))/6.0" | bc -l )

echo "AE6 atomization energies"
echo "MAE" $MAE  
echo "MSE" $MSE 

######################################


#molecule energy
eCH3=$( awk '{print $6}' ./$dBH/CH3/SUMMARY | tail -1 )
eCH4=$( awk '{print $6}' ./$dBH/CH4/SUMMARY | tail -1 )
eH2=$( awk '{print $6}' ./$dBH/H2/SUMMARY | tail -1 )
eH2O=$( awk '{print $6}' ./$dBH/H2O/SUMMARY | tail -1 )
eH2S=$( awk '{print $6}' ./$dBH/H2S/SUMMARY | tail -1 )
eHS=$( awk '{print $6}' ./$dBH/HS/SUMMARY | tail -1 )
eOH=$( awk '{print $6}' ./$dBH/OH/SUMMARY | tail -1 )
esaddle1=$( awk '{print $6}' ./$dBH/saddle1/SUMMARY | tail -1 )
esaddle2=$( awk '{print $6}' ./$dBH/saddle2/SUMMARY | tail -1 )
esaddle3=$( awk '{print $6}' ./$dBH/saddle3/SUMMARY | tail -1 )


#reference energies
ref1=(6.7)
ref2=(19.6)
ref3=(10.7)
ref4=(13.1)
ref5=(3.6)
ref6=(17.3)


err1=$( echo "(($esaddle1)-($eOH)-($eCH4))*($unitconversion)-($ref1)" | bc -l)
err2=$( echo "(($esaddle1)-($eCH3)-($eH2O))*($unitconversion)-($ref2)" | bc -l)
err3=$( echo "(($esaddle2)-($e1)-($eOH))*($unitconversion)-($ref3)" | bc -l)
err4=$( echo "(($esaddle2)-($eH2)-($e8))*($unitconversion)-($ref4)" | bc -l)
err5=$( echo "(($esaddle3)-($e1)-($eH2S))*($unitconversion)-($ref5)" | bc -l)
err6=$( echo "(($esaddle3)-($eH2)-($eHS))*($unitconversion)-($ref6)" | bc -l)

#test absolute value by dropping minus sign in their strings
MAE=$( echo "(${err1#-}+${err2#-}+${err3#-}+${err4#-}+${err5#-}+${err6#-})/6.0" | bc -l )
MSE=$( echo "(($err1)+($err2)+($err3)+($err4)+($err5)+($err6))/6.0" | bc -l )

echo "BH6 barrier heights"
echo "MAE" $MAE  
echo "MSE" $MSE 


