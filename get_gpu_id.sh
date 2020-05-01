# This jiffy will find all avalible CUDA devices on your system and print their IDs to STDOUT.
# The user can either choose the GPUs they want to run the jobs on or use all available GPUs.
# I wrote this script to make my life easier when running emClarity jobs on our cluster.

#!/bin/bash
# FIND CUDA VISBLE DEVICES
function selectGpus(){
        gpuids=`cat /proc/driver/nvidia/gpus/0000\:*\:*/information | grep "GPU UUID:" | sed -e 's/GPU UUID:...//g' | awk 'BEGIN { ORS = "," } { print }' | sed 's/.$//'`
        read -ep "Are you running this on LESS than 4 GPUS?(y/n)" areyou
        if [ $areyou == y ]; then
                printf "$gpuids \n"
                read -ep "Choose wisely young padawan:" gpus
                export CUDA_VISIBLE_DEVICES=$gpus
                echo "You have chosen GPUs with the iDs: $CUDA_VISIBLE_DEVICES"
                printf "\n"
        else
                export CUDA_VISIBLE_DEVICES=$gpuids
                printf "Running emClarity with all available GPUs. May the force be with you\n"
                printf "\n"
        fi
}

selectGpus
