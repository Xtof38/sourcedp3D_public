# runs dp3D or cdp3D as in the manual:
here=$(pwd)
# in order of appearance in the manual:
list_directories_dp3D="generate_gaz_particles gaz_to_pack closedie_compact composite unl_rel cylinder  \
                       crushing crush_cluster eff_prop_bonded_aggregate toughness buckling fiber thermal_shock clumps \
                       large_dens sinter_velocity sinter_ramp_temperature sinter_grain_growth closedie_viscoplast gaz_to_pack_cluster \
                       viscoplasticity_stress_control generate_gaz_clusters"

#list_directories_dp3D="sinter_ramp_temperature"


case $1 in
  -all )
#  cdp3D -gas > suivi
  for dir in $list_directories_dp3D; do
    cd "$here"/"$dir"
    generate=$(echo $dir | grep -c generate)
    if [ $generate = "0" ];then
      dp3D -openMP4 > suivi_"$dir"
    else
      cdp3D -gas > suivi_"$dir"
    fi
  done
  ;;
  -100istep )
  for dir in $list_directories_dp3D ; do
    cd $here/$dir
    generate=$(echo $dir | grep -c generate)
    if [ $generate = "0" ];then
      cp input_dp3D input_dp3D_save
      sed -n -i '/fracture=/{p;:a;N;/_/!ba;s/.*\n/timestep=100\n/};p' input_dp3D
      dp3D -openMP4 > suivi_100istep_"$dir"
      job_done_ok=$(grep "job done" suivi_100istep_"$dir")
      if [ "$job_done_ok" = "" ];then
        echo "Job NOT done in test: $dir"
      else
        echo "Job done in test: $dir"
      fi
      rm -f input_dp3D
      mv input_dp3D_save input_dp3D 
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
  * )  
  echo "$0 usage: "
  echo "$0  -all      --> runs all simulations (long!)"
  echo "$0  -100istep --> runs all simulations for the first 100 timesteps"
  echo "$0  -clean    --> cleans the result files of all simulations"
  exit
esac





