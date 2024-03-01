# NRLMOL utility codes
This repository contains utility codes and scripts for accompany the NRLMOL and FLOSIC codes. The below are some highlights.

- `wfout_reader.f90`: Convert a binary WFOUT into a human readable format WFOUT2
- `wfout_unp2pol_converter.f90`: Convert a spin unpolarized WFOUT into a spin polarized WFOUT.
- `evalueSmearing.f90`: Apply Gaussain smearing on eigenvalues for plotting with gnuplot.
- `xmol2cluster.pl`: Converts an xmol geometry file to NRLMOL CLUSTER file.
- `qchem2cluster.pl`: Converts an qchem geometry file to NRLMOL CLUSTER file.
- `cluster2xyz.pl`: Converts NRLMOL CLUSTER file to xyz file.
- `benchmark/benchmark_libxc.sh`: shell script testing suite code for the UTEP-NRLMOL code (written for old versions around 2015-2017).
- `nrlmol2molden.f90`: Converts NRLMOL output to molden file
