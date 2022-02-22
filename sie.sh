#!/bin/bash

#assign directory name here
datoms="atoms"
dmols="SIE"

#molecule energy
e1=$( awk '{print $2}' ./$dmols/1/fande.out | tail -1 )
e2=$( awk '{print $2}' ./$dmols/2/fande.out | tail -1 )
e3=$( awk '{print $2}' ./$dmols/3/fande.out | tail -1 )
e4=$( awk '{print $2}' ./$dmols/4/fande.out | tail -1 )
e5=$( awk '{print $2}' ./$dmols/5/fande.out | tail -1 )
e6=$( awk '{print $2}' ./$dmols/6/fande.out | tail -1 )
e7=$( awk '{print $2}' ./$dmols/7/fande.out | tail -1 )
e8=$( awk '{print $2}' ./$dmols/8/fande.out | tail -1 )
e9=$( awk '{print $2}' ./$dmols/9/fande.out | tail -1 )
e10=$( awk '{print $2}' ./$dmols/10/fande.out | tail -1 )
e11=$( awk '{print $2}' ./$dmols/11/fande.out | tail -1 )
e12=$( awk '{print $2}' ./$dmols/12/fande.out | tail -1 )
e13=$( awk '{print $2}' ./$dmols/13/fande.out | tail -1 )
e14=$( awk '{print $2}' ./$dmols/14/fande.out | tail -1 )
e15=$( awk '{print $2}' ./$dmols/15/fande.out | tail -1 )
e16=$( awk '{print $2}' ./$dmols/16/fande.out | tail -1 )
e17=$( awk '{print $2}' ./$dmols/17/fande.out | tail -1 )
e18=$( awk '{print $2}' ./$dmols/18/fande.out | tail -1 )
e19=$( awk '{print $2}' ./$dmols/19/fande.out | tail -1 )
e20=$( awk '{print $2}' ./$dmols/20/fande.out | tail -1 )
e21=$( awk '{print $2}' ./$dmols/21/fande.out | tail -1 )
e22=$( awk '{print $2}' ./$dmols/22/fande.out | tail -1 )
e23=$( awk '{print $2}' ./$dmols/23/fande.out | tail -1 )
e24=$( awk '{print $2}' ./$dmols/24/fande.out | tail -1 )
e25=$( awk '{print $2}' ./$dmols/25/fande.out | tail -1 )
e26=$( awk '{print $2}' ./$dmols/26/fande.out | tail -1 )
e27=$( awk '{print $2}' ./$dmols/27/fande.out | tail -1 )
e28=$( awk '{print $2}' ./$dmols/28/fande.out | tail -1 )
e29=$( awk '{print $2}' ./$dmols/29/fande.out | tail -1 )
e30=$( awk '{print $2}' ./$dmols/30/fande.out | tail -1 )
e31=$( awk '{print $2}' ./$dmols/31/fande.out | tail -1 )
e32=$( awk '{print $2}' ./$dmols/32/fande.out | tail -1 )
e33=$( awk '{print $2}' ./$dmols/33/fande.out | tail -1 )
e34=$( awk '{print $2}' ./$dmols/34/fande.out | tail -1 )
e35=$( awk '{print $2}' ./$dmols/35/fande.out | tail -1 )
e36=$( awk '{print $2}' ./$dmols/36/fande.out | tail -1 )
eH2O=$( awk '{print $2}' ./$dmols/H2O/fande.out | tail -1 )
eH2Op=$( awk '{print $2}' ./$dmols/H2Op/fande.out | tail -1 )
eHe=$( awk '{print $2}' ./$dmols/He/fande.out | tail -1 )
eHep=$( awk '{print $2}' ./$dmols/Hep/fande.out | tail -1 )
eNH3=$( awk '{print $2}' ./$dmols/NH3/fande.out | tail -1 )
eNH3p=$( awk '{print $2}' ./$dmols/NH3p/fande.out | tail -1 )

#atom energy
eH=$( awk '{print $2}' ./$datoms/1/fande.out | tail -1 )


#reference energies
refa1=(64.4)
refa2=(58.9)
refa3=(48.7)
refa4=(38.3)
refb1=(56.9)
refb2=(46.9)
refb3=(31.3)
refb4=(19.1)
refc1=(35.9)
refc2=(25.9)
refc3=(13.4)
refc4=(4.9)
refd1=(39.7)
refd2=(29.1)
refd3=(16.9)
refd4=(9.3)
refe=(35.28)
reff=(22.57)
refg=(-1.01)
refh=(1.08)
refi=(9.5)
refj=(10.5)
refk=(69.56)
refl=(94.36)

unitconversion=(627.509608)


erra1=$( echo "(($eH)-($e1))*($unitconversion)-($refa1)" | bc -l)
erra2=$( echo "(($eH)-($e2))*($unitconversion)-($refa2)" | bc -l)
erra3=$( echo "(($eH)-($e3))*($unitconversion)-($refa3)" | bc -l)
erra4=$( echo "(($eH)-($e4))*($unitconversion)-($refa4)" | bc -l)

errb1=$( echo "(($eHe)+($eHep)-($e5))*($unitconversion)-($refb1)" | bc -l)
errb2=$( echo "(($eHe)+($eHep)-($e6))*($unitconversion)-($refb2)" | bc -l)
errb3=$( echo "(($eHe)+($eHep)-($e7))*($unitconversion)-($refb3)" | bc -l)
errb4=$( echo "(($eHe)+($eHep)-($e8))*($unitconversion)-($refb4)" | bc -l)

errc1=$( echo "(($eNH3)+($eNH3p)-($e9))*($unitconversion)-($refc1)" | bc -l)
errc2=$( echo "(($eNH3)+($eNH3p)-($e10))*($unitconversion)-($refc2)" | bc -l)
errc3=$( echo "(($eNH3)+($eNH3p)-($e11))*($unitconversion)-($refc3)" | bc -l)
errc4=$( echo "(($eNH3)+($eNH3p)-($e12))*($unitconversion)-($refc4)" | bc -l)

errd1=$( echo "(($eH2O)+($eH2Op)-($e13))*($unitconversion)-($refd1)" | bc -l)
errd2=$( echo "(($eH2O)+($eH2Op)-($e14))*($unitconversion)-($refd2)" | bc -l)
errd3=$( echo "(($eH2O)+($eH2Op)-($e15))*($unitconversion)-($refd3)" | bc -l)
errd4=$( echo "(($eH2O)+($eH2Op)-($e16))*($unitconversion)-($refd4)" | bc -l)

erre=$( echo "(($e19)+($e18)-($e17))*($unitconversion)-($refe)" | bc -l)
errf=$( echo "(($e22)+($e21)-($e20))*($unitconversion)-($reff)" | bc -l)
errg=$( echo "(($e24)-($e23))*($unitconversion)-($refg)" | bc -l)
errh=$( echo "(($e27)+($e26)-($e25))*($unitconversion)-($refh)" | bc -l)
erri=$( echo "(($e30)+($e29)-($e28))*($unitconversion)-($refi)" | bc -l)
errj=$( echo "(($eNH3)+($e32)-($e31))*($unitconversion)-($refj)" | bc -l)
errk=$( echo "(($e35)+($e34)-($e33))*($unitconversion)-($refk)" | bc -l)
errl=$( echo "(($e29)+($e27)-($e36))*($unitconversion)-($refl)" | bc -l)


#test absolute value by dropping minus sign in their strings
MAE4=$( echo "(${erra1#-}+${erra2#-}+${erra3#-}+${erra4#-}+${errb1#-}+${errb2#-}+${errb3#-}+${errb4#-}+${errc1#-}+${errc2#-}+${errc3#-}+${errc4#-}+${errd1#-}+${errd2#-}+${errd3#-}+${errd4#-})/16.0" | bc -l )
MSE4=$( echo "(($erra1)+($erra2)+($erra3)+($erra4)+($errb1)+($errb2)+($errb3)+($errb4)+($errc1)+($errc2)+($errc3)+($errc4)+($errd1)+($errd2)+($errd3)+($errd4))/16.0" | bc -l )

echo "SIE4x4 MAE" $MAE4
echo "SIE4x4 MSE" $MSE4

MAE11=$( echo "(${errb1#-}+${errc1#-}+${errd1#-}+${erre#-}+${errf#-}+${errg#-}+${errh#-}+${erri#-}+${errj#-}+${errk#-}+${errl#-})/11.0" | bc -l     )
MSE11=$( echo "(($errb1)+($errc1)+($errd1)+($erre)+($errf)+($errg)+($errh)+($erri)+($errj)+($errk)+($errl))/11.0" | bc -l )

echo "SIE11 MAE" $MAE11  
echo "SIE11 MSE" $MSE11 

MAE11=$( echo "(${errb1#-}+${errc1#-}+${errd1#-}+${erre#-}+${errf#-})/5.0" | bc -l     )
MSE11=$( echo "(($errb1)+($errc1)+($errd1)+($erre)+($errf))/5.0" | bc -l )

echo "SIE11 cation" $MAE11
echo "SIE11 cation" $MSE11

MAE11=$( echo "(${errg#-}+${errh#-}+${erri#-}+${errj#-}+${errk#-}+${errl#-})/6.0" | bc -l     )
MSE11=$( echo "(($errg)+($errh)+($erri)+($errj)+($errk)+($errl))/6.0" | bc -l )


echo "SIE11 nuetral" $MAE11
echo "SIE11 neutral" $MSE11

