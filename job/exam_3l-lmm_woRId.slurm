#!/bin/bash -l
#SBATCH --account=lp_ppw_okp
#SBATCH --cluster=wice
#SBATCH --partition=batch_icelake
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=5
#SBATCH --time=1-00:00:00
#SBATCH --mail-type=All
#SBATCH --mail-user=tzu-yao.lin@kuleuven.be
#SBATCH --job-name=exam_3l-lmm
cd $VSC_SCRATCH
cd exam_analysis

module load R
export OMP_NUM_THREADS=1
Rscript run_exam_3l-lmm_all.R exam_3l-lmm_ZARdHdARmHm_woRId 20250708 &> job/log/exam_3l-lmm_ZARdHdARmHm_woRId_20250708.log
#Rscript run_exam_3l-ssm_all.R exam_3l-ssm_ZARdHdARmHm_woRId 20250708 &> job/log/exam_3l-ssm_ZARdHdARmHm_woRId_20250708.log