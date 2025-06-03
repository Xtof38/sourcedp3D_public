# runs dp3D or cdp3D as in the manual:
here=$(pwd)
# in order of appearance in the manual:
list_directories_dp3D="generate_gaz_particles gaz_to_pack closedie_compact composite unl_rel cylinder  \
                       crushing crush_cluster eff_prop_bonded_aggregate toughness buckling fiber Brazilian_test thermal_shock clumps \
                       large_dens sinter_velocity sinter_ramp_temperature sinter_cylinder sinter_grain_growth closedie_viscoplast gaz_to_pack_cluster \
                       viscoplasticity_stress_control generate_gaz_clusters"

ist_directories_dp3D="gaz_to_pack closedie_compact composite unl_rel cylinder  \
                       crushing crush_cluster eff_prop_bonded_aggregate toughness buckling fiber Brazilian_test thermal_shock clumps \
                       large_dens sinter_velocity sinter_ramp_temperature sinter_cylinder sinter_grain_growth closedie_viscoplast gaz_to_pack_cluster \
                       viscoplasticity_stress_control generate_gaz_clusters"


case $1 in
  -all | -all_test )
#  cdp3D -gas > suivi
  for dir in $list_directories_dp3D; do
    cd "$here"/"$dir"
    generate=$(echo $dir | grep -c generate)
    if [ $generate = "0" ];then
      case $1 in
        -all )      
           dp3D -openMP4 > suivi_"$dir"
      ;;
        -all_test )
           dp3D -test > suivi_"$dir"
      esac
    else
      cdp3D -gas > suivi_"$dir"
    fi
  done
  ;;
  -100istep | -100istep_test )
  for dir in $list_directories_dp3D ; do
    cd $here/$dir
    generate=$(echo $dir | grep -c generate)
    if [ $generate = "0" ];then
      oksed=$(grep -c "# sigzz<=" input_dp3D)
      if [ "$oksed" = 1 ];then
        cp input_dp3D input_dp3D_save
        sed -n -i '/# sigzz<=/{p;:a;N;/_/!ba;s/.*\n/timestep>=100\n/};p' input_dp3D
        case $1 in
          -100istep )      
             dp3D -openMP4 > suivi_100istep_"$dir"
        ;;
          -100istep_test )
             dp3D -test > suivi_100istep_"$dir"
        esac
        job_done_ok=$(grep "job done" suivi_100istep_"$dir")
        if [ "$job_done_ok" = "" ];then
          echo "Job NOT done in test: $dir"
        else
          echo "Job done in test: $dir"
          rm -f input_dp3D
          mv input_dp3D_save input_dp3D 
#	  if [ -f input_dp3D_updated ];then
#            echo "input_dp3D_updated file found in test : $dir" 
#	    diff input_dp3D input_dp3D_updated
#	    toget=$(diff input_dp3D_updated input_dp3D | grep -2w "timestep>=100" | tail -1 | sed 's/> //')
#            echo "back to initial stop condition: $toget"    
#	    sed -i "s|timestep>=100|$toget|1" input_dp3D_updated 
#	    yn_clean="0"
#	    while [ "$yn_clean" != "n" -a "$yn_clean" != "y" ];do
#             read -e -p "replace input_dp3D  by input_dp3D_updated ? (y/n)" -i "n" yn_clean
#            done
#            if [ "$yn_clean" = "y" ];then
#	      mv input_dp3D_updated input_dp3D
#	    fi
#	  fi
        fi
      else
        echo "pb for sed to find '# sigzz<=' in test : $dir"    
	exit  
      fi
    else
      cdp3D -gas > suivi_"$dir"
    fi

  done
  ;;
  -clean )
  for dir in $list_directories_dp3D; do
    cd "$here"/"$dir"
    generate=$(echo $dir | grep -c generate)
    if [ $generate = "1" ];then
      rm -f file_init*
    fi
    cleandp3D -f
    rm -f suivi*
    rm -f ivdp3D
    rm -f *xyz
    rm -f *tmp
  done
  ;;
  -update )
  for dir in $list_directories_dp3D; do
    if [ -f "$dir/input_dp3D_updated" ];then
      toget=$(diff $dir/input_dp3D_updated $dir/input_dp3D | grep -2w "timestep>=100" | tail -1 | sed 's/> //')
      echo "back to initial stop condition: $toget"   
      sed -i "s|timestep>=100|$toget|1" $dir/input_dp3D_updated 
      mv -f "$dir/input_dp3D_updated" "$dir/input_dp3D"
      echo "$dir/input_dp3D  updated"
    fi
  done    
  ;;
  * )  
  echo "$0 usage: "
  echo "$0  -all      --> runs all simulations (long!)"
  echo "$0  -100istep --> runs all simulations for the first 100 timesteps"
  echo "$0  -clean    --> cleans the result files of all simulations"
  echo "$0  -update   --> update input_dp3D from input_dp3D_updated"
  exit
esac





