# This jiffy will create a star file out of all the IMOD mod files containing particle coords.
# run the script in the folder containing the mod files.

#!/bin/bash

# set -x

read -ep "Enter Apx value which is at the end of your mod file (Eg: _8.00Apx):  " warpTag
read -ep "Enter bin value of your tomogram: " bin

if [ -f allStar.star ]; then
cp allStar.star allStar.star.bak
fi

for i in `ls *.mod`; do
 bn=`basename $i .mod`
 model2point -fl -InputFile ${i} -output ${bn}.txt
 awk -v SF="$bin" '{print $1*SF"\t"$2*SF"\t"$3*SF}' ${bn}.txt > temp.txt && mv temp.txt ${bn}.txt

        while read line; do
        theseLines=`echo $line | sed "s/^/${bn} /g"`
        echo $theseLines >> allStar.star
        done < ${bn}.txt

done

sed -i '1i data_' allStar.star
sed -i '2i loop_' allStar.star
sed -i '3i _rlnMicrographName #1' allStar.star
sed -i '4i _rlnCoordinateX #2' allStar.star
sed -i '5i _rlnCoordinateY #3' allStar.star
sed -i '6i _rlnCoordinateZ #4' allStar.star
sed -i "s/$warpTag//g" allStar.star
