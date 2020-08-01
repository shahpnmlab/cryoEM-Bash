# This jiffy will create a star file out of all the IMOD mod files containing particle coords.
# run the script in the folder containing the mod files.

#!/bin/bash

# set -x

if [ -f allStar.star ]; then
rm allStar.star
fi

for i in `ls *.mod`;do
bn=`basename $i .mod`
model2point -InputFile ${i} -output ${bn}.txt

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
