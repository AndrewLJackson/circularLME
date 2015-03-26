// -----------------------------------------------------------------------------
data {
  int<lower=0> n; // number of observations  
  real y[n];
  int group[n];
}

// -----------------------------------------------------------------------------
parameters { 
  real<lower=0, upper=100> kappa[2];
  real<lower=0, upper=2*pi()> beta[2];

}

// -----------------------------------------------------------------------------
transformed parameters {
  
  

}

// -----------------------------------------------------------------------------
model {

  // Priors

  beta[1] ~ uniform(0, 2 * pi() );
  beta[2] ~ uniform(0, 2 * pi() );
  kappa[1] ~ uniform(0, 100);
  kappa[2] ~ uniform(0, 100);
  
  // Likelihood
  for (i in 1:n)
    y[i] ~ von_mises(beta[group[i]], kappa[group[i]]);

  
}
