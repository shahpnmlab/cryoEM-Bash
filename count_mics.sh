# This script can be used to count the number of micrographs that went into the 3d refniment 
#calculation as well as the number of particles per micrographs.
#Credit for counting to the number of instances of the micropraphs goes to /u/fedorqui (https://stackoverflow.com/users/1983854/fedorqui)

#!/bin/bash

awk '{print $7}' path/to/run_data.star > foo
awk -F= '/MotionCorr/ {count[$1]++} END {for (i in count) print i, count[i]}' foo | sort -n | wc -l
sed -i '1i _MicrographName #1'\\n'_NumberOfParticles #2' foo
