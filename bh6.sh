
#assign directory name here
datoms="atoms"
dmols="BH6"

#molecule energy
eCH3=$( awk '{print $2}' ./$dmols/CH3/fande.out )
eCH4=$( awk '{print $2}' ./$dmols/CH4/fande.out )
eH2=$( awk '{print $2}' ./$dmols/H2/fande.out )
eH2O=$( awk '{print $2}' ./$dmols/H2O/fande.out )
eH2S=$( awk '{print $2}' ./$dmols/H2S/fande.out )
eHS=$( awk '{print $2}' ./$dmols/HS/fande.out )
eOH=$( awk '{print $2}' ./$dmols/OH/fande.out )
esaddle1=$( awk '{print $2}' ./$dmols/saddle1/fande.out )
esaddle2=$( awk '{print $2}' ./$dmols/saddle2/fande.out )
esaddle3=$( awk '{print $2}' ./$dmols/saddle3/fande.out )


#atom energy
eH=$(  awk '{print $2}' ./$datoms/1/fande.out )
eO=$(  awk '{print $2}' ./$datoms/8/fande.out )


#reference energies
ref1=(6.7)
ref2=(19.6)
ref3=(10.7)
ref4=(13.1)
ref5=(3.6)
ref6=(17.3)

unitconversion=(627.509608)


err1=$( echo "(($esaddle1)-($eOH)-($eCH4))*($unitconversion)-($ref1)" | bc -l)
err2=$( echo "(($esaddle1)-($eCH3)-($eH2O))*($unitconversion)-($ref2)" | bc -l)
err3=$( echo "(($esaddle2)-($eH)-($eOH))*($unitconversion)-($ref3)" | bc -l)
err4=$( echo "(($esaddle2)-($eH2)-($eO))*($unitconversion)-($ref4)" | bc -l)
err5=$( echo "(($esaddle3)-($eH)-($eH2S))*($unitconversion)-($ref5)" | bc -l)
err6=$( echo "(($esaddle3)-($eH2)-($eHS))*($unitconversion)-($ref6)" | bc -l)

#test absolute value by dropping minus sign in their strings
MAE=$( echo "(${err1#-}+${err2#-}+${err3#-}+${err4#-}+${err5#-}+${err6#-})/6.0" | bc -l )
MSE=$( echo "(($err1)+($err2)+($err3)+($err4)+($err5)+($err6))/6.0" | bc -l )

echo "MAE" $MAE  
echo "MSE" $MSE 


