#!/bin/bash -f

red=$'\e[1;31m'
grn=$'\e[1;32m'
yel=$'\e[1;33m'
blu=$'\e[1;34m'
mag=$'\e[1;35m'
cyn=$'\e[1;36m'
end=$'\e[0m'

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
printf "\n"
if grep -q "Refinement has converged" $path/run.out; then
printf "Refinement ${red}HAS${end} converged!"
printf "\n"
printf "\n"
tail -5 $path/run.out
printf "\n"
else
printf "Refinement ${mag}HASN'T${end} converged..."
printf "\n"
printf "\n"
tail -5 $path/run.out
printf "\n"
printf "\n"
fi
