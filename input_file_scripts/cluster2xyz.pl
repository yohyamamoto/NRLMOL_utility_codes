#!/usr/bin/perl

$bohr = 0.5291772109217;
$LineNum=1;
while (defined($line = <>)) {
  chomp($line);
  #join ' ', split ' ', $text;
  $line = join ' ', split ' ', $line;
  my ($x, $y, $z, $AN, $tmp1, $tmp2) = split / /, $line;
  $x =~ s/D/E/g;
  $y =~ s/D/E/g;
  $z =~ s/D/E/g;

  if( $LineNum == 3 ) { 
    my ($numatoms) = split / /,$line;  
    $maxline=$numatoms+4;
    print "$numatoms\n\n" } 
  elsif( 3 < $LineNum && $LineNum < $maxline) {
 
    #print "$name,$x $y $z;"; 
    $name = AN2name($AN);
    #$name = sprintf("%2s", $name);
    $x = sprintf("%15.8f", $x*$bohr);
    $y = sprintf("%15.8f", $y*$bohr);
    $z = sprintf("%15.8f", $z*$bohr);
    print "$name$x$y$z\n";
 
  }
  $LineNum=$LineNum+1;
}
   
sub AN2name {
   my ($AN) = @_;

   if( $AN == 1)      { $name = "H " }
   elsif( $AN == 2 )  { $name = "He" }
   elsif( $AN == 3 )  { $name = "Li" }
   elsif( $AN == 4 )  { $name = "Be" }
   elsif( $AN == 5 )  { $name = "B " } 
   elsif( $AN == 6 )  { $name = "C " }
   elsif( $AN == 7 )  { $name = "N " }
   elsif( $AN == 8 )  { $name = "O " }
   elsif( $AN == 9 )  { $name = "F " }
   elsif( $AN == 10 ) { $name = "Ne" }
   elsif( $AN == 11 ) { $name = "Na" }
   elsif( $AN == 12 ) { $name = "Mg" }
   elsif( $AN == 13 ) { $name = "Al" }
   elsif( $AN == 14 ) { $name = "Si" }
   elsif( $AN == 15 ) { $name = "P " } 
   elsif( $AN == 16 ) { $name = "S " }
   elsif( $AN == 17 ) { $name = "Cl" }
   elsif( $AN == 18 ) { $name = "Ar" }
   elsif( $AN == 19 ) { $name = "K " }
   elsif( $AN == 20 ) { $name = "Ca" }
   elsif( $AN == 21 ) { $name = "Sc" }
   elsif( $AN == 22 ) { $name = "Ti" }
   elsif( $AN == 23 ) { $name = "V " }
   elsif( $AN == 24 ) { $name = "Cr" }
   elsif( $AN == 25 ) { $name = "Mn" }
   elsif( $AN == 26 ) { $name = "Fe" }
   elsif( $AN == 27 ) { $name = "Co" }
   elsif( $AN == 28 ) { $name = "Ni" }
   elsif( $AN == 29 ) { $name = "Cu" }
   elsif( $AN == 30 ) { $name = "Zn" }
   elsif( $AN == 31 ) { $name = "Ga" }
   elsif( $AN == 32 ) { $name = "Ge" }
   elsif( $AN == 33 ) { $name = "As" }
   elsif( $AN == 34 ) { $name = "Se" }
   elsif( $AN == 35 ) { $name = "Br" }
   elsif( $AN == 36 ) { $name = "Kr" }
   elsif( $AN == 37 ) { $name = "Rb" }
   elsif( $AN == 38 ) { $name = "Sr" }
   elsif( $AN == 39 ) { $name = "Y " }
   elsif( $AN == 40 ) { $name = "Zr" }
   elsif( $AN == 41 ) { $name = "Nb" }
   elsif( $AN == 42 ) { $name = "Mo" }
   elsif( $AN == 43 ) { $name = "Tc" }
   elsif( $AN == 44 ) { $name = "Ru" }
   elsif( $AN == 45 ) { $name = "Rh" }
   elsif( $AN == 46 ) { $name = "Pd" }
   elsif( $AN == 47 ) { $name = "Ag" }
   elsif( $AN == 48 ) { $name = "Cd" }
   elsif( $AN == 49 ) { $name = "In" }

   else { $name = "NA" }
   return $name;
}
