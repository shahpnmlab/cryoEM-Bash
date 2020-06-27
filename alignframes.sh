#!/bin/bash
read -ep "folder: " folder
cd $folder
tag=${folder}_
mkdir processed

function frame_aligner (){
for i in `ls *.tif`; do
name=`echo $i | sed s/${tag}/tilt/g`
alignframes -input $i -o ./processed/$name.mrc -frames 2,6 -gain ../../../processing/gain.mrc -binning 2,2 -ro 6 -gpu 0
done
}

function frame_stack(){
#sort the list of files based on angle increment starting with the lowest angle first
#command sort is passed at the end of the loop because all the list needs to be generated
#which is done in the for loop
for i in `ls processed/*.mrc`; do
echo $i | sed 's|^processed/||g'
done | sort -n -k2 -t"_" > processed/temp.txt

#The sorted list misses the extra inputs that newstack requires
#specifically the number of tilts and a 0 after every file name
#awk can be used to do this in two steps
#first the entire list is printed {print $0} and 0 is appended by storing it in a variable v
#the total number of tilts are stored in filenum and the appended to the beginning of the list
#using the second awk command
filenum=`ls processed/*.mrc | wc -l`
cat processed/temp.txt | awk -v var=0 '{print $0;print var}' | awk -v v=$filenum 'NR==1{print v} 1' > processed/temp2.txt
mv processed/temp2.txt processed/temp.txt
cd processed/
newstack -fileinlist temp.txt -output ${folder}_stack.mrc
ls tilt0*.mrc | sort -n -t "_" -k 2 | awk -F "_" '{print $2}' | sed s/\.tif.*//g > ${folder}_stack.rawtlt
}

if [[ -f processed/temp.txt ]]; then
#frame_stack
printf "Everything is in order here. Consider running the script on the next folder. \n"
else
frame_aligner
frame_stack
fi
