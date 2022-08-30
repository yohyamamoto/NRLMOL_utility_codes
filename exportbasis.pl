#!/usr/bin/perl

### This perl script converts ISYMGEN to gaussian basis set format.
### It works per atom fashion i.e. ISYMGEN of a single atom.
### Either Scientific notation or dicimal notation required for the input file.

$adjustcoef=0;  #On: 1, Off: 0. This option will adjust contraction coef by 
                #s: alpha**(-0.75), p: alpha**(-1.25), d: alpha**(-1.75) 
$LineNum=1;
$bareNum=1;
$sNum=0;
$pNum=0;
$dNum=0;
$cnt=1;
$nonzero=0;
print "****\n";
while (defined($line = <>)) {
  #next if ($line =~ /^\s*($|#)/);
  chomp($line);
  #join ' ', split ' ', $text;
  $line = join ' ', split ' ', $line;
  my ($x1, $x2, $x3) = split / /, $line;
  if( $LineNum == 5 ) { 
    $zname = namec($x1);
    print "$zname   0\n"
  } 
  elsif( $LineNum == 7) { 
    $nbare = $x1;
    #print "nbare is $nbare\n";
  }
  elsif( $LineNum == 8) {
    $nstype = $x1;
    $nptype = $x2;
    $ndtype = $x3;
    #print "s/p/d type $nstype $nptype $ndtype\n";
  }
  elsif( $LineNum == 9) {
    $nextras = $x1;
    $nextrap = $x2;
    $nextrad = $x3;
    #print "s/p/d extra $nextras $nextrap $nextrad\n";
  }
  elsif( $LineNum >= 10 ) { # && $x1 != "") {
    #print "condition $x1 ($sNum <= $nstype) \n";
    #if( ($x1 != "") && ($x2 != "") && ($x3 != "") ) {
    #if( $line != "") {
      #if( $x1 == "" && $x2 == "" && $x3 =="") {
      #print "$LineNum $line \n";
      if( $line eq "" ) {
        #print "must be empty line $line $sNum $pNum\n";
      }
      elsif( $bareNum <= $nbare ) {
        $alpha[$bareNum]   = sprintf("%18.8f", $x1);
        $alpha[$bareNum+1] = sprintf("%18.8f", $x2);
        $alpha[$bareNum+2] = sprintf("%18.8f", $x3);
        $bareNum=$bareNum+3;
      }
      elsif( $sNum < $nstype+$nextras) {
        #print "$x1 $x2 $x3\n";
        if($adjustcoef == 1) {
          $coefs[$cnt]   = sprintf("%15.8f", $x1*($alpha[$cnt]**(-0.75)));
          $coefs[$cnt+1] = sprintf("%15.8f", $x2*($alpha[$cnt+1]**(-0.75)));
          $coefs[$cnt+2] = sprintf("%15.8f", $x3*($alpha[$cnt+2]**(-0.75)));
        }
        else {
          $coefs[$cnt]   = sprintf("%15.8f", $x1);
          $coefs[$cnt+1] = sprintf("%15.8f", $x2);
          $coefs[$cnt+2] = sprintf("%15.8f", $x3);
        }

        #print "coefs stype: $x1, $coefs[$cnt], $cnt  \n";
        if($x1 ne "" && $coefs[$cnt]   != 0.0 ) {$nonzero++;}
        if($x2 ne "" && $coefs[$cnt+1] != 0.0 ) {$nonzero++;}
        if($x3 ne "" && $coefs[$cnt+2] != 0.0 ) {$nonzero++;}
        $cnt=$cnt+3;
        if($cnt > $nbare ) {
          $sNum=$sNum+1;
          $cnt=1;
          if($sNum <= $nstype) {
            print "S   $nonzero  1.00\n";
          }
          elsif($sNum > $nstype) {
            print "S   $nonzero  1.00   Extrabasis\n";
          }
          my @loop2 = (1..$nbare);
          for my $i (@loop2){
            if( $coefs[$i] != 0.0 ) {
              if( $nonzero == 1 && $adjustcoef == 1) {
                print "$alpha[$i]           1.00000000\n";    
              }
              else {
                print "$alpha[$i]      $coefs[$i]\n";
              }
            }
          }
          $nonzero=0;
        }
      }
      elsif( $pNum < $nptype+$nextrap) {
        if( $adjustcoef == 1 ) {
          $coefp[$cnt]   = sprintf("%15.8f", $x1*($alpha[$cnt]**(-1.25)));
          $coefp[$cnt+1] = sprintf("%15.8f", $x2*($alpha[$cnt+1]**(-1.25)));
          $coefp[$cnt+2] = sprintf("%15.8f", $x3*($alpha[$cnt+2]**(-1.25)));
        }
        else {
          $coefp[$cnt]   = sprintf("%15.8f", $x1);
          $coefp[$cnt+1] = sprintf("%15.8f", $x2);
          $coefp[$cnt+2] = sprintf("%15.8f", $x3);
        }
        if($x1 ne "" && $coefp[$cnt]   != 0.0 ) {$nonzero++;}
        if($x2 ne "" && $coefp[$cnt+1] != 0.0 ) {$nonzero++;}
        if($x3 ne "" && $coefp[$cnt+2] != 0.0 ) {$nonzero++;}
        $cnt=$cnt+3;
        if($cnt > $nbare ) {
          $pNum=$pNum+1;
          $cnt=1;
          if($pNum <= $nptype) {
            print "P   $nonzero  1.00\n";
          }
          elsif($pNum > $nptype)  {
            print "P   $nonzero  1.00   Extrabasis\n";
          }
          my @loop2 = (1..$nbare);
          for my $i (@loop2){
            if( $coefp[$i] != 0.0 ) {
              if( $nonzero == 1 && $adjustcoef == 1) {
                print "$alpha[$i]           1.00000000\n";    
              }
              else {
                print "$alpha[$i]      $coefp[$i]\n";
              }
            }
          }
          $nonzero=0;
        }
 
      }
      elsif( $dNum < $ndtype+$nextrad) {
        if( $adjustcoef == 1) {
          $coefd[$cnt]   = sprintf("%15.8f", $x1*($alpha[$cnt]**(-1.75)));
          $coefd[$cnt+1] = sprintf("%15.8f", $x2*($alpha[$cnt+1]**(-1.75)));
          $coefd[$cnt+2] = sprintf("%15.8f", $x3*($alpha[$cnt+2]**(-1.75)));
        }
        else {
          $coefd[$cnt]   = sprintf("%15.8f", $x1);
          $coefd[$cnt+1] = sprintf("%15.8f", $x2);
          $coefd[$cnt+2] = sprintf("%15.8f", $x3);
        }
        if($x1 ne "" && $coefd[$cnt]   != 0.0 ) {$nonzero++;}
        if($x2 ne "" && $coefd[$cnt+1] != 0.0 ) {$nonzero++;}
        if($x3 ne "" && $coefd[$cnt+2] != 0.0 ) {$nonzero++;}
        $cnt=$cnt+3;
        if($cnt > $nbare ) {
          $dNum=$dNum+1;
          $cnt=1;
          if($dNum <= $ndtype) {
            print "D   $nonzero  1.00\n";
          }
          elsif($dNum > $ndtype)  {
            print "D   $nonzero  1.00   Extrabasis\n";
          }
          my @loop2 = (1..$nbare);
          for my $i (@loop2){
            if( $coefd[$i] != 0.0 ) {
              if( $nonzero == 1 && $adjustcoef == 1 ) {
                print "$alpha[$i]           1.00000000\n";    
              }
              else {
                print "$alpha[$i]      $coefd[$i]\n";
              }
            }
          }
          $nonzero=0;
        }
      }
    #}

    #if( $bareNum >= $nbare ) {print "Alpha is done $bareNum / $nbare\n";}    #All alphas are read.    
    #if( $sNum > $nstype ) {
      #print "s type is done $sNum of $nstype\n";
    #  $cnt=0;
    #}
    #if( $pNum > $nptype && $nptype ne 0) {
      #print "p type is done $pNum of $nptype\n";
    #  $cnt=0;
    #}
    #if( $dNum > $ndtype && $ndtype ne 0) {
      #print "d type is done $dNum of $ndtype\n";
    #  $cnt=0;
    #}
  }

  #Debugging statement
  #print "$LineNum, $bareNum, $cnt, $sNum $nstype\n"; 
  
  $LineNum=$LineNum+1;
}


#print "****\n";
   
sub namec {
   my ($name) = @_;
   
   if( $name eq "ALL-HYD001")    { $AN = "H" }
   elsif( $name eq "ALL-HYE001") { $AN = "H" }  #because sed may swap D
   elsif( $name eq "ALL-HEL001") { $AN = "He" }
   elsif( $name eq "ALL-LIT001") { $AN = "Li" }
   elsif( $name eq "ALL-BER001") { $AN = "Be" }
   elsif( $name eq "ALL-BOR001") { $AN = "B" }
   elsif( $name eq "ALL-CAR001") { $AN = "C" }
   elsif( $name eq "ALL-NIT001") { $AN = "N" }
   elsif( $name eq "ALL-OXY001") { $AN = "O" }
   elsif( $name eq "ALL-FLU001") { $AN = "F" }
   elsif( $name eq "ALL-NEO001") { $AN = "Ne" }
   elsif( $name eq "ALL-SOD001") { $AN = "Na" }
   elsif( $name eq "ALL-SOE001") { $AN = "Na" } #because of sed
   elsif( $name eq "ALL-MAG001") { $AN = "Mg" }
   elsif( $name eq "ALL-ALU001") { $AN = "Al" }
   elsif( $name eq "ALL-SIL001") { $AN = "Si" }
   elsif( $name eq "ALL-PHO001") { $AN = "P" }
   elsif( $name eq "ALL-SUL001") { $AN = "S" }
   elsif( $name eq "ALL-CHL001") { $AN = "Cl" }
   elsif( $name eq "ALL-ARG001") { $AN = "Ar" }
   elsif( $name eq "ALL-POT001") { $AN = "K" }
   elsif( $name eq "ALL-CAL001") { $AN = "Ca" }
   elsif( $name eq "ALL-SCA001") { $AN = "Sc" }
   elsif( $name eq "ALL-TIT001") { $AN = "Ti" }
   elsif( $name eq "ALL-VAN001") { $AN = "V" }
   elsif( $name eq "ALL-CHR001") { $AN = "Cr" }
   elsif( $name eq "ALL-MAN001") { $AN = "Mn" }
   elsif( $name eq "ALL-IRO001") { $AN = "Fe" }
   elsif( $name eq "ALL-COB001") { $AN = "Co" }
   elsif( $name eq "ALL-NIC001") { $AN = "Ni" }
   elsif( $name eq "ALL-COP001") { $AN = "Cu" }
   elsif( $name eq "ALL-ZIN001") { $AN = "Zn" }
   elsif( $name eq "ALL-GAL001") { $AN = "Ga" }
   elsif( $name eq "ALL-GER001") { $AN = "Ge" }
   elsif( $name eq "ALL-ARS001") { $AN = "As" }
   elsif( $name eq "ALL-SEL001") { $AN = "Se" }
   elsif( $name eq "ALL-BRO001") { $AN = "Br" }
   elsif( $name eq "ALL-KRY001") { $AN = "Kr" }
   elsif( $name eq "ALL-RUB001") { $AN = "Rb" }
   elsif( $name eq "ALL-STR001") { $AN = "Sr" }
   elsif( $name eq "ALL-VTR001") { $AN = "Y" }
   elsif( $name eq "ALL-ZIR001") { $AN = "Zr" }
   elsif( $name eq "ALL-NIO001") { $AN = "Nb" }
   elsif( $name eq "ALL-MOL001") { $AN = "Mo" }
   elsif( $name eq "ALL-TEC001") { $AN = "Tc" }
   elsif( $name eq "ALL-RHU001") { $AN = "Ru" }
   elsif( $name eq "ALL-RHO001") { $AN = "Rh" }
   elsif( $name eq "ALL-PAL001") { $AN = "Pd" }
   elsif( $name eq "ALL-SLV001") { $AN = "Ag" }
   elsif( $name eq "ALL-CAD001") { $AN = "Cd" }
   elsif( $name eq "ALL-CAE001") { $AN = "Cd" } #sed
   elsif( $name eq "ALL-IND001") { $AN = "In" }
   elsif( $name eq "ALL-INE001") { $AN = "In" } #sed
   elsif( $name eq "ALL-TIN001") { $AN = "Sn" }
   elsif( $name eq "ALL-ANT001") { $AN = "Sb" }
   elsif( $name eq "ALL-TEL001") { $AN = "Te" }
   elsif( $name eq "ALL-IOD001") { $AN = "I" }
   elsif( $name eq "ALL-IOE001") { $AN = "I" } #sed
   elsif( $name eq "ALL-XEN001") { $AN = "Xe" }
   elsif( $name eq "ALL-CES001") { $AN = "Cs" }
   elsif( $name eq "ALL-BAR001") { $AN = "Ba" }
   else { $AN = $name }
   return $AN;
}


