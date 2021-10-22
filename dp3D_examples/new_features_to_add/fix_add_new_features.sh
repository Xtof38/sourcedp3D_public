#!/bin/sh

###########################################################################
# This is a script to obtain a correct input_dp3D when adding new features
###########################################################################

# Christophe.martin@grenoble-inp.fr   
# first created may 2013

#BINARY=/usr/local/dp3D/
theuser=`whoami`

#option="replace_line"

#input_dp3D files that are needed:

#to decomment for the real thing:
#################################################################
find /home/"$theuser" -name "input_dp3D" > filelist
find /home0/"$theuser"/ -name "input_dp3D" >> filelist
#################################################################

#find /home/$theuser -name "input_gas" > filelist
#find /home0/$theuser/ -name "input_gas" >> filelist

list=$(cat filelist)

# for testing:
#list='/home/chris/sourcedp3D/test_before_commit/test/nplast1/isost_aff_rot/input_dp3D'
#list='/home/chris/sourcedp3D/test_before_commit/reference/nplast1/bending/input_dp3D'
#list='/home/chris/sourcedp3D/test_before_commit/reference/nplast1/split_cylin/input_dp3D'
#list='/home/chris/sourcedp3D/dp3D_examples/sinter_ramp_temperature/input_dp3D'
#case $option in
#  add_line ) 
#  beware kw_to_modify must be inserted also below
  kw_to_modify="# bond key words:"
  line_to_obtain1="# large_bonds_full large_bonds small_bonds geom toughness impinge "
  line_to_obtain2="# clump_cluster beam stiffness iso_bonds= psi_bar= "
  line_to_obtain3="# strength_deviation= unload_stiff_ratio="
  echo "bond new features: in progress"
  for fich in $list ; do
#    echo "treating  $fich"
# replaces only between line0 and $long_line
    n=$(grep -n "^bonds" $fich | sed 's/:bonds//')
    nn=$(grep "# bond key words:" $fich)
    if [ "$n" != "" -a "$nn" = "" ];then
      let n=n+2
      awk -v n="$n" -v s="$kw_to_modify" 'NR == n {print s} {print}' $fich > tmp
      mv tmp $fich
      let n=n+1
      awk -v n="$n" -v s="$line_to_obtain1" 'NR == n {print s} {print}' $fich > tmp
      mv tmp $fich
      let n=n+1
      awk -v n="$n" -v s="$line_to_obtain2" 'NR == n {print s} {print}' $fich > tmp
      mv tmp $fich
      let n=n+1
      awk -v n="$n" -v s="$line_to_obtain3" 'NR == n {print s} {print}' $fich > tmp
      mv tmp $fich
    fi
  done
  echo "bond new features: done"
rm -f filelist
# to return to the proper prompt
 exit
 

