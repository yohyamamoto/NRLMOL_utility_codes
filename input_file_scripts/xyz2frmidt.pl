#!/usr/bin/perl

$bohr = 0.5291772109217;

$LineNum=1;
while (defined($line = <>)) {
  chomp($line);
  #join ' ', split ' ', $text;
  $line = join ' ', split ' ', $line;
  my ($name, $x, $y, $z) = split / /, $line;
  if( $LineNum == 1 ) { print "\t$line\t0\n" } 
  elsif( $LineNum > 2) {
    #print "$name,$x $y $z;"; 
    $AN = name2AN($name);
    $x = sprintf("%15.8f", $x/$bohr);
    $y = sprintf("%15.8f", $y/$bohr);
    $z = sprintf("%15.8f", $z/$bohr);
    if ( $AN != "" ) {print "$x\t$y\t$z  D2INV=      1.0000 SUGGEST=       1.0000\n"}
  }
  $LineNum=$LineNum+1;
}
   
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

   else { $AN = $name }
   return $AN;
}

