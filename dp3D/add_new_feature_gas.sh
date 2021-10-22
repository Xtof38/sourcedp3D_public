#!/bin/sh

###########################################################################
# This is a script to obtain a correct input_dp3D or gas when adding new features
###########################################################################

# Christophe.martin@grenoble-inp.fr   
# first created may 2013

#BINARY=/usr/local/dp3D/
theuser=`whoami`

option="add_line"
#option="replace_line"

#file2treat="input_dp3D"
file2treat="input_gas"

#$file2treat files that are needed:

#to decomment for the real thing:
#################################################################
find /home/"$theuser" -name "$file2treat" > filelist
find /home0/"$theuser"/ -name "$file2treat" >> filelist
#################################################################

#find /home/$theuser -name "input_gas" > filelist
#find /home0/$theuser/ -name "input_gas" >> filelist

list=$(cat filelist)
list_i="1 2 3 4 5 6 7 8 9"
# for testing:
#list='/home/chris/sourcedp3D/test_before_commit/test/nplast1/isost_aff_rot/$file2treat'
#list='/home/chris/sourcedp3D/test_before_commit/reference/nplast1/bending/$file2treat'
#list='/home/chris/sourcedp3D/test_before_commit/reference/nplast1/split_cylin/$file2treat'
#list='/home/chris/sourcedp3D/dp3D_examples/crush_cluster/$file2treat'
#list='/home0/chris/compact01/test_cubes/input_gas /home/chris/sourcedp3D/dp3D_examples/generate_gaz_clusters/input_gas /home/chris/sourcedp3D/dp3D_examples/generate_gaz_particles/input_gas '

#case $option in
#  add_line ) 
#  beware kw_to_modify must be inserted also below
  for i in $list_i;do
    kw_to_modify="# prop. of class (particle and aggregate sizes in µm) $i:"
    line_to_obtain1="# number= name= particle_size= deviation= motif= aggregate_size= "
    line_to_obtain2="# bond_size= spherical rectangular whole_motif "
    line_to_obtain3="# size_x= size_y= size_z="
    echo $kw_to_modify > kw.tmp
    echo $line_to_obtain1 >> kw.tmp
    echo $line_to_obtain2 >> kw.tmp
    echo $line_to_obtain3 >> kw.tmp
    echo "bond new features: in progress"
    for fich in $list ; do
      echo "treating  $fich"
# replaces only between line0 and $long_line

        sed -i "/# prop. of class (particle and aggregate sizes in µm) $i:/,/____________/ { 0,/#.*/s/#.*/line0torm/g ; }" $fich
        sed -i "/line0torm/,/____________/ { 0,/#.*/s/#.*/linetorm/g ; }" $fich
        sed -i "/line0torm/,/____________/ { 0,/#.*/s/#.*/linetorm/g ; }" $fich
        sed -i "/line0torm/,/____________/ { 0,/#.*/s/#.*/linetorm/g ; }" $fich
        sed -n -i -e '/line0torm/r kw.tmp' -e 1x -e '2,${x;p}' -e '${x;p}' $fich
        sed -i '/line0torm/d' $fich
        sed -i '/linetorm/d' $fich
    done
    rm -f kw.tmp
  done
  echo "bond new features: done"
exit
#  ;;
#  replace_line )
  echo "numerical new features: in progress"
old_char="# safe_dt= upscale(1)= upscale(2)= damping="
new_char="# safe_dt= upscale(1)= upscale(2)= damping= fixed_dt= random_seed="
  for fich in $list ; do
    old=$(grep -c "$old_char" $fich)
    new=$(grep -c "$new_char" $fich)
    if [ "$new" = "0" -a "$old" != "0" ];then
#       echo "treating  $fich"
       sed -i "s|$old_char|$new_char|g" $fich
    fi
  done

old_char="# safe_dt= upscale(1)= upscale(2)= damping= fixed_dt= random_seed= fixed_dt="
new_char="# safe_dt= upscale(1)= upscale(2)= damping= fixed_dt= random_seed="
  for fich in $list ; do
    old=$(grep -c "$old_char" $fich)
    new=$(grep -c "$new_char" $fich)
    if [ "$new" = "0" -a "$old" != "0" ];then
#       echo "treating  $fich"
       sed -i "s|$old_char|$new_char|g" $fich
    fi
  done
  echo "numerical new features: in progress"
#esac
rm -f filelist
# to return to the proper prompt
 exit
 

