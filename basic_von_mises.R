# script to fit a very simple von Mises distribution to a single group of data

# generate some data according to a wrapped-normal distribution
y <- rwrappednormal(50, 
                    mu=pi, 
                    rho=0.8, 
                    control.circular = list(units="radians"))

# calculate the maximum likelihood estimates of these data according to a
# von Mises distribution

fit.mle <- mle.vonmises(y)



# plot the data
par(mfrow=c(1,2))
rose.scale = 1.5
rose.diag(y, prop=rose.scale, 
          main = "Distributions" )

plot(y, col="black", stack=FALSE,
     main = "Raw data")

# fit the von Mises model using STAN

library(rstan)

vm_dat <- list( n = length(y), y = as.numeric(y))

fit <- stan(file = 'one_group_von_mises.stan', data = vm_dat, 
            iter = 2000, chains = 4)

# plot the posterior estimates
plot(fit)

# extract the raw posterior samples
postd <- extract(fit)

# generate a circular histogram of the posterior estimates of the mean
par(mfrow=c(1,2))

rose.diag(circular(postd$mu), radii.scale = "linear", prop = 2.5, bins = 360/5,
          main = "mu (MLE in red, pop in black)")
points(circular(fit.mle$mu), col = "red")
points(circular(pi), pch = 15, col = "black")

hist(postd$kappa, freq=F, main = "Kappa (MLE in red)")
abline(v=fit.mle$kappa, col="red", lwd = 2, lty = 2)

