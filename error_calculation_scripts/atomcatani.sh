#!/bin/bash


#assign directory name here
datoms="atoms"
dcats="cats"
danis="anis"

echo "Note: cation 24 and 29 are in Cation_Extra directory."

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
e19=$( awk '{print $2}' ./$datoms/19/fande.out | tail -1 )
e20=$( awk '{print $2}' ./$datoms/20/fande.out | tail -1 )
e21=$( awk '{print $2}' ./$datoms/21/fande.out | tail -1 )
e22=$( awk '{print $2}' ./$datoms/22/fande.out | tail -1 )
e23=$( awk '{print $2}' ./$datoms/23/fande.out | tail -1 )
e24=$( awk '{print $2}' ./$datoms/24/fande.out | tail -1 )
e25=$( awk '{print $2}' ./$datoms/25/fande.out | tail -1 )
e26=$( awk '{print $2}' ./$datoms/26/fande.out | tail -1 )
e27=$( awk '{print $2}' ./$datoms/27/fande.out | tail -1 )
e28=$( awk '{print $2}' ./$datoms/28/fande.out | tail -1 )
e29=$( awk '{print $2}' ./$datoms/29/fande.out | tail -1 )
e30=$( awk '{print $2}' ./$datoms/30/fande.out | tail -1 )
e31=$( awk '{print $2}' ./$datoms/31/fande.out | tail -1 )
e32=$( awk '{print $2}' ./$datoms/32/fande.out | tail -1 )
e33=$( awk '{print $2}' ./$datoms/33/fande.out | tail -1 )
e34=$( awk '{print $2}' ./$datoms/34/fande.out | tail -1 )
e35=$( awk '{print $2}' ./$datoms/35/fande.out | tail -1 )
e36=$( awk '{print $2}' ./$datoms/36/fande.out | tail -1 )


c2=$( awk '{print $2}' ./$dcats/2/fande.out | tail -1 )
c3=$( awk '{print $2}' ./$dcats/3/fande.out | tail -1 )
c4=$( awk '{print $2}' ./$dcats/4/fande.out | tail -1 )
c5=$( awk '{print $2}' ./$dcats/5/fande.out | tail -1 )
c6=$( awk '{print $2}' ./$dcats/6/fande.out | tail -1 )
c7=$( awk '{print $2}' ./$dcats/7/fande.out | tail -1 )
c8=$( awk '{print $2}' ./$dcats/8/fande.out | tail -1 )
c9=$( awk '{print $2}' ./$dcats/9/fande.out | tail -1 )
c10=$( awk '{print $2}' ./$dcats/10/fande.out | tail -1 )
c11=$( awk '{print $2}' ./$dcats/11/fande.out | tail -1 )
c12=$( awk '{print $2}' ./$dcats/12/fande.out | tail -1 )
c13=$( awk '{print $2}' ./$dcats/13/fande.out | tail -1 )
c14=$( awk '{print $2}' ./$dcats/14/fande.out | tail -1 )
c15=$( awk '{print $2}' ./$dcats/15/fande.out | tail -1 )
c16=$( awk '{print $2}' ./$dcats/16/fande.out | tail -1 )
c17=$( awk '{print $2}' ./$dcats/17/fande.out | tail -1 )
c18=$( awk '{print $2}' ./$dcats/18/fande.out | tail -1 )
c19=$( awk '{print $2}' ./$dcats/19/fande.out | tail -1 )
c20=$( awk '{print $2}' ./$dcats/20/fande.out | tail -1 )
c21=$( awk '{print $2}' ./$dcats/21/fande.out | tail -1 )
c22=$( awk '{print $2}' ./$dcats/22/fande.out | tail -1 )
c23=$( awk '{print $2}' ./$dcats/23/fande.out | tail -1 )
c24=$( awk '{print $2}' ./$dcats/24/fande.out | tail -1 )
c25=$( awk '{print $2}' ./$dcats/25/fande.out | tail -1 )
c26=$( awk '{print $2}' ./$dcats/26/fande.out | tail -1 )
c27=$( awk '{print $2}' ./$dcats/27/fande.out | tail -1 )
c28=$( awk '{print $2}' ./$dcats/28/fande.out | tail -1 )
c29=$( awk '{print $2}' ./$dcats/29/fande.out | tail -1 )
c30=$( awk '{print $2}' ./$dcats/30/fande.out | tail -1 )
c31=$( awk '{print $2}' ./$dcats/31/fande.out | tail -1 )
c32=$( awk '{print $2}' ./$dcats/32/fande.out | tail -1 )
c33=$( awk '{print $2}' ./$dcats/33/fande.out | tail -1 )
c34=$( awk '{print $2}' ./$dcats/34/fande.out | tail -1 )
c35=$( awk '{print $2}' ./$dcats/35/fande.out | tail -1 )
c36=$( awk '{print $2}' ./$dcats/36/fande.out | tail -1 )


a1=$( awk '{print $2}' ./$danis/1/fande.out | tail -1 )
a3=$( awk '{print $2}' ./$danis/3/fande.out | tail -1 )
a5=$( awk '{print $2}' ./$danis/5/fande.out | tail -1 )
a6=$( awk '{print $2}' ./$danis/6/fande.out | tail -1 )
a8=$( awk '{print $2}' ./$danis/8/fande.out | tail -1 )
a9=$( awk '{print $2}' ./$danis/9/fande.out | tail -1 )
a11=$( awk '{print $2}' ./$danis/11/fande.out | tail -1 )
a13=$( awk '{print $2}' ./$danis/13/fande.out | tail -1 )
a14=$( awk '{print $2}' ./$danis/14/fande.out | tail -1 )
a15=$( awk '{print $2}' ./$danis/15/fande.out | tail -1 )
a16=$( awk '{print $2}' ./$danis/16/fande.out | tail -1 )
a17=$( awk '{print $2}' ./$danis/17/fande.out | tail -1 )
a19=$( awk '{print $2}' ./$danis/19/fande.out | tail -1 )
a22=$( awk '{print $2}' ./$danis/22/fande.out | tail -1 )
a29=$( awk '{print $2}' ./$danis/29/fande.out | tail -1 )
a31=$( awk '{print $2}' ./$danis/31/fande.out | tail -1 )
a32=$( awk '{print $2}' ./$danis/32/fande.out | tail -1 )
a33=$( awk '{print $2}' ./$danis/33/fande.out | tail -1 )
a34=$( awk '{print $2}' ./$danis/34/fande.out | tail -1 )
a35=$( awk '{print $2}' ./$danis/35/fande.out | tail -1 )



#echo "energy of atoms:"

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

#cation refs
cref1=(13.598)
cref2=(24.587)
cref3=(5.392)
cref4=(9.323)
cref5=(8.298)
cref6=(11.26)
cref7=(14.534)
cref8=(13.618)
cref9=(17.423)
cref10=(21.565)
cref11=(5.139)
cref12=(7.646)
cref13=(5.986)
cref14=(8.152)
cref15=(10.487)
cref16=(10.36)
cref17=(12.968)
cref18=(15.76)
cref19=(4.341)
cref20=(6.113)
cref21=(6.561)
cref22=(6.828)
cref23=(6.746)
cref24=(6.767)
cref25=(7.434)
cref26=(7.902)
cref27=(7.881)
cref28=(7.64)
cref29=(7.726)
cref30=(9.394)
cref31=(5.999)
cref32=(7.899)
cref33=(9.789)
cref34=(9.752)
cref35=(11.814)
cref36=(14)

#anions refs
aref1=(0.75419)
aref3=(0.61759)
aref5=(0.279743)
aref6=(1.262114)
aref8=(1.46198)
aref9=(3.40129)
aref11=(0.547951)
aref13=(0.433816)
aref14=(1.389518)
aref15=(0.74651)
aref16=(2.077103)
aref17=(3.612724)
aref19=(0.50147)
aref22=(0.087)
aref29=(1.23579)
aref31=(0.43)
aref32=(1.232712)
aref33=(0.814)
aref34=(2.02067)
aref35=(3.363583)


#unitconversion=(627.509608)
unitconversion=(27.2114)

#err1=$( echo "(($c1)-($e1))*($unitconversion)-($cref1)" | bc -l)
err2=$( echo "(($c2)-($e2))*($unitconversion)-($cref2)" | bc -l)
err3=$( echo "(($c3)-($e3))*($unitconversion)-($cref3)" | bc -l)
err4=$( echo "(($c4)-($e4))*($unitconversion)-($cref4)" | bc -l)
err5=$( echo "(($c5)-($e5))*($unitconversion)-($cref5)" | bc -l)
err6=$( echo "(($c6)-($e6))*($unitconversion)-($cref6)" | bc -l)
err7=$( echo "(($c7)-($e7))*($unitconversion)-($cref7)" | bc -l)
err8=$( echo "(($c8)-($e8))*($unitconversion)-($cref8)" | bc -l)
err9=$( echo "(($c9)-($e9))*($unitconversion)-($cref9)" | bc -l)
err10=$( echo "(($c10)-($e10))*($unitconversion)-($cref10)" | bc -l)
err11=$( echo "(($c11)-($e11))*($unitconversion)-($cref11)" | bc -l)
err12=$( echo "(($c12)-($e12))*($unitconversion)-($cref12)" | bc -l)
err13=$( echo "(($c13)-($e13))*($unitconversion)-($cref13)" | bc -l)
err14=$( echo "(($c14)-($e14))*($unitconversion)-($cref14)" | bc -l)
err15=$( echo "(($c15)-($e15))*($unitconversion)-($cref15)" | bc -l)
err16=$( echo "(($c16)-($e16))*($unitconversion)-($cref16)" | bc -l)
err17=$( echo "(($c17)-($e17))*($unitconversion)-($cref17)" | bc -l)
err18=$( echo "(($c18)-($e18))*($unitconversion)-($cref18)" | bc -l)
err19=$( echo "(($c19)-($e19))*($unitconversion)-($cref19)" | bc -l)
err20=$( echo "(($c20)-($e20))*($unitconversion)-($cref20)" | bc -l)
err21=$( echo "(($c21)-($e21))*($unitconversion)-($cref21)" | bc -l)
err22=$( echo "(($c22)-($e22))*($unitconversion)-($cref22)" | bc -l)
err23=$( echo "(($c23)-($e23))*($unitconversion)-($cref23)" | bc -l)
err24=$( echo "(($c24)-($e24))*($unitconversion)-($cref24)" | bc -l)
err25=$( echo "(($c25)-($e25))*($unitconversion)-($cref25)" | bc -l)
err26=$( echo "(($c26)-($e26))*($unitconversion)-($cref26)" | bc -l)
err27=$( echo "(($c27)-($e27))*($unitconversion)-($cref27)" | bc -l)
err28=$( echo "(($c28)-($e28))*($unitconversion)-($cref28)" | bc -l)
err29=$( echo "(($c29)-($e29))*($unitconversion)-($cref29)" | bc -l)
err30=$( echo "(($c30)-($e30))*($unitconversion)-($cref30)" | bc -l)
err31=$( echo "(($c31)-($e31))*($unitconversion)-($cref31)" | bc -l)
err32=$( echo "(($c32)-($e32))*($unitconversion)-($cref32)" | bc -l)
err33=$( echo "(($c33)-($e33))*($unitconversion)-($cref33)" | bc -l)
err34=$( echo "(($c34)-($e34))*($unitconversion)-($cref34)" | bc -l)
err35=$( echo "(($c35)-($e35))*($unitconversion)-($cref35)" | bc -l)
err36=$( echo "(($c36)-($e36))*($unitconversion)-($cref36)" | bc -l)


MAE17=$( echo "(${err2#-}+${err3#-}+${err4#-}+${err5#-}+${err6#-}+${err7#-}+${err8#-}+${err9#-}+${err10#-}+${err11#-}+${err12#-}+${err13#-}+${err14#-}+${err15#-}+${err16#-}+${err17#-}+${err18#-})/17.0" | bc -l )
MSE17=$( echo "(($err2)+($err3)+($err4)+($err5)+($err6)+($err7)+($err8)+($err9)+($err10)+($err11)+($err12)+($err13)+($err14)+($err15)+($err16)+($err17)+($err18))/17.0" | bc -l )



#test absolute value by dropping minus sign in their strings
MAE=$( echo "(${err2#-}+${err3#-}+${err4#-}+${err5#-}+${err6#-}+${err7#-}+${err8#-}+${err9#-}+${err10#-}+${err11#-}+${err12#-}+${err13#-}+${err14#-}+${err15#-}+${err16#-}+${err17#-}+${err18#-}+${err19#-}+${err20#-}+${err21#-}+${err22#-}+${err23#-}+${err24#-}+${err25#-}+${err26#-}+${err27#-}+${err28#-}+${err29#-}+${err30#-}+${err31#-}+${err32#-}+${err33#-}+${err34#-}+${err35#-}+${err36#-})/35.0" | bc -l )
MSE=$( echo "(($err2)+($err3)+($err4)+($err5)+($err6)+($err7)+($err8)+($err9)+($err10)+($err11)+($err12)+($err13)+($err14)+($err15)+($err16)+($err17)+($err18)+($err19)+($err20)+($err21)+($err22)+($err23)+($err24)+($err25)+($err26)+($err27)+($err28)+($err29)+($err30)+($err31)+($err32)+($err33)+($err34)+($err35)+($err36))/35.0" | bc -l )


echo "Cations"
echo "MAE17" $MAE17
echo "MSE17" $MSE17
echo "MAE" $MAE  
echo "MSE" $MSE 

#echo $err1,$err2,$err3,$err4,$err5,$err6,$err7,$err8,$err9,$err10
#echo $err11,$err12,$err13,$err14,$err15,$err16,$err17,$err18,$err19,$err20
#echo $err21,$err22,$err23,$err24,$err25,$err26,$err27,$err28,$err29,$err30
#echo $err31,$err32,$err33,$err34,$err35,$err36


err1=$( echo "(($e1)-($a1))*($unitconversion)-($aref1)" | bc -l)
#err2=$( echo "(($e2)-($a2))*($unitconversion)-($aref2)" | bc -l)
err3=$( echo "(($e3)-($a3))*($unitconversion)-($aref3)" | bc -l)
#err4=$( echo "(($e4)-($a4))*($unitconversion)-($aref4)" | bc -l)
err5=$( echo "(($e5)-($a5))*($unitconversion)-($aref5)" | bc -l)
err6=$( echo "(($e6)-($a6))*($unitconversion)-($aref6)" | bc -l)
#err7=$( echo "(($e7)-($a7))*($unitconversion)-($aref7)" | bc -l)
err8=$( echo "(($e8)-($a8))*($unitconversion)-($aref8)" | bc -l)
err9=$( echo "(($e9)-($a9))*($unitconversion)-($aref9)" | bc -l)
#err10=$( echo "(($e10)-($a10))*($unitconversion)-($aref10)" | bc -l)
err11=$( echo "(($e11)-($a11))*($unitconversion)-($aref11)" | bc -l)
#err12=$( echo "(($e12)-($a12))*($unitconversion)-($aref12)" | bc -l)
err13=$( echo "(($e13)-($a13))*($unitconversion)-($aref13)" | bc -l)
err14=$( echo "(($e14)-($a14))*($unitconversion)-($aref14)" | bc -l)
err15=$( echo "(($e15)-($a15))*($unitconversion)-($aref15)" | bc -l)
err16=$( echo "(($e16)-($a16))*($unitconversion)-($aref16)" | bc -l)
err17=$( echo "(($e17)-($a17))*($unitconversion)-($aref17)" | bc -l)
#err18=$( echo "(($e18)-($a18))*($unitconversion)-($aref18)" | bc -l)
err19=$( echo "(($e19)-($a19))*($unitconversion)-($aref19)" | bc -l)
#err20=$( echo "(($e20)-($a20))*($unitconversion)-($aref20)" | bc -l)
#err21=$( echo "(($e21)-($a21))*($unitconversion)-($aref21)" | bc -l)
err22=$( echo "(($e22)-($a22))*($unitconversion)-($aref22)" | bc -l)
#err23=$( echo "(($e23)-($a23))*($unitconversion)-($aref23)" | bc -l)
#err24=$( echo "(($e24)-($a24))*($unitconversion)-($aref24)" | bc -l)
#err25=$( echo "(($e25)-($a25))*($unitconversion)-($aref25)" | bc -l)
#err26=$( echo "(($e26)-($a26))*($unitconversion)-($aref26)" | bc -l)
#err27=$( echo "(($e27)-($a27))*($unitconversion)-($aref27)" | bc -l)
#err28=$( echo "(($e28)-($a28))*($unitconversion)-($aref28)" | bc -l)
err29=$( echo "(($e29)-($a29))*($unitconversion)-($aref29)" | bc -l)
#err30=$( echo "(($e30)-($a30))*($unitconversion)-($aref30)" | bc -l)
err31=$( echo "(($e31)-($a31))*($unitconversion)-($aref31)" | bc -l)
err32=$( echo "(($e32)-($a32))*($unitconversion)-($aref32)" | bc -l)
err33=$( echo "(($e33)-($a33))*($unitconversion)-($aref33)" | bc -l)
err34=$( echo "(($e34)-($a34))*($unitconversion)-($aref34)" | bc -l)
err35=$( echo "(($e35)-($a35))*($unitconversion)-($aref35)" | bc -l)
#err36=$( echo "(($e36)-($a36))*($unitconversion)-($aref36)" | bc -l)


#test absolute value by dropping minus sign in their strings
MAE12=$( echo "(${err1#-}+${err3#-}+${err5#-}+${err6#-}+${err8#-}+${err9#-}+${err11#-}+${err13#-}+${err14#-}+${err15#-}+${err16#-}+${err17#-})/12.0" | bc -l )
MSE12=$( echo "(($err1)+($err3)+($err5)+($err6)+($err8)+($err9)+($err11)+($err13)+($err14)+($err15)+($err16)+($err17))/12.0" | bc -l )

#test absolute value by dropping minus sign in their strings
MAE=$( echo "(${err1#-}+${err3#-}+${err5#-}+${err6#-}+${err8#-}+${err9#-}+${err11#-}+${err13#-}+${err14#-}+${err15#-}+${err16#-}+${err17#-}+${err19#-}+${err22#-}+${err29#-}+${err31#-}+${err32#-}+${err33#-}+${err34#-}+${err35#-})/20.0" | bc -l )
MSE=$( echo "(($err1)+($err3)+($err5)+($err6)+($err8)+($err9)+($err11)+($err13)+($err14)+($err15)+($err16)+($err17)+($err19)+($err22)+($err29)+($err31)+($err32)+($err33)+($err34)+($err35))/20.0" | bc -l )

echo "Anions"
echo "MAE12" $MAE12
echo "MSE12" $MSE12
echo "MAE" $MAE  
echo "MSE" $MSE