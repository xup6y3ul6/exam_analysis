# Receive shell arguments outside the Rscript
args <- commandArgs(trailingOnly = TRUE)

model_name <- ifelse(length(args) >= 1, args[1], "exam_3l-ssm_ZARdHdARmHm")
seed <- ifelse(length(args) >= 2, as.integer(args[2]), 20250619)

# load packages
library(tidyverse)
library(cmdstanr)
library(posterior)

is_ARd <- str_detect(model_name, "ARd")
is_Hd <- str_detect(model_name, "Hd")
is_ARm <- str_detect(model_name, "ARm")
is_Hm <- str_detect(model_name, "Hm")

file_name <- str_glue("{model_name}_Seed{seed}")
if (length(args) >= 3) {
  file_name <- paste(file_name, args[3], sep = "_")
}

#===========================================

cat("Run MCMC by Stan \n")

output_dir_lmm = str_glue("stan/draws/{file_name}")

if (dir.exists(output_dir_lmm)) {
  file.remove(list.files(output_dir_lmm, full.names = TRUE))
} else {
  dir.create(output_dir_lmm, recursive = TRUE)
}

data <- read_rds("data/exam_data.rds")
lmm_data <- lst(N = 101, D = 9, M = 10, 
                N_mis = sum(data$Missing),
                N_obs = N*D*M - N_mis,
                ii_obs = which(!data$Missing), 
                ii_mis = which(data$Missing),
                y_obs = data$Neg_aff[ii_obs],
                z_obs = data$Get_grade)

lmm <- cmdstan_model(str_glue("stan/{model_name}.stan"))

lmm_fit <- lmm$sample(data = lmm_data, 
                      chains = 4, 
                      parallel_chains = 4,
                      output_dir = output_dir_lmm, 
                      iter_warmup = 4000, 
                      iter_sampling = 4000,
                      thin = 10, 
                      seed = seed, 
                      refresh = 1000, 
                      show_messages = TRUE)

write_rds(lmm_fit, str_glue("stan/{file_name}.rds"))

cat("Finished the MCMC sampling.\n")

#===========================================

cat("Calulate the summary of MCMC draws.\n")

lmm_summary <- lmm_fit$summary()
write_csv(lmm_summary, str_glue("stan/summary/{file_name}_summary.csv"))

cat("Finish the simulation procedure.\n")
