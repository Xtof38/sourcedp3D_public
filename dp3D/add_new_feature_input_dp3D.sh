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

file2treat="input_dp3D"
#file2treat="input_gas"

#$file2treat files that are needed:

#to decomment for the real thing:
#################################################################
find /home/"$theuser" -name "$file2treat" > filelist
find /home0/"$theuser"/ -name "$file2treat" >> filelist
#################################################################

#find /home/$theuser -name "input_gas" > filelist
#find /home0/$theuser/ -name "input_gas" >> filelist

list=$(cat filelist)

# for testing:
#list='/home/chris/sourcedp3D/test_before_commit/test/nplast1/isost_aff_rot/$file2treat'
#list='/home/chris/sourcedp3D/test_before_commit/reference/nplast1/bending/$file2treat'
#list='/home/chris/sourcedp3D/test_before_commit/reference/nplast1/split_cylin/$file2treat'
#list='/home/chris/sourcedp3D/dp3D_examples/crush_cluster/$file2treat'
#list='/home0/chris/compact01/test_cubes/SIMAP/input_dp3D'

#case $option in
#  add_line ) 
#  beware kw_to_modify must be inserted also below
  kw_to_modify="# numerical parameters:"
  line_to_obtain1="# safe_dt= upscale(1)= upscale(2)= damping= fixed_dt= random_seed="
  line_to_obtain2="# potential_contact="
  echo $kw_to_modify > kw.tmp
  echo $line_to_obtain1 >> kw.tmp
  echo $line_to_obtain2 >> kw.tmp
#  echo $line_to_obtain3 >> kw.tmp
  echo "bond new features: in progress"
  for fich in $list ; do
    echo "treating  $fich"
# replaces only between line0 and $long_line

    sed -i "/# numerical parameters:/,/____________/ { 0,/#.*/s/#.*/line0torm/g ; }" $fich
    sed -i "/line0torm/,/____________/ { 0,/#.*/s/#.*/linetorm/g ; }" $fich
    sed -i "/line0torm/,/____________/ { 0,/#.*/s/#.*/linetorm/g ; }" $fich
#    sed -i "/line0torm/,/____________/ { 0,/#.*/s/#.*/linetorm/g ; }" $fich
    sed -n -i -e '/line0torm/r kw.tmp' -e 1x -e '2,${x;p}' -e '${x;p}' $fich
    sed -i '/line0torm/d' $fich
    sed -i '/linetorm/d' $fich
  done
  rm -f kw.tmp
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
 

