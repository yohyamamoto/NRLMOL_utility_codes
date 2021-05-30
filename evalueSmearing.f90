!Read a file evalues.dat and apply gaussian smearing
!If EVALUES file is in the same directory, it will generate evalues.dat. 
!Input:
!   evalues.dat should contain number of evalues in the line 1 and list evalue per line afterwards
!Output:
!   output1: smeared data of intensity vs. energy
!   output2: list of evalue peaks
program main

implicit none
real*8,allocatable :: bin(:)  ! bin to store the output
real*8,allocatable :: EVAL(:) ! store evalues from the input file
integer :: I, NEVAL, X, XEND
real*8 :: XCONV !Conversion factor to convert index of bin to actual energy values
real*8 :: EMIN, EMAX, ENE, FAC, SIGMA, HARTREE2EV
logical :: EXIST

HARTREE2EV=27.2114  ! 1 Ha == 27.2114 eV
XEND=500 !number of bins
PRINT *,"Enter prefactor value for adjusting the Gaussian heights (e.g. 0.25)"
!FAC=0.25d0 !Gaussain prefactor; use this to adjust the Gaussian heights
READ *, FAC
!SIGMA=0.5d0 !standard deviation
PRINT *,"Enter sigma for Gaussain widths (e.g. 0.1)"
READ *, SIGMA
FAC=FAC/SIGMA/2.50662827463D0  ! 1/sqrt(2pi)

allocate(bin(XEND))

!Read evalues
!Prep EVALUES file with a lazy grep and awk
INQUIRE(FILE='EVALUES',EXIST=EXIST)
IF(EXIST) THEN
 PRINT *,'Processing EVALUES file'
 CALL SYSTEM("grep 'SUMMARY OF EVALUES' -A 1000 EVALUES | grep ENERGY: | wc -l > evalues.dat")
 CALL SYSTEM("grep 'SUMMARY OF EVALUES' -A 1000 EVALUES | grep ENERGY: |  awk '{print $9}' >> evalues.dat")
END IF

OPEN(UNIT=10,FILE='evalues.dat')
READ(10,*) NEVAL
ALLOCATE(EVAL(NEVAL))
DO I=1,NEVAL
 READ(10,*) EVAL(I)
END DO
EVAL = EVAL*HARTREE2EV
CLOSE(10)

EMIN=MINVAL(EVAL(:))-2.0d0
EMAX=MAXVAL(EVAL(:))+2.0d0
XCONV=(EMAX-EMIN)/XEND
bin=0.0d0

!do eval(1) to eval(N)
DO I=1,NEVAL
 !do X start to end
 DO X=1,XEND
  ENE=X*XCONV+EMIN
  bin(X) = bin(X)+FAC*EXP(-0.5D0*((ENE-EVAL(I))/SIGMA)**2)
 END DO
END DO

print *,'WRITING THE SMEARED EVALUES IN output1'
OPEN(UNIT=11,FILE='output1',STATUS='NEW')
DO X=1,XEND
 ENE=x*XCONV+EMIN
 WRITE(11,*) ENE, bin(X)
END DO
CLOSE(11)

print *,'WRITING THE EVALUE PEAKS IN output2'
OPEN(UNIT=12,FILE='output2',STATUS='NEW')
DO X=1,NEVAL
 WRITE(12,*) EVAL(X),1.0
END DO
CLOSE(12)

deallocate(bin)

PRINT *,"Plot this in gnuplot with: "
PRINT *,"plot 'output1' using 1:2 w l lc rgb 'red', 'output2' using 1:2 w impulses lc rgb 'black'"
PRINT *,"You can also set range of x axis with 'set xrange [-10:0]'"

end program main
