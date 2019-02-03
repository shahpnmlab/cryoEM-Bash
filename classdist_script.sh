#RUN THIS SCRIPT IN THE PARENT RELION FOLDER.

#!/bin/bash

ls -ralt Class3D/
echo "Enter job number: "
read number
path=" `pwd`/Class3D/job"$number
echo $path
cd $path
scriptdir="PATH/TO/SCRIPT/FOLDER/"
script="classdist.sh"

if [ ! -f $path/$script ]
then
echo "Script not found. It  will now  be copied and executed in $path"
cp  $scriptdir/$script $path
bash $path/$script

else
bash $path/$script

fi
