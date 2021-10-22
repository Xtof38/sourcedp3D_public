#!/bin/sh

###########################################################################
# This is a script to obtain a correct new input_gas
###########################################################################

# Christophe.martin@grenoble-inp.fr   
# first created april 2013

#BINARY=/usr/local/dp3D/
theuser=`whoami`

#input_gas files that are needed:
filelist=` find /home/$theuser -name "input_gas"` 
echo "patching into /home/$theuser"
for fich in $filelist ; do
    old=$(grep -c "cristallite_size" $fich)
    if [ "$old" != "0" ];then
      echo "treating  $fich"
      sed '/#/s/cristallite_size/aggregate_size/g' $fich > tmp
      aggregate=$(grep -c "bonded_aggregate" tmp)
      if [ "$aggregate" = "2" ];then
        sed '/number/!s/particle_size=/aggregate_size=/g' tmp > tmp1
        sed 's/cristallite_size=/particle_size=/g' tmp1 > tmp
      fi
      sed 's/cristallite sizes/aggregate sizes/g' tmp > $fich
      rm -f tmp tmp1
    fi
done
filelist=` find /home0/$theuser/ -name "input_gas"`
echo "patching into /home0/$theuser"
 
for fich in $filelist ; do
    old=$(grep -c "cristallite_size" $fich)
    if [ "$old" != "0" ];then
      echo "treating  $fich"
      sed '/#/s/cristallite_size/aggregate_size/g' $fich > tmp
      aggregate=$(grep -c "bonded_aggregate" tmp)
      if [ "$aggregate" = "2" ];then
        sed '/number/!s/particle_size=/aggregate_size=/g' tmp > tmp1
        sed 's/cristallite_size=/particle_size=/g' tmp1 > tmp
      fi
      sed 's/cristallite sizes/aggregate sizes/g' tmp > $fich
      rm -f tmp tmp1
    fi
done
# to return to the proper prompt
 exit
 

