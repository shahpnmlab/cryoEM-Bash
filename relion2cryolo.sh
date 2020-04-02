# The use case for this script is under the conditions where you dont know what your particles look like, 
# and you have manually picked some particles and run a preliminary 2D/3D classification on your picks. Now
# you have identified good classes and want to train Cryolo using the particles from the good 2D/3D classes.
# NOTE 1: The script currently works on mics that are named in an EPU style i.e. FoilHole...; I have some thoughts on
# how one could generalise this but for now this should work on EPU mics.
# NOTE 2: To run the script successfully cd into your RELION project directory and run from there

#!/bin/bash

# Get user input
read -ep "Path to particles.star (if using particles EXTRACTED after selecting good Class2D/3D) or run_data.star (if using ptcls from Refine3D) : " ptcls_path
read -ep "Particle box size (box should just about enclose the particle): " bx

# Help user with the decision process
num_mics=`ls Micrographs/* | wc -l`
num_ptcl=`awk '{print $9}' $ptcls_path | awk NF |  wc -l`
avg_ptcls_per_mic=`expr $num_ptcl / $num_mics`
echo "You have on an average $avg_ptcls_per_mic particles per micrograph"
echo "for training a dataset, try to use approx 300-500 ptcls from 10 or more mics whichever comes first"

read -ep "how many mics do you want to use for training (small ptcls=few mics; large ptcls=more mics: " howmany

# Get path to mics and write a temporary mic list to allow for rsyncing data
a=`grep MicrographName $ptcls_path | sed 's/\_rlnMicrographName \#//'`
awk -v col="$a" '{print $1"\t"$2"\t"$col}' $ptcls_path > temp.txt
mics_path_tmp=`awk '{print $3}' temp.txt | awk NF`

# Get the path to the mics to set up transefer
mics_path=`echo $mics_path_tmp | sed 's/\Foil.*//' | sed 's/.*Motion/Motion/'`
#awk '{print $3}' temp.txt | sort -R | uniq | head -${howmany} | sed 's/.*Foil/Foil/' > YOLO_mics.list #gets the list of micrographs from the mics path
#awk '{print $3}' temp.txt | awk NF |sed 1d >>> sed 1d should get rid of any of the aberrant lines from the data_optics table, check this line if things break horribly
awk '{print $3}' temp.txt | awk NF | sed 1d | sort -R | uniq | head -${howmany} | sed 's/.*Foil/Foil/' > YOLO_mics.list 

# Gets the list of micrographs from the mics path
rsync -avuz $mics_path --files-from=YOLO_mics.list train_images --progress
mkdir -p train_annotation

# Do the Math!
for i in `ls train_images/*.mrc`; do
name=`echo $i | sed 's/train_images\///'| sed 's/\.mrc//'`
j=`echo $i | sed 's/train_images\/FoilHole\_//' | sed 's/\_Data.*//'`
echo "creating a box file for $name in train_annotation"
grep $j temp.txt |sed 's/MotionCorr.*//' | sed 's/\.000000//'| sed 's/\.000000//'|awk NF | awk '{print $1-"'$bx'"/2"\t"$2-"'$bx'"/2"\t"'"$bx"'"\t"'"$bx"'}' > train_annotation/${name}.box
done

# Clean-up
rm temp.txt
rm YOLO_mics.list
