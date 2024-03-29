% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/urrplot.R
\name{urrplot}
\alias{urrplot}
\title{Region plot to demarcate URR and NURR for the bounded box}
\usage{
urrplot(parameters, deltalow, deltahigh, Rlow, Rhigh, e)
}
\arguments{
\item{parameters}{A vector of parameters (real numbers) that is generated by estimating the short, intermediate and auxiliary regressions.}

\item{deltalow}{The lower limit for delta.}

\item{deltahigh}{The upper limit for delta.}

\item{Rlow}{The lower limit for Rmax.}

\item{Rhigh}{The upper limit for Rmax.}

\item{e}{The step size of the grid in the x and y directions.}
}
\value{
A plot object created by ggplot
}
\description{
Region plot to demarcate URR and NURR for the bounded box
}
\examples{

## Load data set
data("NLSY_IQ")
 
## Set age and race as factor variables
NLSY_IQ$age <- factor(NLSY_IQ$age)
NLSY_IQ$race <- factor(NLSY_IQ$race)
   
## Collect parameters from the short, intermediate and auxiliary regressions
parameters <- collect_par(
data = NLSY_IQ, outcome = "iq_std", 
treatment = "BF_months", 
control = c("age","sex","income","motherAge","motherEDU","mom_married","race"),
other_regressors = c("sex","age"))

## Set limits for the bounded box
Rlow <- parameters$Rtilde
Rhigh <- 0.61
deltalow <- 0.01
deltahigh <- 0.99
e <- 0.01

## Create region plot for bounded box
p1 <- urrplot(parameters, deltalow, deltahigh, Rlow, Rhigh, e=e)

## See plot
print(p1)
 
}
