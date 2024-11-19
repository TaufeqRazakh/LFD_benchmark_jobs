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

if [[ ! -d ~/DCMESH_COMPUTE_CUR_M/benchmark_results/lfd/Sunspot/${now} ]]
then
    mkdir -p ~/DCMESH_COMPUTE_CUR_M/benchmark_results/lfd/Sunspot/${now}
fi

for i in {32..96..32}; do
  for j in {32..96..32}; do
    for k in {32..96..32}; do
      for n in {32..288..32}; do
        rm control_lfd/bench_system.in
        ln -s /home/razakh/DCMESH_COMPUTE_CUR_M/control_lfd/benchmark_system_"$i"_"$j"_"$k"_"$n".in control_lfd/bench_system.in
        unitrace -d -o ~/DCMESH_COMPUTE_CUR_M/benchmark_results/lfd/Sunspot/${now}/lfd_kernels_O${OMP_NUM_THREADS}_"$i"_"$j"_"$k"_"$n" ../../../bin/lfd -p float
      done
    done
  done
done
