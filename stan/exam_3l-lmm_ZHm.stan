/*
Three-level model for Exam data 
3l = three-level
lmm = linear mixed-effect model
Z = add covariate(s)
ARd = autoregressive process for days
Hd =  heterogeneity of variances/standard deviations between days
ADm = autoregressive process for moments
Hm = heterogeneity of variances/standard deviations between moments
*/


functions {
  // ar(1) correlation matrix generator
  matrix ar1_corr_matrix(int m, real phi) {
    matrix[m, m] h;
    for (i in 1:m)
      for (j in 1:m)
        h[i, j] = phi ^ abs(i - j);
    return h;
  }
}

data {
  int<lower=1> N; // number of subjects
  int<lower=1> D; // number of days
  int<lower=1> M; // number of time points
  int<lower=0, upper=N*D*M> N_obs; // number of observed values
  int<lower=0, upper=N*D*M> N_mis; // number of missing values
  array[N_obs] int<lower=1, upper=N*D*M> ii_obs; // index of observed values
  array[N_mis] int<lower=1, upper=N*D*M> ii_mis; // index of missing values
  vector[N_obs] y_obs; // affect scores
  vector[N*D*M] z_obs; // know the exam results or not (0=before, 1=after)
}

parameters {
  // Missing values
  vector[N_mis] y_mis;

  // Fixed effect
  // beta
  real beta; // ground mean

  // Random effect
  // s_raw
  vector[N] s_raw; // (non-centered) subject effect 
  real<lower=0> psi_s; // population sd for the subject effect
  // b_raw
  vector[N] b_raw; // (non-centered) effect for knowing exam results
  real<lower=0> psi_b; // population sd for the knowing eaxm results effect
  // d_raw
  array[N] vector[D] d_raw; // (non-centered) day(/subject) effect
  real<lower=0> psi_d; // population sd for the day effect (heterogenity between days)
  
  // Measurement error
  // epsilon
  vector<lower=0>[M] sigma_epsilon; // population sd for the measurment error (heterogenity between moments)
}

transformed parameters {
  // y, z reformate
  vector[N_obs+N_mis] y_vec;
  y_vec[ii_obs] = y_obs;
  y_vec[ii_mis] = y_mis;

  array[N, D] vector[M] y;
  array[N, D] vector[M] z;
  for (i in 1:N) {
    for (j in 1:D) {
      y[i, j] = y_vec[((i-1)*D*M + (j-1)*M + 1):((i-1)*D*M + (j-1)*M + M)];
      z[i, j] = z_obs[((i-1)*D*M + (j-1)*M + 1):((i-1)*D*M + (j-1)*M + M)];
    }
  }

  // Random effect
  // s
  vector[N] s = psi_s * s_raw; // subject effect
  // b
  vector[N] b = psi_b * b_raw; // knowing exam result effect 
  // d
  array[N] vector[D] d; // day(/subject) effect
  for (i in 1:N) {
    d[i] = psi_d .* d_raw[i];
  }

  // epsilon 
  cov_matrix[M] Sigma = diag_matrix(sigma_epsilon^2);
  matrix[M, M] L_Sigma = cholesky_decompose(Sigma);
}

model {
  vector[N] mu_i;
  array[N] vector[D] mu_ij;

  // Likelihood
  // Level 3:
  mu_i = beta + s;
  s_raw ~ std_normal();
  b_raw ~ std_normal();

  for (i in 1:N) {
    // Level 2:
    mu_ij[i] = mu_i[i] + d[i];
    d_raw[i] ~ std_normal();

    for (j in 1:D) {
      // Level 1:
      y[i, j] ~ multi_normal_cholesky(rep_vector(mu_ij[i, j], M) + z[i, j] * b[i] , L_Sigma);
    }
  }

  // Priors
  psi_s ~ cauchy(0, 2.5) T[0, ];
  psi_d ~ cauchy(0, 2.5) T[0, ];
}  

generated quantities {
  array[N, D] vector[M] y_hat; // fitted values
  for (i in 1:N) {
    for (j in 1:D) {
      y_hat[i, j] = rep_vector(beta + s[i] + d[i, j], M) + z[i, j] * b[i];
    }
  }

  real rel_T = (psi_s^2 + psi_d^2) / (psi_s^2 + psi_d^2 + mean(sigma_epsilon^2)); // R_T
}
