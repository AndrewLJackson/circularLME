# circularLME
Bayesian circular linear models with random effects. Development of code to fit multi-level linear models for analysing directional data from a repeated measures factorial design experimental protocol. Currently the code generates some simulated data. The plan is for fitting to be done via [STAN](http://mc-stan.org) with a von Mises distribution on the likelihood. Differences in both accuracy and precision among the treatments are important, as we need to identify not only which individuals are behaving non-randomly, but also to allow comparison of means among the groups. It should be possible to acheive this via the two-parameter [von Mises distribution](http://en.wikipedia.org/wiki/Von_Mises_distribution) by specifying shape and location separately for each treatment group.

## Collaborators
John Kirwan, Dan-Eric Nilsson and Jochen Smolka all from University of Lund [Vision Group](http://biology.lu.se/research/research-groups/lund-vision-group)
