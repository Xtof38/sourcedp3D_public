#!/bin/sh

###########################################################################
# This is a script to obtain a correct input_dp3D when adding new features
###########################################################################

# Christophe.martin@grenoble-inp.fr   
# first created may 2013

#BINARY=/usr/local/dp3D/
theuser=`whoami`

#input_dp3D files that are needed:

find /home/$theuser -name "input_dp3D" > filelist
find /home0/$theuser/ -name "input_dp3D" >> filelist
#find /home/$theuser -name "input_gas" > filelist
#find /home0/$theuser/ -name "input_gas" >> filelist

list=$(cat filelist)

# for testing:
#list='/home/chris/sourcedp3D/test_before_commit/test/nplast1/isost_aff_rot/input_dp3D'
#list='/home/chris/sourcedp3D/dp3D_examples/buckling/input_dp3D'
old_char="# T_init= T_final= time="
new_char="# none T_init= T_final= time="


#fich="input_dp3D"
for fich in $list ; do
    old=$(grep -c "$old_char" $fich)
    new=$(grep -c "$new_char" $fich)
    if [ "$new" = "0" -a "$old" != "0" ];then
       echo "treating  $fich"
       sed -i "s|$old_char|$new_char|g" $fich
    fi
done
rm -f filelist
# to return to the proper prompt
 exit
 

