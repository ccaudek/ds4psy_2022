
data {
  int<lower=0> N; 
  vector[N] y; 
  vector[N] x; 
}
transformed data {
  vector[N] x_std;
  vector[N] y_std;
  x_std = (x - mean(x)) / sd(x);
  y_std = (y - mean(y)) / sd(y);
}
parameters {
  real alpha_std;
  real beta_std;
  real<lower=0> sigma_std;
}
transformed parameters {
  vector[N] mu_std = alpha_std + beta_std * x_std; 
}
model {
  alpha_std ~ normal(0, 1); 
  beta_std ~ normal(0, 1);  
  sigma_std ~ normal(0, 1); 
  y_std ~ normal(mu_std, sigma_std); 
}
generated quantities {
  // transform to the original data scale
  real alpha;
  real beta;
  real<lower=0> sigma;
  alpha = sd(y) * (alpha_std - beta_std * mean(x) / sd(x)) + mean(y);
  beta = beta_std * sd(y) / sd(x);
  sigma = sd(y) * sigma_std;
}
