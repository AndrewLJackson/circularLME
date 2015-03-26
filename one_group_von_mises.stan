// -----------------------------------------------------------------------------
data {
  int<lower=0> n; // number of observations  
  real y[n];
}

// -----------------------------------------------------------------------------
parameters { 
  real<lower=0, upper=100> kappa;
  real<lower=0, upper=2*pi()> mu;

}

// -----------------------------------------------------------------------------
transformed parameters {
  
  

}

// -----------------------------------------------------------------------------
model {

  // Priors

  mu ~ uniform(0, 2 * pi() );
  kappa ~ uniform(0, 100);
  
  // Likelihood

  y ~ von_mises(mu, kappa);

  
}
