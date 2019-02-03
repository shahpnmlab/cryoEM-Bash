#!/bin/bash
#Source the relevant environment. we are supported by SBGrid, which makes life a little easier.
source /opt/sbgrid/share/grids/.admin/allgrid.shrc

echo "Path to file on server: "
read server

echo "RELION job number: "
read number

echo "RELION job type: "
read type

sftp user@server <<EOF
get $server
bye
EOF

a=`ls -t | head -n 1` #lists and stores the latest downloaded file into a variable
echo $a
mydate=`date +%Y%m%d`

tag=${mydate}_${number}_${type}
cp $a ${tag}.mrc
inmap=${tag}.mrc
echo $inmap

echo "bx: "
read bx

or=`expr $bx / 2`

echo $or

bhead -v 7 -origin $or,$or,$or ${inmap} outmap.mrc > bhead_originshift.log
cat bhead_originshift.log

phenix.map_box pdb_file=PATH/TO/PDBFILE.pdb ccp4_map_file=outmap.mrc selection=all mask_atoms_atom_radius=3 selection_radius=3.0 output_file_name_prefix=${tag}_boxmap > phenix_boxmap.log

cat phenix_boxmap.log
/bin/rm -f outmap.mrc

