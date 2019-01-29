#! /bin/bash

for ea in  `ls *model.star`; do

relion_star_plottable $ea data_model_classes rlnClassDistribution rlnReferenceImage >& junklogfile
cat *.dat > classdist0

done

awk '($0 ~ /class001/ ) { print ""; } { print; }' classdist0 > classdist
rm *.dat  junklogfile
cat classdist

awk 'BEGIN { xyz = ""; }
  /class001/  { print xyz; start = match($0, "_it"); xyz = substr($0, start+3, 3)  " " }
 { xyz = xyz  $2  " " }
END { print xyz "\n"; }' classdist0 > classdist.plot

cat classdist.plot
