#!/bin/sh
theuser=`whoami`


#to decomment for the real thing:
#################################################################
find /home/"$theuser" -name "input_dp3D" > filelist
find /home0/"$theuser"/ -name "input_dp3D" >> filelist
#################################################################

list=$(cat filelist)
#list='/home/chris/compact01/Moise/porous_ceramics_fracture/toughness_model/D060/rou062/tensile/input_dp3D'
# for testing:
#list='/home/chris/sourcedp3D/test_before_commit/test/nplast1/isost_aff_rot/input_dp3D'
#list='/home/chris/sourcedp3D/test_before_commit/reference/nplast1/bending/input_dp3D'
#list='/home/chris/sourcedp3D/test_before_commit/reference/nplast1/split_cylin/input_dp3D'
#list='/home0/chris/compact01/mech_test_on_tomo_image_freeze_cast/MEB/portion_SEM_1_Y/input_dp3D'

  for fich in $list ; do
    there=$(grep -wc "fixed_dt" "$fich")
#    notthere=$(grep -c "# bond key words:" "$fich")
    if [ $there = "1" ];then
      echo "$fich"
    fi
  done
    
