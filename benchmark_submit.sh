#!/bin/sh
#PBS -l select=1
#PBS -l walltime=01:00:00
#PBS -l filesystems=home
#PBS -A NAQMC_RMD_aesp_CNDA

# Change to working directory
cd ${PBS_O_WORKDIR}
echo Jobid: $PBS_JOBID

module load intel-pti

export OMP_NUM_THREADS=1

now=$(date +"%m-%d-%Y")

if [[ ! -d ~/DCMESH/benchmark_results/lfd/Sunspot/${now} ]]
then
    mkdir -p ~/DCMESH/benchmark_results/lfd/Sunspot/${now}
fi

for i in {1..3}; do
  for j in {1..3}; do
    for k in {1..3}; do
      for n in {1..9}; do
        rm control_lfd/bench_system.in
        ln -s /home/razakh/DCMESH_COMPUTE_CUR_M/control_lfd/benchmark_system_"$i"_"$j"_"$k"_"$n".in control_lfd/bench_system.in
        unitrace -d -o ~/DCMESH/benchmark_results/lfd/Sunspot/${now}/lfd_kernels_O${OMP_NUM_THREADS}_"$i"_"$j"_"$k"_"$n" ../../../bin/lfd -p float
      done
    done
  done
done
