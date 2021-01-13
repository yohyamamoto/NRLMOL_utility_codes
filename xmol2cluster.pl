#!/usr/bin/perl

$bohr = 0.5291772109217;
print "GGA-PBE*GGA-PBE\n";
print "GRP\n";

$LineNum=1;
while (defined($line = <>)) {
  chomp($line);
  #join ' ', split ' ', $text;
  $line = join ' ', split ' ', $line;
  my ($name, $x, $y, $z) = split / /, $line;
  if( $LineNum == 1 ) { print "$line  Number of inequivalent atoms\n" } 
  elsif( $LineNum > 2) {
    #print "$name,$x $y $z;"; 
    $AN = name2AN($name);
    $x = sprintf("%15.8f", $x/$bohr);
    $y = sprintf("%15.8f", $y/$bohr);
    $z = sprintf("%15.8f", $z/$bohr);
    print "$x\t$y\t$z  $AN ALL\n";
  }
  $LineNum=$LineNum+1;
}
print "0.0     0.000     Charge and Moment\n";
   
sub name2AN {
   my ($name) = @_;
   
   if( $name eq "H")     { $AN = 1 }
   elsif( $name eq "He") { $AN = 2 }
   elsif( $name eq "Li") { $AN = 3 }
   elsif( $name eq "Be") { $AN = 4 }
   elsif( $name eq "B")  { $AN = 5 }
   elsif( $name eq "C")  { $AN = 6 }
   elsif( $name eq "N")  { $AN = 7 }
   elsif( $name eq "O")  { $AN = 8 }
   elsif( $name eq "F")  { $AN = 9 }
   elsif( $name eq "Ne") { $AN = 10 }
   elsif( $name eq "Na") { $AN = 11 }
   elsif( $name eq "Mg") { $AN = 12 }
   elsif( $name eq "Al") { $AN = 13 }
   elsif( $name eq "Si") { $AN = 14 }
   elsif( $name eq "P")  { $AN = 15 }
   elsif( $name eq "S")  { $AN = 16 }
   elsif( $name eq "Cl") { $AN = 17 }
   elsif( $name eq "Ar") { $AN = 18 }
   elsif( $name eq "K")  { $AN = 19 }
   elsif( $name eq "Ca") { $AN = 20 }
   elsif( $name eq "Sc") { $AN = 21 }
   elsif( $name eq "Ti") { $AN = 22 }
   elsif( $name eq "V") { $AN = 23 }
   elsif( $name eq "Cr") { $AN = 24 }
   elsif( $name eq "Mn") { $AN = 25 }
   elsif( $name eq "Fe") { $AN = 26 }
   elsif( $name eq "Co") { $AN = 27 }
   elsif( $name eq "Ni") { $AN = 28 }
   elsif( $name eq "Cu") { $AN = 29 }
   elsif( $name eq "Zn") { $AN = 30}
   elsif( $name eq "Ga") { $AN = 31 }
   elsif( $name eq "Ge") { $AN = 32 }
   elsif( $name eq "As") { $AN = 33 }
   elsif( $name eq "Se") { $AN = 34 }
   elsif( $name eq "Br") { $AN = 35 }
   elsif( $name eq "Kr") { $AN = 36 }
   elsif( $name eq "Rb") { $AN = 37 }
   elsif( $name eq "Sr") { $AN = 38 }
   elsif( $name eq "Y") { $AN = 39 }
   elsif( $name eq "Zr") { $AN = 40 }
   elsif( $name eq "Nb") { $AN = 41 }
   elsif( $name eq "Mo") { $AN = 42 }
   elsif( $name eq "Tc") { $AN = 43 }
   elsif( $name eq "Ru") { $AN = 44 }
   elsif( $name eq "Rh") { $AN = 45 }
   elsif( $name eq "Pd") { $AN = 46 }
   elsif( $name eq "Ag") { $AN = 47 }
   elsif( $name eq "Cd") { $AN = 48 }
   elsif( $name eq "In") { $AN = 49 }
   elsif( $name eq "Sn") { $AN = 50 }


   else { $AN = $name }
   return $AN;
}

