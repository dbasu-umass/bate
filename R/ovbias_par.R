#' Compute bias adjusted treatment effect taking data frame as input.
#'
#' @param data Data frame.
#' @param outcome Outcome variable.
#' @param treatment Treatment variable.
#' @param control Control variables to add in the intermediate regression.
#' @param other_regressors Subset of control variables to add in the short regression (default is NULL). 
#' @param deltalow The lower limit of delta.
#' @param deltahigh The upper limit of delta.
#' @param Rhigh The upper limit of Rmax.
#' @param e The step size.
#'
#' @return List with three elements:
#' 
#' \item{Data}{Data frame containing the bias and bias-adjusted treatment effect for each point on the grid}
#' \item{bias_Distribution}{Quantiles (2.5,5.0,50,95,97.5) of the empirical distribution of bias}
#' \item{bstar_Distribution}{Quantiles (2.5,5.0,50,95,97.5) of the empirical distribution of the bias-adjusted treatment effect}
#' 
#' @export
#'
#' @examples 
#' ## Load data set
#' data("NLSY_IQ")
#'  
#' ## Set parameters for bounded box
#' Rhigh <- 0.61
#' deltalow <- 0.01
#' deltahigh <- 0.99
#' e <- 0.01
#' 
#' ## Compute bias and bias-adjusted treatment effect
#' OVB_par <- ovbias_par(data=NLSY_IQ,
#' outcome="iq_std",treatment="BF_months", 
#' control=c("age","sex","income","motherAge","motherEDU","mom_married","race"), 
#' other_regressors = c("sex","age"), deltalow=deltalow, 
#' deltahigh=deltahigh, Rhigh=Rhigh, e=e)
#'
#' ## Default quantiles of bias
#' OVB_par$bias_Distribution
#' 
#' # Default quantiles of bias-adjusted treatment effect
#' OVB_par$bstar_Distribution
#' 
ovbias_par <- function(data,outcome,treatment,control,other_regressors=NULL,deltalow,deltahigh,Rhigh,e){
  
  # Call collect_par()
  parameters <- collect_par(data=data,outcome=outcome,treatment=treatment,
                            control=control,other_regressors=other_regressors)
  
  # Call ovbias and return
  return(ovbias(parameters,deltalow,deltahigh,Rhigh,e))
}
