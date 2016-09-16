################ get credible intervals ############################

get_credible_intervals <- function(circ.param.vec, alpha){

  circ.param.vec      <- as.circular(as.vector(circ.param.vec), type = "angles", units = "radians", zero = 0, rotation = "counter")
  param.mean          <- mean.circular(circ.param.vec)      # get circular mean
  diff.mean.pi        <- (pi - param.mean)                  # difference between circular mean and pi
  cnt.param.vec       <- circ.param.vec + diff.mean.pi      # values moved around pi

    param.pi.index = data.frame(); cred.ints = vector()
    for(i in 1:length(cnt.param.vec)){
    if(cnt.param.vec[i] < 0){cnt.param.vec[i] <-  cnt.param.vec[i] + 2*pi}                # get everything to be between 0 amd 2*pi
    else if(cnt.param.vec[i] >= 2*pi){cnt.param.vec[i] <-  cnt.param.vec[i] - 2*pi}
    param.pi.index[i,1] <- abs(cnt.param.vec[i] - pi)                                       # diffs of num from circular mean
    param.pi.index[i,2] <- i       }

    param.pi.index <- param.pi.index[order(param.pi.index[1]),]   # order by smallest distANCE FROM MEAN
    n <- ceiling(length(circ.param.vec)*alpha)                      # get index of posterior value
    range.param.pi.index <- param.pi.index[1:n,1:2]                # excludes the furthest values from mean
    credible.int.vals <- cnt.param.vec[range.param.pi.index[,2]]   # get the correspinding values from the index
    cred.ints[1]  <- min(credible.int.vals)
    cred.ints[2]  <- max(credible.int.vals)            # upper and lower values, with mean still moved to pi
    cred.ints <- cred.ints - diff.mean.pi              # return to actual values around param mean

    for(i in 1:2){
         if(cred.ints[i] < 0){cred.ints[i] <-  cred.ints[i] + 2*pi}                # keep within 0 and 2*pi
         else if(cred.ints[i] >= 2*pi){cred.ints[i] <-  cred.ints[i] - 2*pi}  }

    cred.ints <- t(as.data.frame(cred.ints))
    colnames(cred.ints) <- c("Lower Credible Interval","Upper Credible Interval")

    return(cred.ints) }
