args <- commandArgs(trailingOnly = TRUE)
seed <- ifelse(length(args) >= 1, as.integer(args[1]), 20250610)

library(tidyverse)
library(cmdstanr)

model_name = "exam_3l-lmm_ZARdHdARmHm"
file_name = str_glue("{model_name}_{seed}")

output_dir_lmm = str_glue("stan/draws/{file_name}")

if (dir.exists(output_dir_lmm)) {
  file.remove(list.files(output_dir_lmm, full.names = TRUE))
} else {
  dir.create(output_dir_lmm) 
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
                      thin = 1, 
                      seed = seed, 
                      refresh = 1000, 
                      show_messages = TRUE)

write_rds(lmm_fit, str_glue("stan/{file_name}.rds"))

lmm_summary <- lmm_fit$summary()

write_csv(lmm_summary, str_glue("stan/summary/{file_name}_summary.csv"))