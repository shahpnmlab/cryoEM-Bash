#!/bin/bash

if [[ $1 = "-h" ]] || [[ -z "$1" ]]; then
        printf "******** USAGE ********\n"
        printf "*** Enter before and after strings ***\n"
        printf "*** For example: ./filter.sh tilt01 tilt02 ***\n"
        printf "*** It is implied that you know which field needs to be changed ***\n"
        printf "*** So make sure you see what the last entry is in dimifilter.m file ***\n"
        printf "*** Run script with -show flag to reveal the contents of dimifilter.m ***\n"
        printf "************************* \n"
else
if [ $1 = "-show" ]; then
        cat dimifilter.m
else
        before=$1
        after=$2
        sed -i "s/$before/$after/g" dimifilter.m

        grep $after dimifilter.m

        path/to/matlab/ -nodisplay -nosplash -r "run dimifilter.m; exit"

wait
ls -ralth $after*.mrc
fi
fi
