for i in `ls train_annotation/*.box`; do
v=`echo $i`
echo $v
u=`echo $v | sed -e 's/train_annotation\///g' | sed -e 's/.box//g'`

for j in `ls full_data/${u}.mrc`; do
mkdir -p train_images
echo "moving ${j} to the proper folder"
mv $j train_images
done
done
