# generate some simple random data describing random directions.
# The data to be generated will represent a number of treatment groups, with 
# the first group representing a control. The control will take uniform random
# directions around the circle, and so will have mean of pi, but with complete
# representation of angles. The treatment groups will have a specified mean, 
# and a specified standard devation of angle. In this way, we need to be able to
# do two things with the data: compare the means of the treatment groups, and
# also identify which groups are behaving differently to random. That is, 
# we need to be able to test both the accuracy and precision of the data.
# So far the code starts off quite generic, and can generate data for lots of 
# groups, but i have later assumed that there are only two groups for ease of 
# plotting.

library(circular)

# how many treatment groups
G <- 2 # in this case a treatment and a control

# how many individuals in each group
M <- 5

# how many observations on the same individual
N <- 10

# ------------------------------------------------------------------------------
# generate the matrix for the data with columns for the angle data y, 
# treatment group, and ID of the individual.

n.obs <- G * M * N # number of observations in total
circ.dat <- data.frame(y =  double(n.obs), 
                       group =  sort(rep(1:G, M*N)), ID = sort(rep(1:(M*G), N)))


                      

# specify a full set of completely random directions for the control group.
# That is, the concentration value rho = 0.
circ.dat[1:(M*N), 1] <- circular::rwrappednormal(M*N, mu=circular(0), rho=0, 
                                       control.circular = list(units="radians"))

# loop through and specify means and rhos for each of the other treatment groups
for (i in 2:G) {
  start.idx <- (i-1)*N*M + 1 
  end.idx <- i*M*N
  
  # here i have specified a high concentration value of rho=0.98 to ensure high
  # high precision in the treatment group.
  a <- rwrappednormal(M,
                      mu=circular(runif(1,0,2*pi)),
                      rho=0.93, 
                      control.circular = list(units="radians"))
  
  # this is a bit lazy of me to use sort() to collect the replicated mean terms.
  mu.grp <- sort(rep(a, N)) 
  
  # pull random wrapped normal numbers for each individual with their
  # appropriate unique, individual-level mean value.
  circ.dat[start.idx:end.idx, 1] <- rwrappednormal(M*N, 
                                                   mu=mu.grp, 
                                                   rho=0.98, 
                                                   control.circular = 
                                                    list(units="radians"))
}


# ------------------------------------------------------------------------------
# Visualise the data using rose diagram circular histograms and raw circular 
# plots.
par(mfrow=c(1,2))
rose.scale = 1.5
rose.diag(circular(circ.dat[circ.dat[,2]==1,1]), col="black", prop=rose.scale, 
          main = "Distributions" )
rose.diag(circular(circ.dat[circ.dat[,2]==2,1]), col="red", prop=rose.scale,
          add=TRUE)

plot(circular(circ.dat[circ.dat[,2]==1,1]), col="black", stack=FALSE,
     main = "Raw data")
points(circular(circ.dat[circ.dat[,2]==2,1]), col="red", pch="x", stack=FALSE)

# ------------------------------------------------------------------------------
# now loop through and plot each individual on its own panel
par(mfrow=c(2,5))
for (i in 1:(G*M)){
  
  # find indices matching the ith individual
  idx <- circ.dat[,3] == i
  
  # determine which colour to use for the appropriate treatment
  clr <- circ.dat[which(idx)[1],2]
  
  # plot each individual's N data points on a separate panel
  plot(circular(circ.dat[idx,1]), col = clr)
}

# ------------------------------------------------------------------------------
# now with data generated, we need to try to recover this information using a
# linear mixed effects model with a von Mises distribution on the errors...
# (though a wrapped normal as used to generate these data is also possible
# if the likelihood exists in STAN).








