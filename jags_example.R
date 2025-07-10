# Load the jagsUI package
library(jagsUI)

# 1. Prepare the data for the JAGS model
# This is a simulated dataset for demonstration purposes.
# In a real scenario, you would load your actual data.
set.seed(123)
N <- 50 # Number of subjects
D <- 3  # Number of days
M <- 4  # Number of measurements per day

# Simulate some data
beta_true <- 10
psi_s_true <- 2
psi_b_true <- 1.5
psi_d_true <- c(0.5, 0.8, 0.6)
sigma_epsilon_true <- c(1, 1.2, 0.9, 1.1)
sigma_omega_m_true <- 0.7
phi_m_true <- 0.5

s_true <- rnorm(N, 0, psi_s_true)
b_true <- rnorm(N, 0, psi_b_true)
d_true <- matrix(NA, N, D)
for (j in 1:D) {
  d_true[, j] <- rnorm(N, 0, psi_d_true[j])
}

z <- array(rbinom(N * D * M, 1, 0.5), dim = c(N, D, M)) # Covariate for b

y <- array(NA, dim = c(N, D, M))
omega <- array(NA, dim = c(N, D, M))

for (i in 1:N) {
  for (j in 1:D) {
    omega[i, j, 1] <- rnorm(1, 0, sigma_omega_m_true)
    for (k in 2:M) {
      omega[i, j, k] <- rnorm(1, phi_m_true * omega[i, j, k-1], sigma_omega_m_true)
    }
    for (k in 1:M) {
      mu_true <- beta_true + s_true[i] + d_true[i, j] + z[i, j, k] * b_true[i] + omega[i, j, k]
      y[i, j, k] <- rnorm(1, mu_true, sigma_epsilon_true[k])
    }
  }
}

# Data list for JAGS
jags_data <- list(
  N = N,
  D = D,
  M = M,
  y = y,
  z = z
)

# 2. Define parameters to monitor
parameters_to_monitor <- c(
  "beta", "psi_s", "psi_b", "psi_d", "sigma_epsilon",
  "sigma_omega_m", "phi_m", "rel_T"
)

# 3. Specify initial values for the chains (optional but recommended)
# You can provide a function or a list of lists for initial values.
# Here, we provide a function to generate random initial values.
inits_function <- function() {
  list(
    beta = rnorm(1, 0, 1),
    psi_s = runif(1, 0.1, 5),
    psi_b = runif(1, 0.1, 5),
    psi_d = runif(D, 0.1, 5),
    sigma_epsilon = runif(M, 0.1, 5),
    sigma_omega_m = runif(1, 0.1, 5),
    phi_m = runif(1, -0.9, 0.9),
    s = rnorm(N, 0, 1),
    b = rnorm(N, 0, 1),
    d = matrix(rnorm(N * D, 0, 1), N, D),
    omega = array(rnorm(N * D * M, 0, 1), dim = c(N, D, M))
  )
}

# 4. Run the JAGS model using jagsUI
# The model file is 'jags/exam_3l-lmm_ZHdARmHm_wRId_jags.txt'
# Adjust n.chains, n.iter, n.burnin, n.thin as needed for convergence.
fit <- jags(
  data = jags_data,
  inits = inits_function,
  parameters.to.save = parameters_to_monitor,
  model.file = "jags/exam_3l-lmm_ZHdARmHm_wRId_jags.txt",
  n.chains = 3,
  n.adapt = 1000, # Number of adaptation iterations
  n.iter = 5000,  # Total number of iterations per chain
  n.burnin = 2000, # Number of burn-in iterations
  n.thin = 2,     # Thinning rate
  parallel = TRUE # Use parallel processing if possible
)

# 5. Summarize the results
print(fit)

# 6. Plot the results (e.g., trace plots and density plots)
# This will open new plot windows.
plot(fit)

# You can also access specific results:
# Summary statistics:
# fit$summary

# MCMC samples:
# fit$samples

# Rhat values (Gelman-Rubin diagnostic):
# fit$Rhat

# Effective sample sizes:
# fit$n.eff

# Example of accessing a specific parameter's summary:
# fit$summary["beta", ]

# Example of accessing MCMC samples for a specific parameter:
# beta_samples <- fit$samples[, "beta"]
# hist(beta_samples)