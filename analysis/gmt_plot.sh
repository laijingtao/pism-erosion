#!/bin/bash

# change parameters here
infile=test.nc
outfile=test.jpg
cbartitle=Elevation
cbarunit=m
cbar=0/2500/100
range=-124.8/-122.6/47/48.4

#python ../tools/nc2xyz.py -i $infile -o tmp.xyz -v thk
python ../tools/nc2gmt.py -i $infile -o tmp.xyz -v topg --srs "+init=epsg:26710" --interp True

source activate gmt

xyz2grd tmp.xyz -Gtmp.nc -R$range -I0.5m

psbasemap -R$range -Jm6 -Ba1f0.25 -V -P -K -X1.5 -Y2 >> tmp.ps 
makecpt -T$cbar -Cdem2 >tmp.cpt
grdimage tmp.nc -Ctmp.cpt -Jm -E300 -nb -Q -P -O -K >> tmp.ps
psscale -Dx15.5c/0.5c+w12c/0.5c -Ctmp.cpt -Baf -Bx+l$cbartitle -By+l$cbarunit -O >> tmp.ps

#ps2pdf tmp.ps $outfile
psconvert tmp.ps -A -Tj
mv tmp.jpg $outfile
rm gmt.history
rm tmp*

source deactivate gmt

echo "GMT: plotting finished."
