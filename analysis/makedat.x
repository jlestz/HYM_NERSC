#!/bin/bash 
# make and copy data files for a single directory 
# author: Jeff Lestz
# last update: 29 November 2017

# data file to move to
data=~/data.nov.17

# directory with executables to copy from 
codedir=$SCRATCH/runs.nov.2017/n5l0.7v5.0_dl0.30

runid=n5l0.7v5.0_dl0.30

# here=$(pwd)
# cd $dir ; 

# copy reliable versions of hfh, hist, and hist_tor
cp $codedir/hfh.x . ; 
cp $codedir/hist.x . ; 
cp $codedir/hist_tor.x . ; 

# ensure the privileges are set to execute 
chmod 744 hfh.x 
chmod 744 hist.x 
chmod 744 hist_tor.x 

# generate the fort.xx files
./hfh.x ; 
./hist.x ; 
./hist_tor.x ; 

# generate the initial b3.dat file
b3make=$ask/h3bfld.x
$ask/make_b3inp.x 1 
$b3make ; 

# make new b3.dat's until a nonempty one is made 
# (unclear why some of them don't work...) 
# write 1 + 4*i3 to get the record you want 
# update: this is no longer needed 
i3=$(grep i3dbout hstat.d | cut -d'=' -f4); 
i3=$(echo $i3);
# i3=$((i3-1));
#rec=$(echo "1 + 4*$i3" | bc); 
rec=$i3
$ask/make_b3inp.x $rec
$b3make ; 

# with the b3.dat file record numbers wrong, 
# used this to cycle through until found the
# most recent nonempty file. 
# no longer needed 
#i3=$((i3+1)); 
#fsize=0
#while [ $fsize -lt 1000 ] ; do 
#    i3=$((i3-1)); 
#    echo -e "1\n$i3" > b3inp ; 
#    $b3make ; 
#    fsize=$(du b3.$i3.dat | cut -d'b' -f1)
#    fsize=$(echo $fsize)
#done 
    
# copy data files 
cp -v fort.20 $data/fort.20/$runid.fort.20
cp -v fort.17 $data/fort.17/$runid.fort.17
cp -v fort.18 $data/fort.18/$runid.fort.18

cp -v en.dat $data/en/$runid.en.dat
cp -v psi.dat $data/psi.dat/$runid.psi.dat 
cp -v ff.dat $data/ff/$runid.ff.dat 
cp -v ff_omegaw.dat $data/ff_omegaw/$runid.ff_omegaw.dat
cp -v psp.dat $data/psp/$runid.psp.dat 

cp -v b3.1.dat $data/b3.dat/$runid.b3.0.dat 
cp -v b3.$i3.dat $data/b3.dat/$runid.b3.dat 

# return to previous directory 
# cd $here
