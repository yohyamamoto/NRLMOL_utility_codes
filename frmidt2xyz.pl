#!/usr/bin/perl
#This perl script converts FRMIDT (in bohr) to xyz (in angstrom)
#up (down) FOD is shown as X (z)
#Usage:  perl frmidt2xyz.pl < FRMIDT.in > xyz.out

$bohr = 0.5291772109217;

$LineNum=1;
while (defined($line = <>)) {
  chomp($line);
  #join ' ', split ' ', $text;
  $line = join ' ', split ' ', $line;
  #my ($name, $x, $y, $z) = split / /, $line;
  my ($x, $y, $z) = split / /, $line;
  if( $LineNum == 1 ) { 
   $upfod = $x;
   $dnfod = $y;
   $tot = $upfod+$dnfod;
   print "\t$tot\n up fod: $x down fod: $y\n" } 
  elsif( $LineNum > 1) {
    #print "$name,$x $y $z;"; 
    #$AN = name2AN($name);
    $x = sprintf("%15.8f", $x*$bohr);
    $y = sprintf("%15.8f", $y*$bohr);
    $z = sprintf("%15.8f", $z*$bohr);
    if( $LineNum <= 1+$upfod ) {
      print "X\t$x\t$y\t$z \n"
    }
    else {
      print "Z\t$x\t$y\t$z \n";
    }
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

