# script to fit a very simple von Mises distribution to a single group of data

# Generate some data according to a wrapped-normal distribution.
# Two groups, one with mean pi and the other pi/2. Group 1 acts like a control
# with approximate uniform random distribution of directions, while Group 2
# displays a relatively high degree of precision.

n.obs <- 100 # number of observations per group

# group 1 - NB, with rho set to 0, mu is meaningless and should in theory be
# able to take any value
y1 <- rwrappednormal(n.obs, 
                    mu = pi + numeric(n.obs), 
                    rho = 0, 
                    control.circular = list(units="radians"))

# group 2 - has relatively high precision.
y2 <- rwrappednormal(n.obs, 
                     mu = (pi / 2) + numeric(n.obs), 
                     rho = 0.8, 
                     control.circular = list(units="radians"))

y <- c(y1, y2)

# a grouping factor
group = c(1 + numeric(n.obs), 2 + numeric(n.obs))

# calculate the maximum likelihood estimates of these data according to a
# von Mises distribution

fit.mle.group1 <- mle.vonmises(y[group==1])
fit.mle.group2 <- mle.vonmises(y[group==2])


# plot the data
par(mfrow=c(1,2))
rose.scale = 1.5
rose.diag(y[group == 1], prop=rose.scale, 
          main = "Distributions" )
rose.diag(y[group == 2], prop=rose.scale, add = TRUE, col='red')

plot(y[group == 1], col="black", stack=FALSE,
     main = "Raw data")
points(y[group == 2], col="red")

# fit the von Mises model using STAN

library(rstan)

vm_dat <- list( n = length(y), y = as.numeric(y), group = group)

fit <- stan(file = 'two_groups_von_mises.stan', data = vm_dat, 
            iter = 2000, chains = 4)

# plot the posterior estimates
plot(fit)

# extract the raw posterior samples
postd <- extract(fit)

# ------------------------------------------------------------------------------
# generate a circular histogram of the posterior estimates of the mean
par(mfrow=c(2,2))

# rose diagram of group 1's mean
rose.diag(circular(postd$beta[,1]), radii.scale = "linear",
          prop = 10, bins = 360/5,
          main = "mu[1] (MLE in red, pop in black)")
points(circular(fit.mle.group1$mu), col = "red")
points(circular(pi), pch = 15, col = "black")

# rose diagram of group 2's mean
rose.diag(circular(postd$beta[,2]), radii.scale = "linear",
          prop = 2.5, bins = 360/5,
          main = "mu[2] (MLE in red, pop in black)")
points(circular(fit.mle.group2$mu), col = "red")
points(circular(pi/2), pch = 15, col = "black")

# histogram of group 1's concentration
hist(postd$kappa[,1], freq=F, main = "Kappa[1] (MLE in red)")
abline(v=fit.mle.group1$kappa, col="red", lwd = 2, lty = 2)

# histogram of group 2's concentration
hist(postd$kappa[,2], freq=F, main = "Kappa[2] (MLE in red)")
abline(v=fit.mle.group2$kappa, col="red", lwd = 2, lty = 2)

