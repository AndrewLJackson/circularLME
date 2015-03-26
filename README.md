# circularLME
Bayesian circular linear models with random effects. Development of code to fit multi-level linear models for analysing directional data from a repeated measures factorial design experimental protocol. Currently the code generates some simulated data. The plan is for fitting to be done via [STAN](http://mc-stan.org) with a von Mises distribution on the likelihood. Differences in both accuracy and precision among the treatments are important, as we need to identify not only which individuals are behaving non-randomly, but also to allow comparison of means among the groups. It should be possible to acheive this via the two-parameter [von Mises distribution](http://en.wikipedia.org/wiki/Von_Mises_distribution) by specifying shape and location separately for each treatment group.

## Progress
* I currently have a script to generate a hierarchical structure of data, with a treatment group, and a control, for repeated measures on a number of individuals.
* I have a STAN model set up to fit a very basic von Mises model (implemented in 'one_group_von_mises.R') to some circular data comprising a number of independent observations comprising a single group. This is very capable of estimating the two parameters mu and kappa of the von Mises distribution (see notes below).
* I have a STAN model to compare mean (accuracy) and concentration (precision) between two treatment groups (implemented in 'two_groups_von_mises.R').
* Next steps are:
  * implement a random effect term in the single group situation.
    * ? should the random effects manifest on both μ and κ?
  * implement the random effect term in the two group situation.
  * generalise the code to allow for multiple explanatory variables including multiple fixed factors, linear covariates and interactions.

## The von Mises distribution
More information at [wikipedia](http://en.wikipedia.org/wiki/Von_Mises_distribution) where i took the following useful information on the parameters:
* μ is a measure of location (the distribution is clustered around μ), and
* κ is a measure of concentration (a reciprocal measure of dispersion, so 1/κ is analogous to σ2).
  * If κ is zero, the distribution is uniform, and for small κ, it is close to uniform. I understand this as corresponding to the null hypothesis of complete random choice in direction between trials.
  * If κ is large, the distribution becomes very concentrated about the angle μ with κ being a measure of the concentration. In fact, as κ increases, the distribution approaches a normal distribution in x  with mean μ and variance 1/κ.


## Collaborators
John Kirwan, Dan-Eric Nilsson and Jochen Smolka all from University of Lund [Vision Group](http://biology.lu.se/research/research-groups/lund-vision-group)
