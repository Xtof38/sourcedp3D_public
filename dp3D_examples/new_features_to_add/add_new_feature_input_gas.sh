#!/bin/sh

###########################################################################
# This is a script to obtain a correct input_dp3D or gas when adding new features
###########################################################################

# Christophe.martin@grenoble-inp.fr   
# first created may 2013

#BINARY=/usr/local/dp3D/
theuser=`whoami`

#option="add_line"
option="replace_line"

#file2treat="input_dp3D"
file2treat="input_gas"
if [  "$1" = "" ];then
   echo "need an argument: the directory to treat the input_gas file"
   echo "as:"
   echo "$0 the_directory_where_input_gas_is_located"
  exit
fi



#$file2treat files that are needed:

#to decomment for the real thing:
#################################################################
#find /home/"$theuser" -name "$file2treat" > filelist
#find /home0/"$theuser"/ -name "$file2treat" >> filelist
#################################################################

#list=$(cat filelist)

# for testing:
#list=/home0/chris/sourcedp3D/dp3D_examples/generate_gaz_clusters/"$file2treat"
#list=/home0/chris/sourcedp3D/dp3D_examples/generate_gaz_particles/input_gas
list=$1/"$file2treat"
l2cp=""
for fich in $list ; do

sed  -i '/aggregate_size=[0-9]/d' $fich
sed  -i '/bond_size=[0-9]/d' $fich
sed  -i '/whole_motif/d' $fich
sed  -i '/size_x=/d' $fich

  file2treat=$(grep -c "aggregate_size=[0-9]\|bond_size=[0-9]\|size_x=[0-9]\|size_y=[0-9]\|size_z=[0-9]" $fich)
  if [ $file2treat = "0" ];then
    linetorm=$(grep -n "entities to pack" $fich | cut -f1 -d:)

    if [ "$linetorm" != "" ];then
      let "lm1 = linetorm - 1"
      in_f=$(grep -c "initial_file=." $fich)
      if [ "$in_f" = 0 ];then
        let "lp5 = linetorm + 5"
      else
        let "lp5 = linetorm + 6"
        let "lp2cp = lp5 - 1"
        l2cp=$(sed ''$lp2cp'!d' $fich)
      fi
      sed  -i ''$lm1','$lp5'd' $fich  
    fi
  fi
done

 


  echo "numerical new features: in progress"
old_char="# prop. of class (particle and aggregate sizes in µm)"
new_char="# prop. of class (particle sizes in µm)              "

for fich in $list ; do
  old=$(grep -c "$old_char" $fich)
  new=$(grep -c "$new_char" $fich)
  file2treat=$(grep -c "aggregate_size=[0-9]\|bond_size=[0-9]\|size_x=[0-9]\|size_y=[0-9]\|size_z=[0-9]" $fich)
  if [ $file2treat = "0" -a "$new" = "0" -a "$old" != "0" ];then
     sed -i "s|$old_char|$new_char|g" $fich
     sed -i '/whole_motif/d' $fich
  fi
done

old_char=$(grep -o "# number=.*" $fich | tail -1)
new_char="# number= mat= name= particle_size= deviation= Temp= motif= max_angle="

for fich in $list ; do
  old=$(grep -c "$old_char" $fich)
  new=$(grep -c "$new_char" $fich)
  file2treat=$(grep -c "aggregate_size=[0-9]\|bond_size=[0-9]\|size_x=[0-9]\|size_y=[0-9]\|size_z=[0-9]" $fich)
  if [ $file2treat = "0" -a "$new" = "0" -a "$old" != "0" ];then
     sed -i "s|$old_char|$new_char|g" $fich
  fi
done

old_char="# 1x1y1z 1x1y0z 1x0y0z 1x0y1z 0x1y1z 0x1y0z 0x0y1z 0x0y0z RxRy1z RxRy0z"
new_char="# 1x1y1z 1x1y0z 1x0y0z 1x0y1z 0x1y1z 0x1y0z 0x0y1z 0x0y0z cyl_x cyl_y"

for fich in $list ; do
  old=$(grep -c "$old_char" $fich)
  new=$(grep -c "$new_char" $fich)
  file2treat=$(grep -c "aggregate_size=[0-9]\|bond_size=[0-9]\|size_x=[0-9]\|size_y=[0-9]\|size_z=[0-9]" $fich)
  if [ "$file2treat" = "0" -a "$new" = "0" -a "$old" != "0" ];then
     sed -i "s|$old_char|$new_char|g" $fich
  fi
done

echo "# options:" > toadd.tmp
echo "# none initial_file=" >> toadd.tmp

if [ "$l2cp" = "" ];then
  echo "none" >> toadd.tmp
else
  echo $l2cp  >> toadd.tmp
fi
echo "______________________________________________________________________" >> toadd.tmp
for fich in $list ; do
  linetotreat=$(grep -n "# size distribution:" $fich | cut -f1 -d:)
  let "linetotreat = linetotreat + 3 "
  sed -i ''$linetotreat'r toadd.tmp' $fich 
done



rm -f filelist
# to return to the proper prompt
 exit
 

