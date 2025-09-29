#!/usr/bin/perl
#This perl script combins XMOL.xyz (in angstrom) and FRMIDT (in bohr) to a single xyz file (in angstrom).
#Usage:  perl frmidt2xyz.pl XMOL.xyz FRMIDT.in > out.xyzext



$bohr = 0.5291772109217;   #in angstrom
#$bohr = 1.000;    #in bohr radius

# Check for correct number of arguments
die "Usage: $0 <file1> <file2>\n" unless @ARGV == 2;

my ($file1, $file2) = @ARGV;

# Open filehandles
open(my $fh1, '<', $file1) or die "Cannot open $file1: $!";
open(my $fh2, '<', $file2) or die "Cannot open $file2: $!";


$LineNum=1;
my $line1 = <$fh1>;
my $line2 = <$fh2>;
chomp($line1);
chomp($line2);

$line1 = join ' ', split ' ', $line1;
$line2 = join ' ', split ' ', $line2;

my ($z)      = split / /, $line1;
my ($x, $y)  = split / /, $line2;

$fodup=$x;
$foddn=$y;
$natom=$z;
$tot=$x+$y+$z;
print "\t$tot\n $tot entries, $z atoms, $x up fods, and $y down fods\n"; 

$LineNum=$LineNum+1;

while (my $line1 = <$fh1>) {
  chomp($line1);
  $line1 = join ' ', split ' ', $line1;
  my ($name, $x, $y, $z) = split / /, $line1;
  if( $LineNum > 2) {
    #print "$name $x $y $z;"; 
    #$AN = name2AN($name);
    $x = sprintf("%15.8f", $x);
    $y = sprintf("%15.8f", $y);
    $z = sprintf("%15.8f", $z);
    print "$name\t$x\t$y\t$z\n";
  }
  $LineNum=$LineNum+1;
}


while (my $line2 = <$fh2>) {
  chomp($line2);
  $line2 = join ' ', split ' ', $line2;
  my ($x, $y, $z) = split / /, $line2;
  $x =~ s/D/E/g;
  $y =~ s/D/E/g;
  $z =~ s/D/E/g;
  if( $LineNum > 1) {
    $x = sprintf("%15.8f", $x*$bohr);
    $y = sprintf("%15.8f", $y*$bohr);
    $z = sprintf("%15.8f", $z*$bohr);
    if( $LineNum <= 2+$natom+$fodup ) {
      print "X\t$x\t$y\t$z\t pseudo_type=A\n"
    }
    else {
      print "X\t$x\t$y\t$z\t pseudo_type=B\n";
    }
  }
  $LineNum=$LineNum+1;
}


   
close $fh1;
close $fh2;

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
