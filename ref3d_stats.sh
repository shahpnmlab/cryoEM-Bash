#USE THIS SCRIPT TO REFORMAT THE RUN.OUT FILE FROM RELION IN A MORE READABLE FORMAT. THIS SCRIPT IS PARTICULARLY USEFUL WHEN MONITORING JOBS REMOTELY, ESPECIALLY WHEN USING PHONE OR A TABLET. RUN THE SCRIPT IN THE PARENT RELION DATA PROCESSING DIRECTORY.

#!/bin/bash -f

ls -ralth Refine3D/
echo "Enter job number: "
read number
path=" `pwd`/Refine3D/job"$number
echo $path

col1=`cat $path/run.out | grep "Iteration" | cut -c-35 | grep -Eo '[+-]?[0-9]+([.][0-9]+)?'`
col2=`cat $path/run.out | grep "CurrentResolution" | cut -c-35 | grep -Eo '[+-]?[0-9]+([.][0-9]+)?'`
col3=`cat $path/run.out | grep "Changes in angles" | cut -c 34- | cut -c-15 | sed -e s/deg.*//g`
col4=`cat $path/run.out | grep "Estimated accuracy angles" | cut -c 42- | cut -c-10 | sed -e s/deg.*//g`
col5=`cat $path/run.out | grep "offset step" | cut -c 36- | cut -c-10 | sed -e s/p.*//g`
col6=`cat $path/run.out | grep "offset step" | sed -e s/.*=//g | sed -e s/pixels//g`
col7=`cat $path/run.out | grep "local" | sed -e s/.*=//g`

printf "\n_Iteration\n_Resolution(A)\n_ChangeAngle(deg)\n_EstimatedAngleAccuracy(pix)\n_OffsetRange(pix)\n_OffsetStep(pix)\n_LocalSearches\n\n"
pr -c7 -t -e10 <<eof
$col1
$col2
$col3
$col4
$col5
$col6
$col7
eof

printf "\n****Last 5 lines of $path/run.out****\n"
tail -5 $path/run.out
