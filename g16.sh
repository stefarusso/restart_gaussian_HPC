#!/bin/bash
#SBATCH -N1 -n8
#SBATCH --time=23:00:00
#SBATCH --mem=6Gb
#SBATCH --error  job.err
#SBATCH --output job.out
#SBATCH --account=IscrC_LLL_0      
#SBATCH --partition=gll_usr_prod

module load autoload
module load profile/chem-phys
module load g16/C.01

. $g16root/g16/bsd/g16.profile       # for bash script

export GAUSS_SCRDIR=$CINECA_SCRATCH/g16_$SLURM_JOBID  # def. tmp folder in $CINECA_SCRATCH
mkdir  -p $GAUSS_SCRDIR                      # the dir must exist

# CHECK THAT RWF IS PRESENT
set -- *rwf
if [ ! -f "$1" ]
then
timeout 5m g16 < *first.com > first.log
fi

#LOOP OF THE RESTART JOBS
timeout 23h g16 < *loop.com > $NOME.log
if [[ $? -eq 124 ]]; then
  sbatch g16.sh
fi
