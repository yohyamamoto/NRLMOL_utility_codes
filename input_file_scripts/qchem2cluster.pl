#!/usr/bin/perl

$bohr = 0.5291772109217;
print "MGGA-SCAN*MGGA-SCAN\n";
print "NONE\n";

$LineNum=1;
while (defined($line = <>)) {
  chomp($line);
  #join ' ', split ' ', $text;
  $line = join ' ', split ' ', $line;
  my ($name, $x, $y, $z) = split / /, $line;
  $x =~ s/D/E/g;
  $y =~ s/D/E/g;
  $z =~ s/D/E/g;

  if( $LineNum == 1 ) { print "Z   Number of inequivalent atoms\n" } 
  elsif( $LineNum == 2) {
    $ncharge = $name;
    $spinmlt = $x-1;
  }
  #elsif( $y == 0 && $x == 0 && $z == 0 ) {
    # Do nothing
  #}
  elsif( $LineNum > 2) {
    #print "$name,$x $y $z;"; 
    $AN = name2AN($name);
    $x = sprintf("%15.8f", $x/$bohr);
    $y = sprintf("%15.8f", $y/$bohr);
    $z = sprintf("%15.8f", $z/$bohr);
    if($AN > 0) { print "$x\t$y\t$z  $AN ALL\n" };
  }
  $LineNum=$LineNum+1;
}
print "$ncharge     $spinmlt     Charge and Moment\n";
   
sub name2AN {
   my ($name) = @_;

# Two characters first.   
   if( substr($name, 0, 2) eq "He")    { $AN = 2 }
   elsif( substr($name, 0, 2) eq "Li") { $AN = 3 }
   elsif( substr($name, 0, 2) eq "Be") { $AN = 4 }
   elsif( substr($name, 0, 2) eq "Ne") { $AN = 10 }
   elsif( substr($name, 0, 2) eq "Na") { $AN = 11 }
   elsif( substr($name, 0, 2) eq "Mg") { $AN = 12 }
   elsif( substr($name, 0, 2) eq "Al") { $AN = 13 }
   elsif( substr($name, 0, 2) eq "Si") { $AN = 14 }
   elsif( substr($name, 0, 2) eq "Cl") { $AN = 17 }
   elsif( substr($name, 0, 2) eq "Ar") { $AN = 18 }
   elsif( substr($name, 0, 2) eq "Ca") { $AN = 20 }
   elsif( substr($name, 0, 2) eq "Sc") { $AN = 21 }
   elsif( substr($name, 0, 2) eq "Ti") { $AN = 22 }
   elsif( substr($name, 0, 2) eq "Cr") { $AN = 24 }
   elsif( substr($name, 0, 2) eq "Mn") { $AN = 25 }
   elsif( substr($name, 0, 2) eq "Fe") { $AN = 26 }
   elsif( substr($name, 0, 2) eq "Co") { $AN = 27 }
   elsif( substr($name, 0, 2) eq "Ni") { $AN = 28 }
   elsif( substr($name, 0, 2) eq "Cu") { $AN = 29 }
   elsif( substr($name, 0, 2) eq "Zn") { $AN = 30}
   elsif( substr($name, 0, 2) eq "Ga") { $AN = 31 }
   elsif( substr($name, 0, 2) eq "Ge") { $AN = 32 }
   elsif( substr($name, 0, 2) eq "As") { $AN = 33 }
   elsif( substr($name, 0, 2) eq "Se") { $AN = 34 }
   elsif( substr($name, 0, 2) eq "Br") { $AN = 35 }
   elsif( substr($name, 0, 2) eq "Kr") { $AN = 36 }
   elsif( substr($name, 0, 2) eq "Rb") { $AN = 37 }
   elsif( substr($name, 0, 2) eq "Sr") { $AN = 38 }
   elsif( substr($name, 0, 2) eq "Zr") { $AN = 40 }
   elsif( substr($name, 0, 2) eq "Nb") { $AN = 41 }
   elsif( substr($name, 0, 2) eq "Mo") { $AN = 42 }
   elsif( substr($name, 0, 2) eq "Tc") { $AN = 43 }
   elsif( substr($name, 0, 2) eq "Ru") { $AN = 44 }
   elsif( substr($name, 0, 2) eq "Rh") { $AN = 45 }
   elsif( substr($name, 0, 2) eq "Pd") { $AN = 46 }
   elsif( substr($name, 0, 2) eq "Ag") { $AN = 47 }
   elsif( substr($name, 0, 2) eq "Cd") { $AN = 48 }
   elsif( substr($name, 0, 2) eq "In") { $AN = 49 }
   elsif( substr($name, 0, 2) eq "Sn") { $AN = 50 }
# One chalacter
   elsif( substr($name, 0, 1) eq "H")  { $AN = 1 }
   elsif( substr($name, 0, 1) eq "B")  { $AN = 5 }
   elsif( substr($name, 0, 1) eq "C")  { $AN = 6 }
   elsif( substr($name, 0, 1) eq "N")  { $AN = 7 }
   elsif( substr($name, 0, 1) eq "O")  { $AN = 8 }
   elsif( substr($name, 0, 1) eq "F")  { $AN = 9 }
   elsif( substr($name, 0, 1) eq "P")  { $AN = 15 }
   elsif( substr($name, 0, 1) eq "S")  { $AN = 16 }
   elsif( substr($name, 0, 1) eq "K")  { $AN = 19 }
   elsif( substr($name, 0, 1) eq "V")  { $AN = 23 }
   elsif( substr($name, 0, 1) eq "Y")  { $AN = 39 }


   else { $AN = $name }
   return $AN;
}

