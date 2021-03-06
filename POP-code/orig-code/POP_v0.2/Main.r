#////////////////////////////////////////////////////////
#### POP TMB: compile C++ template, to run only once ####
#////////////////////////////////////////////////////////

# If package: this compilation would occur during the installation
# for the moment, here, the user has to run the compile() command manually

library(TMB)
compile("POP.cpp") # do this only once


#/////////////////////////////////////////////////////////////////////
#### POP TMB: load data, build POPobj, fit model, display outputs ####
#/////////////////////////////////////////////////////////////////////

### load compiled code
library(TMB)
dyn.load(dynlib("POP")) # to run every time R is restarted


### source R function for building POPobj and for fitting
source('POPbuild.r')
source('POPfit.r')


### load all data files
Ct <- read.table('POPdata/Ct.txt') # catch
ma <- as.numeric(unlist(read.table('POPdata/ma.txt'))) # prop-at-age mature
wa1 <- as.numeric(unlist(read.table('POPdata/wa1.txt'))) # weight females
wa2 <- as.numeric(unlist(read.table('POPdata/wa2.txt'))) # weight males
S1t <- read.table('POPdata/S1t.txt') # survey 1: West Coast Vancouver Island
S2t <- read.table('POPdata/S2t.txt') # survey 2: National Marine Fisheries Service
S3t <- read.table('POPdata/S3t.txt') # survey 3: GB Reed
patC1 <- read.table('POPdata/patC1.txt') # prop-at-age catch females
patC2 <- read.table('POPdata/patC2.txt') # prop-at-age catch males
ntC <- read.table('POPdata/ntC.txt') # number trips prop-at-age catch
patS11 <- read.table('POPdata/patS11.txt') # prop-at-age survey 1 females
patS12 <- read.table('POPdata/patS12.txt') # prop-at-age survey 1 males
ntS1 <- read.table('POPdata/ntS1.txt') # number trips prop-at-age survey 1
MiscFixedParam <- read.table('POPdata/MiscFixedParam.txt', # additional fixed param
                             header=T) # selectivity survey 2 and 3, sigmaR


### build POPobj
popobj <- POPbuild(survey1=S1t,survey2=S2t,survey3=S3t,
                   paa.catch.female=patC1,paa.catch.male=patC2,
                   n.trips.paa.catch=ntC,
                   paa.survey1.female=patS11,paa.survey1.male=patS12,
                   n.trips.paa.survey1=ntS1,
                   catch=Ct,paa.mature=ma,weight.female=wa1,weight.male=wa2,
                   misc.fixed.param=MiscFixedParam,
                   theta.ini=NULL, # if NULL, uses default values
                   lkhd.paa="normal", # "normal" or "binomial"
                   var.paa.add=TRUE, # T or F
                   enable.priors=TRUE) # T or F

str(popobj) # datalist and parlist are the formatted objects for TMB


### fit model to data
fit <- POPfit(POPobj=popobj,trace=TRUE)


### Table of estimated fixed parameters and their standard errors
table.theta <- cbind(fit$theta,fit$se.theta)
dimnames(table.theta)[[2]] <- c('Estimate','s.e.')
round(table.theta,3)


### Plot predicted recruits (random effect) with +- 2s.e. as envelope
lb.R <- fit$R-2*fit$se.R
ub.R <- fit$R+2*fit$se.R

plot(popobj$years,fit$R,type='o',xlab='years',ylab='Recruits',pch=19,cex=0.5,
     ylim=c(1500,7500),main=paste0('Predicted recruits, real POP data'))
polygon(x=c(popobj$years,popobj$years[popobj$TC:1]),
        y=c(lb.R,ub.R[popobj$TC:1]),col='#4f4f4f40',border=NA)


### Plot predicted biomass with +- 2s.e. as envelope
lb.B <- fit$B-2*fit$se.B
ub.B <- fit$B+2*fit$se.B

plot(popobj$years,fit$B,type='o',xlab='years',ylab='SSB',pch=19,cex=0.5,
     ylim=c(0,27000),main=paste0('Predicted biomass, real POP data'))
polygon(x=c(popobj$years,popobj$years[popobj$TC:1]),
        y=c(lb.B,ub.B[popobj$TC:1]),col='#4f4f4f40',border=NA)


### can do the same plot for: V, u, u at age, etc.
str(fit)





#////////////////////////////////////////////////////////////////////////
#### POP TMB: load data, simulate data, build POPobj, fit and output ####
#////////////////////////////////////////////////////////////////////////

### load compiled code
library(TMB)
dyn.load(dynlib("POP")) # to run every time R is restarted


### source R function for simulating data and for fitting
source('POPsim.r')
source('POPfit.r')


### load all data files, only for design
Ct <- read.table('POPdata/Ct.txt') # catch
ma <- as.numeric(unlist(read.table('POPdata/ma.txt'))) # prop-at-age mature
wa1 <- as.numeric(unlist(read.table('POPdata/wa1.txt'))) # weight females
wa2 <- as.numeric(unlist(read.table('POPdata/wa2.txt'))) # weight males
S1t <- read.table('POPdata/S1t.txt') # survey 1: West Coast Vancouver Island
S2t <- read.table('POPdata/S2t.txt') # survey 2: National Marine Fisheries Service
S3t <- read.table('POPdata/S3t.txt') # survey 3: GB Reed
patC1 <- read.table('POPdata/patC1.txt') # prop-at-age catch females
patC2 <- read.table('POPdata/patC2.txt') # prop-at-age catch males
ntC <- read.table('POPdata/ntC.txt') # number trips prop-at-age catch
patS11 <- read.table('POPdata/patS11.txt') # prop-at-age survey 1 females
patS12 <- read.table('POPdata/patS12.txt') # prop-at-age survey 1 males
ntS1 <- read.table('POPdata/ntS1.txt') # number trips prop-at-age survey 1
MiscFixedParam <- read.table('POPdata/MiscFixedParam.txt', # additional fixed param
                             header=T) # selectivity survey 2 and 3, sigmaR


### simulate random effects and responses, then builds POPobj
popsimobj <- POPsim(survey1=S1t,survey2=S2t,survey3=S3t,
                    paa.catch.female=patC1,paa.catch.male=patC2,
                    n.trips.paa.catch=ntC,
                    paa.survey1.female=patS11,paa.survey1.male=patS12,
                    n.trips.paa.survey1=ntS1,
                    catch=Ct,paa.mature=ma,weight.female=wa1,weight.male=wa2,
                    misc.fixed.param=MiscFixedParam,
                    theta.ini=NULL, # if NULL, uses default values
                    lkhd.paa="binomial", # "normal" or "binomial"
                    var.paa.add=TRUE, # T or F
                    enable.priors=TRUE) # T or F


### fit model to simulated data
fitsim <- POPfit(POPobj=popsimobj,trace=TRUE)


### Table of estimated fixed parameters, their standard errors and the true theta
table.theta <- cbind(popsimobj$true.theta,fitsim$theta,fitsim$se.theta)
dimnames(table.theta)[[2]] <- c('True','Estimate','s.e.')
round(table.theta,3)


### Plot predicted recruits with +- 2s.e. as envelope, with true recuits overlaid
lb.R <- fitsim$R-2*fitsim$se.R
ub.R <- fitsim$R+2*fitsim$se.R

plot(popsimobj$years,fitsim$R,type='o',xlab='years',ylab='Recruits',pch=19,cex=0.5,
     ylim=c(2000,7000),main=paste0('Predicted recruits, simulated data'))
polygon(x=c(popsimobj$years,popsimobj$years[popsimobj$TC:1]),
        y=c(lb.R,ub.R[popsimobj$TC:1]),col='#4f4f4f40',border=NA)
lines(popsimobj$years,popsimobj$true.R,col='red')


### Plot predicted biomass with +- 2s.e. as envelope, with true biomass overlaid
lb.B <- fitsim$B-2*fitsim$se.B
ub.B <- fitsim$B+2*fitsim$se.B

plot(popsimobj$years,fitsim$B,type='o',xlab='years',ylab='SSB',pch=19,cex=0.5,
     ylim=c(2000,22000),main=paste0('Predicted biomass, simulated data'))
polygon(x=c(popsimobj$years,popsimobj$years[popsimobj$TC:1]),
        y=c(lb.B,ub.B[popsimobj$TC:1]),col='#4f4f4f40',border=NA)
lines(popsimobj$years,popsimobj$true.B,col='red')



