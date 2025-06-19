#!/bin/bash -l
#SBATCH --account=lp_ppw_okp
#SBATCH --cluster=wice
#SBATCH --partition=batch_icelake
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --cpus-per-task=2
#SBATCH --time=1-00:00:00
#SBATCH --mail-type=All
#SBATCH --mail-user=tzu-yao.lin@kuleuven.be
#SBATCH --job-name=exam_3l-ssm

cd $VSC_SCRATCH
cd exam_analysis

module load R
export OMP_NUM_THREADS=1

Rscript run_exam_3l-ssm_all.R $model_name $seed &> job/log/{$model_name}_{$seed}.log
